$Script:tmpl = @{
    Html5 = @'
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">

    <title>PSProfiler - {0}</title>
    <style>
    #footer {{
        height: 50px;
        padding: 10px;
        font-style: italic;
        color: #CCCCCC;
    }}
    #pspui-container {{
        margin-bottom: 50px;
    }}
    body {{
        font-family: Sans-Serif;
      }}
    .centered {{
        top: 50px;
        margin: auto;
        padding: 10px;
      }}
    #ast-container {{
        cursor: default;
        padding-right: 50px;
      }}
      #ast-container span {{
        cursor: pointer;
      }}
      table td {{
        vertical-align: top;
      }}
      
      #statement-list td {{
        font-family: monospace, monospace;
      }}      
    </style>
</head>

<body>
<div id="pspui-container" class="centered">
<p><h2>PSProfiler Report</h2></p>
<hr />
      <div id="ui-container">
        {2}
        </div>
        <div id="footer">Powered by <a href="https://github.com/IISResetMe/PSProfiler">PSProfiler</a> © 2021 <a href="https://github.com/IISResetMe">@IISResetMe</a></div>
        </div>
    <script>
    {1}
    </script>
    </body>
</html>
'@

    UIContainer = @'
<table>
<thead>
<tr>
<th>Statement browser</th>
<th>Execution stats</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<div id="ast-container">
<pre>
{0}
</pre>
</div>
</td>
<td>
<div id="statement-list">
{1}
</div>
</td>
</tr>
</tbody>
</table>
'@

    SpanStart = '<span id="span-{0}-{1}" data-execution-time="{2}" data-execution-count="{3}">'
    SpanEnd   = '</span>'

    JScript = @'
    const allSpans = document.getElementsByTagName("span");
    const rc = document.getElementById("count-cell");
    const rt = document.getElementById("time-cell");
    function clickHandler(event) {
        var span = event.target;
        if(span.id.startsWith("span-")){
            var parts = span.id.split("-");
          if(parts.length == 3){
              var l = parts[1];
            var c = parts[2];
            
            for(var sp of allSpans){
                sp.style.backgroundColor = null;
                sp.style.borderBottom = "1px dashed";
            }
            span.style.backgroundColor = "#FFFF00";
            span.style.borderBottom = null;
            
            if('executionTime' in span.dataset){
                rt.innerText = span.dataset.executionTime;
                rc.innerText = span.dataset.executionCount;
            }
          }
        }
    }
    
    var container = document.getElementById("ast-container");
    if (container.addEventListener) {
        container.addEventListener('click', clickHandler, false);
    }
    else if (container.attachEvent) {
        container.attachEvent('onclick', function(e) {
            return clickHandler.call(container, e || window.event);
        });
    }
    for(var sp of allSpans){
        sp.style.backgroundColor = null;
        sp.style.borderBottom = "1px dashed";
    }
'@
}

function Generate-PSProfilerUI
{
    param(
        [Parameter(Mandatory)]
        [scriptblock]$ScriptBlock,

        [Parameter(Mandatory)]
        [string]$Name
    )

    $jscript = $tmpl['JScript']
#    $jscript = ''

    $Extent = $ScriptBlock.Ast.Extent

    $PSProfiler = [GranularProfiler]::new($Extent)
    $n = Visit-Ast $ScriptBlock.Ast -Profiler $PSProfiler

    $MeasureScriptblock = $n.NewAst.GetScriptBlock()
    $null = & $MeasureScriptblock @Arguments

    #$stmtList = Measure-Script -ScriptBlock $ScriptBlock |Select LineNo,ExecutionTime,@{Name='Count';Expression={$_.TimeLine.GetCount()}} |ConvertTo-Html -As Table -Fragment

    $stmtList = @'
<table id="res-table">
    <thead><tr><th>Count</th><th>Execution Time</th></tr></thead>
    <tbody><tr><td id="count-cell">&nbsp;</td><td id="time-cell">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></tr></tbody>
</table>
'@

    $extents = $PSProfiler.MeasuredExtents

    $spanned = [System.Text.StringBuilder]::new()
    $lines = $Extent.Text -split '\r?\n' 
    for($i = 0; $i -lt $lines.Length; $i++){
        $chars = $lines[$i].ToCharArray()
        for($j = 0; $j -lt $chars.Length; $j++){
            $extents |Where-Object { $_.StartLineNumber -eq $i + 1 -and $_.StartColumnNumber -eq $j + 1} |ForEach-Object {
                $id = $_.StartLineNumber,$_.StartColumnNumber,$_.EndLineNumber,$_.EndColumnNumber -join '_'
                $TL = $PSProfiler.TimeLines[$id]
                $t = $TL.GetTotal()
                $c = $TL.GetCount()
                [void]$spanned.AppendFormat($tmpl['SpanStart'], $i, $j, $t, $c)
            }
            $extents |Where-Object { $_.EndLineNumber -eq $i + 1 -and $_.EndColumnNumber -eq $j + 1} |ForEach-Object {
                [void]$spanned.Append($tmpl['SpanEnd'])
            }

            [void]$spanned.Append($chars[$j])

        }
        $extents |Where-Object { $_.EndLineNumber -eq $i + 1 -and $_.EndColumnNumber -eq $chars.Length + 1} |ForEach-Object {
            [void]$spanned.Append($tmpl['SpanEnd'])
        }
        if($i + 1 -ne $lines.Length){
            [void]$spanned.Append('<br/>')
        }
    }
    $uiContainer = $tmpl['UIContainer'] -f $spanned.ToString(),-join$stmtList

    return $tmpl['Html5'] -f $Name,$jscript,$uiContainer
}