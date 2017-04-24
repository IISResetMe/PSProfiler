$ErrorActionPreference = "Stop"

# Attempt to retrieve relevant script files
$Classes = Get-ChildItem (Join-Path $PSScriptRoot Classes) -ErrorAction SilentlyContinue -Filter *.class.ps1
$Public  = Get-ChildItem (Join-Path $PSScriptRoot Public)  -ErrorAction SilentlyContinue -Filter *.ps1
$Private = Get-ChildItem (Join-Path $PSScriptRoot Private) -ErrorAction SilentlyContinue -Filter *.ps1

# dot source them all
foreach($import in @($Classes;$Public;$Private))
{
    Try
    {
        . $import.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

# export public members
Export-ModuleMember -Function $Public.BaseName