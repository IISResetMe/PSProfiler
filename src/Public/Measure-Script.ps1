using namespace System.Management.Automation.Language
using namespace System.Collections.Generic
using namespace System.Diagnostics

#region Measure-Script
Function Measure-Script {
<#
.SYNOPSIS
    Measures the execution time of each of the statements of a script or scriptblock

.DESCRIPTION

    This is an re-implementation in pure PowerShell of the good old Measure-Script cmddlet found in SDK samples.   
    See: https://code.msdn.microsoft.com/Script-Line-Profiler-Sample-80380291

.PARAMETER ScriptBlock

    The ScriptBlock to be measured.

.PARAMETER Path

    The Path to a script to be measured.

.PARAMETER ExecutionResultVariable

    The name of a variable where the result of the execution will be stored. 

.PARAMETER VariableScope

    The variable scope for the ExecutionResultVariable. Default is 1, i.e. one level above the script execution inside this function.

.PARAMETER Arguments

    Arguments passed to the ScriptBlock or Script.

.EXAMPLE
    Measure-Script -ScriptBlock {
        Get-Service | ForEach-Object {
            $_.name + " is " + $_.Status
        }
    }

    This measures the script block and returns the times executed for each line in the script block.

    Anonymous ScriptBlock


      Count  Line       Time Taken Statement
      -----  ----       ---------- ---------
          0     1    00:00.0000000
          1     2    00:00.5196413         Get-Service | ForEach-Object {
        288     3    00:00.0902218             $_.name + " is " + $_.Status
          0     4    00:00.0000000         }
          0     5    00:00.0000000

.EXAMPLE
    Measure-Scipt -Path c:\PS\GenerateUsername.ps1 -Arguments @{GivenName = "Joe";Surname = "Smith"}

    This will execute and measure the c:\PS\GenerateUsername.ps1 script with the -GivenName and -Surname parameters.

#>
    [CmdletBinding(DefaultParameterSetName="ScriptBlock")]
    param(
        [Parameter(Mandatory=$true,ParameterSetName="ScriptBlock",Position=0)]
        [scriptblock]$ScriptBlock,
        [Parameter(Mandatory=$true,ParameterSetName="Path",Position=0)]
        [string]$Path,
        [Parameter(Mandatory=$false,ParameterSetName="__AllParametersets")]
        [string]$ExecutionResultVariable,
        [Parameter(Mandatory=$false,ParameterSetName="__AllParametersets")]
        [hashtable]$Arguments,
        [Parameter(Mandatory=$false,ParameterSetName="__AllParametersets")]
        [string]$Name
    )

    if($PSCmdlet.ParameterSetName -eq "Path") {
        if(-not (Test-Path $Path)) {
            throw "No such file: '$Path'"
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

        $ssiPropertyInfo = [scriptblock].GetProperty('SessionStateInternal', [System.Reflection.BindingFlags]'Instance,NonPublic')
        $callerSessionState = $ssiPropertyInfo.GetValue($ScriptBlock)
    }

    if($PSBoundParameters.Keys -icontains "Name"){
        $Source = "{0}: {1}$Name" -f $Source,$([System.Environment]::NewLine) 
    }

    $profiler = [Profiler]::new($Ast.Extent)
    $visitor  = [PSPVisitor]::new($profiler)
    $newAst   = $Ast.Visit($visitor)

    $MeasureScriptblock = $newAst.GetScriptBlock()

    if($PSCmdlet.ParameterSetName -eq "ScriptBlock"){
        $ssiPropertyInfo.SetValue($MeasureScriptblock, $callerSessionState)
    }

    if(-not $PSBoundParameters.ContainsKey('ExecutionResultVariable')){
        $null = & $MeasureScriptblock @Arguments
    }
    else {
        $executionResult = . $MeasureScriptblock @Arguments
    }

    [string[]]$lines = $Ast.Extent.ToString() -split '\r?\n' |ForEach-Object TrimEnd
    for($i = 0; $i -lt $lines.Count;$i++){
        [pscustomobject]@{
            LineNo        = $i + 1
            ExecutionTime = $profiler.TimeLines[$i].GetTotal()
            TimeLine      = $profiler.TimeLines[$i]
            Line          = $lines[$i]
            SourceScript  = $Source
            PSTypeName    = 'ScriptLineMeasurement'
        }
    }

    if($ExecutionResultVariable) {
        try{
            $PSCmdlet.SessionState.PSVariable.Set($ExecutionResultVariable, $executionResult)
        }
        catch{
            Write-Error -Message "Error encountered setting ExecutionResultVariable '`${$ExecutionResultVariable}'" -Exception $_
        }
    }
}

