function WhyScriptNoGoBrrrr
{
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

    . Measure-Script @PSBoundParameters |Sort-Object ExecutionTime |Select-Object -Last 1
}
