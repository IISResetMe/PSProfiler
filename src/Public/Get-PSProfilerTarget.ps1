using namespace System.Management.Automation.Language
using namespace System.Collections.Generic
using namespace System.Diagnostics

#region Measure-Script
Function Get-PSProfilerTarget {
    [CmdletBinding(DefaultParameterSetName="ScriptBlock")]
    param(
        [Parameter(Mandatory=$true,ParameterSetName="ScriptBlock",Position=0)]
        [scriptblock]$ScriptBlock,
        [Parameter(Mandatory=$true,ParameterSetName="Path",Position=0)]
        [string]$Path,
        [Parameter(Mandatory=$false,ParameterSetName="__AllParametersets")]
        [hashtable]$Arguments,
        [Parameter(Mandatory=$false,ParameterSetName="__AllParametersets")]
        [string]$Name
    )

    if($PSCmdlet.ParameterSetName -eq "Path") {
        if(-not (Test-Path $Path)) {
            throw "No such file: '$Path'"
            return
        }

        $Errors = @()
        $Ast = [Parser]::ParseFile((Get-Item $Path).FullName, [ref]$null, [ref]$Errors)
        if($Errors){
            Write-Error -Message "Encountered errors while parsing '$Path'"
        }

        $Source = $Path
    }
    else {
        $Ast = $ScriptBlock.Ast
        $Source = '{{{0}}}' -f (New-Guid)
        $Source = $Source -replace '-'
    }

    if($PSBoundParameters.Keys -icontains "Name"){
        $Source = "{0}: {1}$Name" -f $Source,$([System.Environment]::NewLine) 
    }

    $visitor  = [Describer]::new()
    $null     = $Ast.Visit($visitor)

    foreach($stmt in $visitor.InstrumentedStatements){
        [pscustomobject]@{
            LineNo        = $stmt.Extent.StartLineNumber
            Type          = $stmt.GetType().Name
            Extent        = $stmt.Extent
            PSTypeName    = 'ScriptLineMeasurementDescription'
        }
    }
}

