$ErrorActionPreference = "Stop"

# Attempt to retrieve relevant script files
$Public  = Get-ChildItem (Join-Path $PSScriptRoot Public)  -ErrorAction SilentlyContinue -Filter *.ps1
$Private = Get-ChildItem (Join-Path $PSScriptRoot Private) -ErrorAction SilentlyContinue -Filter *.ps1

# classes on which other classes might depend, must be specified in order
$ClassDependees = @(
    'TimeLine'
    'Profiler'
)

# import classes on which others depend first
foreach($classDependee in $ClassDependees)
{
    try{
        . (Join-Path (Join-Path $PSScriptRoot .\Classes) "$classDependee.class.ps1")
    }
    catch{
        Write-Error -Message "Failed to import class $($classDependee): $_"
    }
}

$Visitor = switch($PSVersionTable['PSVersion'].Major){
    {$_ -ge 7} {
        "AstVisitor7.class.ps1"
    }
    default {
        "AstVisitor.class.ps1"
    }
}

Write-Verbose "Loading '$Visitor'"
. (Join-Path (Join-Path $PSScriptRoot .\Classes) $Visitor)
# dot source the functions
foreach($import in @($Public;$Private))
{
    try{
        . $import.fullname
    }
    catch{
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

# export public members
Export-ModuleMember -Function $Public.BaseName