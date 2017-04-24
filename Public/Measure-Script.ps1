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

    LineNo ExecutionTime    Line                                    
    ------ -------------    ----                                    
         1 00:00:00                                                 
         2 00:00:00.0411606         Get-Service | ForEach-Object {  
         3 00:00:00.0170710             $_.name + " is " + $_.Status
         4 00:00:00                 }                               
         5 00:00:00                                                 

.EXAMPLE
    Measure-Scipt -Path c:\PS\GenerateUsername.ps1 -Arguments @{GivenName = "Joe";Surname = "Smith"}

    This will execute and measure the c:\PS\GenerateUsername.ps1 script with the -GivenName and -Surname parameters.
    
#>
    [cmdletbinding(DefaultParameterSetName="ScriptBlock")]
    param(
        [parameter(Mandatory=$true,ParameterSetName="ScriptBlock")]
        [scriptblock]$ScriptBlock,
        [parameter(Mandatory=$true,ParameterSetName="Path")]
        [string]$Path,
        [parameter(Mandatory=$false,ParameterSetName="__AllParametersets")]
        [string]$ExecutionResultVariable,
        [parameter(Mandatory=$false,ParameterSetName="__AllParametersets")]
        [hashtable]$Arguments
    )
    if($PSBoundParameters.Keys -icontains "Path") {
        if(-not (Test-Path $path)) {       
            throw "No such file"
        }
        $ScriptText = Get-Content $path -Raw 
        $ScriptBlock = [scriptblock]::Create($ScriptText)
        $Source = $path
    } 
    else {
        $Source = '{{{0}}}' -f (New-Guid)
        $Source = $Source -replace '-'
    }
    $ScriptBlock = [scriptblock]::Create($ScriptBlock.ToString())
    $profiler = [Profiler]::new($ScriptBlock.Ast.Extent)
    $visitor  = [AstVisitor]::new($profiler)
    $newAst   = $ScriptBlock.Ast.Visit($visitor)

    if(-not $PSBoundParameters.ContainsKey('ExecutionResultVariable')){
        $null = & $newAst.GetScriptBlock() @Arguments
    }
    else {
        $executionResult = . $newAst.GetScriptBlock() @Arguments
    }

    [string[]]$lines = $ScriptBlock.ToString() -split '\r?\n' |ForEach-Object TrimEnd
    for($i = 0; $i -lt $lines.Count;$i++){
        [pscustomobject]@{
            LineNo = $i+1 
            ExecutionTime = $profiler.TimeLines[$i].GetTotal()
            Line = $lines[$i]
            PSTypeName = 'ScriptLineMeasurement'
            SourceScript = $Source
        }
    }
    if($ExecutionResultVariable) {
        try{
            $PSCmdlet.SessionState.PSVariable.Set($ExecutionResultVariable, $executionResult)
        }
        catch{
            Write-Error -Message "Error encountered setting ExecutionResultVariable: $_"
        }
    }
}

