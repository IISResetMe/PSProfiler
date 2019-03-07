

Import-Module "$PSScriptRoot\..\src\MeasureScript.psd1" -Force

InModuleScope  "MeasureScript"{

    Describe '[Profiler]-[Constructors]'{

        
    It '[Profiler]-[Constructor]([IScriptExtent]extent) should Not Throw' {
    
    # -- Arrange
    
    $sb = [scriptblock]::Create("Get-Command")
    
    $extent= $sb.Ast.Extent
    
    # -- Act
    
    # -- Assert
    
    {[Profiler]::New($extent)} | Should Not Throw 
    
    }# end of it block
    
    
    }# end of Describe block
    Describe '[Profiler]-[Methods]'{
    
    #Public Method
    It '[Profiler] --> StartLine($lineNo) : [void] - should Not Throw' {
    
    # -- Arrange
    
    [int] $lineNo = 1
    $sb = [scriptblock]::Create("
    Get-Command
    Get-Process
    ")
    
    $extent= $sb.Ast.Extent
    # -- Act
    
    $Instance = [Profiler]::New($extent)
    
    # -- Assert
    
    {$Instance.StartLine($lineNo)} | Should Not Throw
    
    } #End It Block
    
    #Public Method
    It '[Profiler] --> StartLine($lineNo) Should not return anything (voided)' {
    
    # -- Arrange
    
    [int] $lineNo = 1
    $sb = [scriptblock]::Create("
    Get-Command
    Get-Process
    ")
    
    $extent= $sb.Ast.Extent
    # -- Act
    
    $Instance = [Profiler]::New($extent)
    # -- Assert
    
    $Instance.StartLine($lineNo)| should be $null
    
    } #End It Block
    
    #Public Method
    It '[Profiler] --> EndLine($lineNo) : [void] - should Not Throw' {
    
    # -- Arrange
    
    [int] $lineNo = 1
    $sb = [scriptblock]::Create("
    Get-Command
    Get-Process
    ")
    
    $extent= $sb.Ast.Extent
    # -- Act
    
    $Instance = [Profiler]::New($extent)
    
    # -- Assert
    
    {$Instance.EndLine($lineNo)} | Should Not Throw
    
    } #End It Block
    
    #Public Method
    It '[Profiler] --> EndLine($lineNo) Should not return anything (voided)' {
    
    # -- Arrange
    
    [int] $lineNo = 1
    $sb = [scriptblock]::Create("
    Get-Command
    Get-Process
    ")
    
    $extent= $sb.Ast.Extent
    # -- Act
    
    $Instance = [Profiler]::New($extent)
    # -- Assert
    
    $Instance.EndLine($lineNo)| should be $null
    
    } #End It Block
    
    }#EndDescribeBlock
}

