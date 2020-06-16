$ErrorActionPreference = "Stop"

# Attempt to retrieve relevant script files
$Classes = Get-ChildItem (Join-Path $PSScriptRoot Classes) -ErrorAction SilentlyContinue -Filter *.class.ps1
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

# import any remaining class files
foreach($class in $Classes|Where-Object {($_.Name -replace '\.class\.ps1') -notin $ClassDependees})
{
    try{
        . $class.fullname
    }
    catch{
        Write-Error -Message "Failed to import dependant class $($class.fullname): $_"
    }    
}

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