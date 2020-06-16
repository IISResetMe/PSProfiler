Import-Module "$PSScriptRoot\..\src\MeasureScript.psd1" -Force

InModuleScope -ModuleName MeasureScript -ScriptBlock {


Describe '[TimeLine]-[Constructors]'{

It '[TimeLine]-[Constructor] - Parameterless should Not Throw' {

# -- Arrange

# -- Act

# -- Assert

{[TimeLine]::New()} | Should Not Throw 

}# end of it block


}# end of Describe block
Describe '[TimeLine]-[Methods]'{

#Public Method
It '[TimeLine] --> Add($TimeSpan) : [void] - should Not Throw' {

# -- Arrange

[TimeSpan]$TimeSpan = New-TimeSpan

# -- Act

$Instance = [TimeLine]::New()

# -- Assert

{$Instance.Add($TimeSpan)} | Should Not Throw

} #End It Block

#Public Method
It '[TimeLine] --> Add($TimeSpan) Should not return anything (voided)' {

# -- Arrange
[TimeSpan]$TimeSpan = New-TimeSpan

# -- Act

$Instance = [TimeLine]::New()
# -- Assert

$Instance.Add($TimeSpan)| should be $null

} #End It Block

#Public Method
It '[TimeLine] --> GetTotal() : [TimeSpan] - should Not Throw' {

# -- Arrange

# -- Act

$Instance = [TimeLine]::New()

# -- Assert

{$Instance.GetTotal()} | Should Not Throw

} #End It Block

#Public Method
It '[TimeLine] --> GetTotal() : [TimeSpan] - should return type [TimeSpan]' {

# -- Arrange

# -- Act

$Instance = [TimeLine]::New()
# -- Assert

($Instance.GetTotal()).GetType().Name | should be TimeSpan

} #End It Block

#Public Method
It '[TimeLine] --> GetAverage() : [TimeSpan] - should Not Throw' {

# -- Arrange

$Instance = [TimeLine]::New()
# -- Assert
$TimeSpan = New-TimeSpan
$Instance.Add($TimeSpan)
# -- Assert

{$Instance.GetAverage()} | Should Not Throw

} #End It Block

#Public Method
It '[TimeLine] --> GetAverage() : [TimeSpan] - should return type [TimeSpan]' {

# -- Arrange
$Instance = [TimeLine]::New()

#--Act

$TimeSpan = New-TimeSpan
$Instance.Add($TimeSpan)

# -- Assert

($Instance.GetAverage()).GetType().Name | should be TimeSpan

} #End It Block

#Public Method
It '[TimeLine] --> GetCount() : [int] - should Not Throw' {

# -- Arrange

$Instance = [TimeLine]::New()
# -- Assert

$TimeSpan = New-TimeSpan
$Instance.Add($TimeSpan)

# -- Assert

{$Instance.GetCount()} | Should Not Throw

} #End It Block

#Public Method
It '[TimeLine] --> GetCount() : [int] - should return type [int]' {

# -- Arrange

# -- Act

$Instance = [TimeLine]::New()
# -- Assert

($Instance.GetCount()).GetType().Name | should be int32

} #End It Block

}#EndDescribeBlock

}#End InModuleScope


