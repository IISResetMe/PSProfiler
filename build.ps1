param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"

# Attempt to retrieve relevant script files
$Classes = Get-ChildItem (Join-Path $PSScriptRoot src\Classes) -ErrorAction SilentlyContinue -Filter *.class.ps1
$Public  = Get-ChildItem (Join-Path $PSScriptRoot src\Public)  -ErrorAction SilentlyContinue -Filter *.ps1
$Private = Get-ChildItem (Join-Path $PSScriptRoot src\Private) -ErrorAction SilentlyContinue -Filter *.ps1

# classes on which other classes might depend, must be specified in order
$ClassDependees = @(
    'TimeLine'
    'Profiler'
    'GranularProfiler'
)

$publishDir = New-Item -ItemType Directory -Path (Join-Path $PSScriptRoot publish\PSProfiler) @PSBoundParameters

$moduleFile = New-Item -Path $publishDir.FullName -Name "PSProfiler.psm1" -ItemType File @PSBoundParameters

@'
using namespace System.Collections.Generic
using namespace System.Management.Automation.Language
using namespace System.Diagnostics
'@ |Add-Content -LiteralPath $moduleFile.FullName @PSBoundParameters

# import classes on which others depend first
foreach($classDependee in $ClassDependees)
{
    try{
        Get-Content (Join-Path (Join-Path $PSScriptRoot src\Classes) "$classDependee.class.ps1") |Where-Object {$_ -notlike 'using namespace*'} |Add-Content -LiteralPath $moduleFile.FullName @PSBoundParameters
    }
    catch{
        Write-Error -Message "Failed to import class $($classDependee): $_"
    }
}

@'
$Visitor = switch($PSVersionTable['PSVersion'].Major){
    {$_ -ge 7} {
        "AstVisitor7.class.ps1"
    }
    default {
        "AstVisitor.class.ps1"
    }
}

Write-Verbose "Loading '$Visitor'"
. (Join-Path $PSScriptRoot $Visitor)
'@ |Add-Content -LiteralPath $moduleFile.FullName

# dot source the functions
foreach($import in @($Public;$Private))
{
    try{
        $import |Get-Content |Where-Object {$_ -notlike 'using namespace*'} |Add-Content -LiteralPath $moduleFile.FullName
    }
    catch{
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

"Export-ModuleMember -Function $($Public.BaseName -join ',')" |Add-Content -LiteralPath $moduleFile.FullName @PSBoundParameters
Copy-Item (Join-Path $PSScriptRoot src\PSProfiler.psd1) -Destination $publishDir.FullName @PSBoundParameters
Copy-Item (Join-Path $PSScriptRoot src\PSProfiler.format.ps1xml) -Destination $publishDir.FullName @PSBoundParameters
Copy-Item (Join-Path $PSScriptRoot src\Classes\AstVisitor*.class.ps1) -Destination $publishDir.FullName @PSBoundParameters -PassThru
