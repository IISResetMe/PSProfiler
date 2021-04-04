$Script:tmpl = @{
    Html5 = @'
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">

    <title>PSProfiler - {0}</title>
    <link rel="stylesheet" href="css/styles.css">
</head>

<body>
    {1}
    <div id="pspui-container">
        {2}
    </div>
</body>
</html>
'@

    UIContainer = @'
<div id="res-container">Clicked: <span id="res"></span></div>
<table>
<thead>
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

    SpanStart = '<span id="span-{0}-{1}">'
    SpanEnd   = '</span>'

    JScript = @'
const r = document.getElementById("res");
function clickHandler(event) {
    var span = event.target;
    if(span.id.startsWith("span-")){
        var parts = span.id.split("-");
        if(parts.length == 3){
            var l = parts[1];
        var c = parts[2];
        
        r.innerText = "Line " + l + ", position " + c;
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
    $jscript = ''

    $Extent = $ScriptBlock.Ast.Extent

    $PSProfiler = Visit-Ast $ScriptBlock.Ast

    $stmtList = Measure-Script -ScriptBlock $ScriptBlock |Select LineNo,ExecutionTime,@{Name='Count';Expression={$_.TimeLine.GetCount()}} |ConvertTo-Html -As Table -Fragment

    $extents = $PSProfiler.Profiler.MeasuredExtents

    $extents |Select *Number |Format-Table|Out-string|%{Write-Host $_ -ForegroundColor Green}

    $spanned = [System.Text.StringBuilder]::new()
    $lines = $Extent.Text -split '\r?\n' 
    for($i = 0; $i -lt $lines.Length; $i++){
        $chars = $lines[$i].ToCharArray()
        Write-Host "Line $($i + 1): $($chars.Length)"
        for($j = 0; $j -lt $chars.Length; $j++){
            $extents |Where-Object { $_.StartLineNumber -eq $i + 1 -and $_.StartColumnNumber -eq $j + 1} |ForEach-Object {
                [void]$spanned.AppendFormat($tmpl['SpanStart'], $i, $j)
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