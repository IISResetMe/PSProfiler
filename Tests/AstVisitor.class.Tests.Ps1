Import-Module "$PSScriptRoot\..\src\MeasureScript.psd1" -Force

InModuleScope -ModuleName MeasureScript -ScriptBlock {

Describe '[AstVisitor]-[Constructors]'{

It '[AstVisitor]-[Constructor]([Profiler]profiler) should Not Throw' {

# -- Arrange
$sb = [scriptblock]::Create("
    Get-Command
    Get-Process
    ")
    
$extent= $sb.Ast.Extent

[Profiler]$profiler=[Profiler]::New($extent)

# -- Act

# -- Assert

{[AstVisitor]::New($profiler)} | Should Not Throw 

}# end of it block


}# end of Describe block
Describe '[AstVisitor]-[Methods]'{

#Public Method
It '[AstVisitor] --> VisitElement($element) : [Object] - should Not Throw' {

# -- Arrange

[object]$element = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitElement($element)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitElement($element) : [Object] - should return type [Object]' {

# -- Arrange
[object]$element = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitElement($element)).GetType().Name | should be Object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitElements($elements) : [Object] - should Not Throw' {

# -- Arrange

[Object]$elements = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitElements($elements)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitElements($elements) : [Object] - should return type [Object]' {

# -- Arrange
[Object]$elements = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitElements($elements)).GetType().Name | should be Object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitStatements($Statements) : [StatementAst[]] - should Not Throw' {

# -- Arrange

[object]$Statements = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitStatements($Statements)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitStatements($Statements) : [StatementAst[]] - should return type [StatementAst]' {

# -- Arrange
[object]$Statements = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitStatements($Statements)).GetType().Name | should be StatementAst

} #End It Block

#Public Method
It '[AstVisitor] --> VisitScriptBlock($scriptBlockAst) : [object] - should Not Throw' {

# -- Arrange

[ScriptBlockAst] $scriptBlockAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitScriptBlock($scriptBlockAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitScriptBlock($scriptBlockAst) : [object] - should return type [object]' {

# -- Arrange
[ScriptBlockAst] $scriptBlockAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitScriptBlock($scriptBlockAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitNamedBlock($namedBlockAst) : [object] - should Not Throw' {

# -- Arrange

[NamedBlockAst] $namedBlockAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitNamedBlock($namedBlockAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitNamedBlock($namedBlockAst) : [object] - should return type [object]' {

# -- Arrange
[NamedBlockAst] $namedBlockAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitNamedBlock($namedBlockAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitFunctionDefinition($functionDefinitionAst) : [object] - should Not Throw' {

# -- Arrange

[FunctionDefinitionAst] $functionDefinitionAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitFunctionDefinition($functionDefinitionAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitFunctionDefinition($functionDefinitionAst) : [object] - should return type [object]' {

# -- Arrange
[FunctionDefinitionAst] $functionDefinitionAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitFunctionDefinition($functionDefinitionAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitStatementBlock($statementBlockAst) : [object] - should Not Throw' {

# -- Arrange

[StatementBlockAst] $statementBlockAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitStatementBlock($statementBlockAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitStatementBlock($statementBlockAst) : [object] - should return type [object]' {

# -- Arrange
[StatementBlockAst] $statementBlockAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitStatementBlock($statementBlockAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitIfStatement($ifStmtAst) : [object] - should Not Throw' {

# -- Arrange

[IfStatementAst] $ifStmtAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitIfStatement($ifStmtAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitIfStatement($ifStmtAst) : [object] - should return type [object]' {

# -- Arrange
[IfStatementAst] $ifStmtAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitIfStatement($ifStmtAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitTrap($trapStatementAst) : [object] - should Not Throw' {

# -- Arrange

[TrapStatementAst] $trapStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitTrap($trapStatementAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitTrap($trapStatementAst) : [object] - should return type [object]' {

# -- Arrange
[TrapStatementAst] $trapStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitTrap($trapStatementAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitSwitchStatement($switchStatementAst) : [object] - should Not Throw' {

# -- Arrange

[SwitchStatementAst] $switchStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitSwitchStatement($switchStatementAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitSwitchStatement($switchStatementAst) : [object] - should return type [object]' {

# -- Arrange
[SwitchStatementAst] $switchStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitSwitchStatement($switchStatementAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitDataStatement($dataStatementAst) : [object] - should Not Throw' {

# -- Arrange

[DataStatementAst] $dataStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitDataStatement($dataStatementAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitDataStatement($dataStatementAst) : [object] - should return type [object]' {

# -- Arrange
[DataStatementAst] $dataStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitDataStatement($dataStatementAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitForEachStatement($forEachStatementAst) : [object] - should Not Throw' {

# -- Arrange

[ForEachStatementAst] $forEachStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitForEachStatement($forEachStatementAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitForEachStatement($forEachStatementAst) : [object] - should return type [object]' {

# -- Arrange
[ForEachStatementAst] $forEachStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitForEachStatement($forEachStatementAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitDoWhileStatement($doWhileStatementAst) : [object] - should Not Throw' {

# -- Arrange

[DoWhileStatementAst] $doWhileStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitDoWhileStatement($doWhileStatementAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitDoWhileStatement($doWhileStatementAst) : [object] - should return type [object]' {

# -- Arrange
[DoWhileStatementAst] $doWhileStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitDoWhileStatement($doWhileStatementAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitForStatement($forStatementAst) : [object] - should Not Throw' {

# -- Arrange

[ForStatementAst] $forStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitForStatement($forStatementAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitForStatement($forStatementAst) : [object] - should return type [object]' {

# -- Arrange
[ForStatementAst] $forStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitForStatement($forStatementAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitWhileStatement($whileStatementAst) : [object] - should Not Throw' {

# -- Arrange

[WhileStatementAst] $whileStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitWhileStatement($whileStatementAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitWhileStatement($whileStatementAst) : [object] - should return type [object]' {

# -- Arrange
[WhileStatementAst] $whileStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitWhileStatement($whileStatementAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitCatchClause($catchClauseAst) : [object] - should Not Throw' {

# -- Arrange

[CatchClauseAst] $catchClauseAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitCatchClause($catchClauseAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitCatchClause($catchClauseAst) : [object] - should return type [object]' {

# -- Arrange
[CatchClauseAst] $catchClauseAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitCatchClause($catchClauseAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitTryStatement($tryStatementAst) : [object] - should Not Throw' {

# -- Arrange

[TryStatementAst] $tryStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitTryStatement($tryStatementAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitTryStatement($tryStatementAst) : [object] - should return type [object]' {

# -- Arrange
[TryStatementAst] $tryStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitTryStatement($tryStatementAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitDoUntilStatement($doUntilStatementAst) : [object] - should Not Throw' {

# -- Arrange

[DoUntilStatementAst] $doUntilStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitDoUntilStatement($doUntilStatementAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitDoUntilStatement($doUntilStatementAst) : [object] - should return type [object]' {

# -- Arrange
[DoUntilStatementAst] $doUntilStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitDoUntilStatement($doUntilStatementAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitParamBlock($paramBlockAst) : [object] - should Not Throw' {

# -- Arrange

[ParamBlockAst] $paramBlockAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitParamBlock($paramBlockAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitParamBlock($paramBlockAst) : [object] - should return type [object]' {

# -- Arrange
[ParamBlockAst] $paramBlockAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitParamBlock($paramBlockAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitErrorStatement($errorStatementAst) : [object] - should Not Throw' {

# -- Arrange

[ErrorStatementAst] $errorStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitErrorStatement($errorStatementAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitErrorStatement($errorStatementAst) : [object] - should return type [object]' {

# -- Arrange
[ErrorStatementAst] $errorStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitErrorStatement($errorStatementAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitErrorExpression($errorExpressionAst) : [object] - should Not Throw' {

# -- Arrange

[ErrorExpressionAst] $errorExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitErrorExpression($errorExpressionAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitErrorExpression($errorExpressionAst) : [object] - should return type [object]' {

# -- Arrange
[ErrorExpressionAst] $errorExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitErrorExpression($errorExpressionAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitTypeConstraint($typeConstraintAst) : [object] - should Not Throw' {

# -- Arrange

[TypeConstraintAst] $typeConstraintAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitTypeConstraint($typeConstraintAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitTypeConstraint($typeConstraintAst) : [object] - should return type [object]' {

# -- Arrange
[TypeConstraintAst] $typeConstraintAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitTypeConstraint($typeConstraintAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitAttribute($attributeAst) : [object] - should Not Throw' {

# -- Arrange

[AttributeAst] $attributeAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitAttribute($attributeAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitAttribute($attributeAst) : [object] - should return type [object]' {

# -- Arrange
[AttributeAst] $attributeAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitAttribute($attributeAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitNamedAttributeArgument($namedAttributeArgumentAst) : [object] - should Not Throw' {

# -- Arrange

[NamedAttributeArgumentAst] $namedAttributeArgumentAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitNamedAttributeArgument($namedAttributeArgumentAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitNamedAttributeArgument($namedAttributeArgumentAst) : [object] - should return type [object]' {

# -- Arrange
[NamedAttributeArgumentAst] $namedAttributeArgumentAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitNamedAttributeArgument($namedAttributeArgumentAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitParameter($parameterAst) : [object] - should Not Throw' {

# -- Arrange

[ParameterAst] $parameterAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitParameter($parameterAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitParameter($parameterAst) : [object] - should return type [object]' {

# -- Arrange
[ParameterAst] $parameterAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitParameter($parameterAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitBreakStatement($breakStatementAst) : [object] - should Not Throw' {

# -- Arrange

[BreakStatementAst] $breakStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitBreakStatement($breakStatementAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitBreakStatement($breakStatementAst) : [object] - should return type [object]' {

# -- Arrange
[BreakStatementAst] $breakStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitBreakStatement($breakStatementAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitContinueStatement($continueStatementAst) : [object] - should Not Throw' {

# -- Arrange

[ContinueStatementAst] $continueStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitContinueStatement($continueStatementAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitContinueStatement($continueStatementAst) : [object] - should return type [object]' {

# -- Arrange
[ContinueStatementAst] $continueStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitContinueStatement($continueStatementAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitReturnStatement($returnStatementAst) : [object] - should Not Throw' {

# -- Arrange

[ReturnStatementAst] $returnStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitReturnStatement($returnStatementAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitReturnStatement($returnStatementAst) : [object] - should return type [object]' {

# -- Arrange
[ReturnStatementAst] $returnStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitReturnStatement($returnStatementAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitExitStatement($exitStatementAst) : [object] - should Not Throw' {

# -- Arrange

[ExitStatementAst] $exitStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitExitStatement($exitStatementAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitExitStatement($exitStatementAst) : [object] - should return type [object]' {

# -- Arrange
[ExitStatementAst] $exitStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitExitStatement($exitStatementAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitThrowStatement($throwStatementAst) : [object] - should Not Throw' {

# -- Arrange

[ThrowStatementAst] $throwStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitThrowStatement($throwStatementAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitThrowStatement($throwStatementAst) : [object] - should return type [object]' {

# -- Arrange
[ThrowStatementAst] $throwStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitThrowStatement($throwStatementAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitAssignmentStatement($assignmentStatementAst) : [object] - should Not Throw' {

# -- Arrange

[AssignmentStatementAst] $assignmentStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitAssignmentStatement($assignmentStatementAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitAssignmentStatement($assignmentStatementAst) : [object] - should return type [object]' {

# -- Arrange
[AssignmentStatementAst] $assignmentStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitAssignmentStatement($assignmentStatementAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitPipeline($pipelineAst) : [object] - should Not Throw' {

# -- Arrange

[PipelineAst] $pipelineAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitPipeline($pipelineAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitPipeline($pipelineAst) : [object] - should return type [object]' {

# -- Arrange
[PipelineAst] $pipelineAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitPipeline($pipelineAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitCommand($commandAst) : [object] - should Not Throw' {

# -- Arrange

[CommandAst] $commandAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitCommand($commandAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitCommand($commandAst) : [object] - should return type [object]' {

# -- Arrange
[CommandAst] $commandAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitCommand($commandAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitCommandExpression($commandExpressionAst) : [object] - should Not Throw' {

# -- Arrange

[CommandExpressionAst] $commandExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitCommandExpression($commandExpressionAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitCommandExpression($commandExpressionAst) : [object] - should return type [object]' {

# -- Arrange
[CommandExpressionAst] $commandExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitCommandExpression($commandExpressionAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitCommandParameter($commandParameterAst) : [object] - should Not Throw' {

# -- Arrange

[CommandParameterAst] $commandParameterAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitCommandParameter($commandParameterAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitCommandParameter($commandParameterAst) : [object] - should return type [object]' {

# -- Arrange
[CommandParameterAst] $commandParameterAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitCommandParameter($commandParameterAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitFileRedirection($fileRedirectionAst) : [object] - should Not Throw' {

# -- Arrange

[FileRedirectionAst] $fileRedirectionAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitFileRedirection($fileRedirectionAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitFileRedirection($fileRedirectionAst) : [object] - should return type [object]' {

# -- Arrange
[FileRedirectionAst] $fileRedirectionAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitFileRedirection($fileRedirectionAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitMergingRedirection($mergingRedirectionAst) : [object] - should Not Throw' {

# -- Arrange

[MergingRedirectionAst] $mergingRedirectionAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitMergingRedirection($mergingRedirectionAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitMergingRedirection($mergingRedirectionAst) : [object] - should return type [object]' {

# -- Arrange
[MergingRedirectionAst] $mergingRedirectionAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitMergingRedirection($mergingRedirectionAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitBinaryExpression($binaryExpressionAst) : [object] - should Not Throw' {

# -- Arrange

[BinaryExpressionAst] $binaryExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitBinaryExpression($binaryExpressionAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitBinaryExpression($binaryExpressionAst) : [object] - should return type [object]' {

# -- Arrange
[BinaryExpressionAst] $binaryExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitBinaryExpression($binaryExpressionAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitUnaryExpression($unaryExpressionAst) : [object] - should Not Throw' {

# -- Arrange

[UnaryExpressionAst] $unaryExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitUnaryExpression($unaryExpressionAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitUnaryExpression($unaryExpressionAst) : [object] - should return type [object]' {

# -- Arrange
[UnaryExpressionAst] $unaryExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitUnaryExpression($unaryExpressionAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitConvertExpression($convertExpressionAst) : [object] - should Not Throw' {

# -- Arrange

[ConvertExpressionAst] $convertExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitConvertExpression($convertExpressionAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitConvertExpression($convertExpressionAst) : [object] - should return type [object]' {

# -- Arrange
[ConvertExpressionAst] $convertExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitConvertExpression($convertExpressionAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitTypeExpression($typeExpressionAst) : [object] - should Not Throw' {

# -- Arrange

[TypeExpressionAst] $typeExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitTypeExpression($typeExpressionAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitTypeExpression($typeExpressionAst) : [object] - should return type [object]' {

# -- Arrange
[TypeExpressionAst] $typeExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitTypeExpression($typeExpressionAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitConstantExpression($constantExpressionAst) : [object] - should Not Throw' {

# -- Arrange

[ConstantExpressionAst] $constantExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitConstantExpression($constantExpressionAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitConstantExpression($constantExpressionAst) : [object] - should return type [object]' {

# -- Arrange
[ConstantExpressionAst] $constantExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitConstantExpression($constantExpressionAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitStringConstantExpression($stringConstantExpressionAst) : [object] - should Not Throw' {

# -- Arrange

[StringConstantExpressionAst] $stringConstantExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitStringConstantExpression($stringConstantExpressionAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitStringConstantExpression($stringConstantExpressionAst) : [object] - should return type [object]' {

# -- Arrange
[StringConstantExpressionAst] $stringConstantExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitStringConstantExpression($stringConstantExpressionAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitSubExpression($subExpressionAst) : [object] - should Not Throw' {

# -- Arrange

[SubExpressionAst] $subExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitSubExpression($subExpressionAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitSubExpression($subExpressionAst) : [object] - should return type [object]' {

# -- Arrange
[SubExpressionAst] $subExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitSubExpression($subExpressionAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitUsingExpression($usingExpressionAst) : [object] - should Not Throw' {

# -- Arrange

[UsingExpressionAst] $usingExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitUsingExpression($usingExpressionAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitUsingExpression($usingExpressionAst) : [object] - should return type [object]' {

# -- Arrange
[UsingExpressionAst] $usingExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitUsingExpression($usingExpressionAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitVariableExpression($variableExpressionAst) : [object] - should Not Throw' {

# -- Arrange

[VariableExpressionAst] $variableExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitVariableExpression($variableExpressionAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitVariableExpression($variableExpressionAst) : [object] - should return type [object]' {

# -- Arrange
[VariableExpressionAst] $variableExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitVariableExpression($variableExpressionAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitMemberExpression($memberExpressionAst) : [object] - should Not Throw' {

# -- Arrange

[MemberExpressionAst] $memberExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitMemberExpression($memberExpressionAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitMemberExpression($memberExpressionAst) : [object] - should return type [object]' {

# -- Arrange
[MemberExpressionAst] $memberExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitMemberExpression($memberExpressionAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitInvokeMemberExpression($invokeMemberExpressionAst) : [object] - should Not Throw' {

# -- Arrange

[InvokeMemberExpressionAst] $invokeMemberExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitInvokeMemberExpression($invokeMemberExpressionAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitInvokeMemberExpression($invokeMemberExpressionAst) : [object] - should return type [object]' {

# -- Arrange
[InvokeMemberExpressionAst] $invokeMemberExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitInvokeMemberExpression($invokeMemberExpressionAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitArrayExpression($arrayExpressionAst) : [object] - should Not Throw' {

# -- Arrange

[ArrayExpressionAst] $arrayExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitArrayExpression($arrayExpressionAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitArrayExpression($arrayExpressionAst) : [object] - should return type [object]' {

# -- Arrange
[ArrayExpressionAst] $arrayExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitArrayExpression($arrayExpressionAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitArrayLiteral($arrayLiteralAst) : [object] - should Not Throw' {

# -- Arrange

[ArrayLiteralAst] $arrayLiteralAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitArrayLiteral($arrayLiteralAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitArrayLiteral($arrayLiteralAst) : [object] - should return type [object]' {

# -- Arrange
[ArrayLiteralAst] $arrayLiteralAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitArrayLiteral($arrayLiteralAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitHashtable($hashtableAst) : [object] - should Not Throw' {

# -- Arrange

[HashtableAst] $hashtableAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitHashtable($hashtableAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitHashtable($hashtableAst) : [object] - should return type [object]' {

# -- Arrange
[HashtableAst] $hashtableAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitHashtable($hashtableAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitScriptBlockExpression($scriptBlockExpressionAst) : [object] - should Not Throw' {

# -- Arrange

[ScriptBlockExpressionAst] $scriptBlockExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitScriptBlockExpression($scriptBlockExpressionAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitScriptBlockExpression($scriptBlockExpressionAst) : [object] - should return type [object]' {

# -- Arrange
[ScriptBlockExpressionAst] $scriptBlockExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitScriptBlockExpression($scriptBlockExpressionAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitParenExpression($parenExpressionAst) : [object] - should Not Throw' {

# -- Arrange

[ParenExpressionAst] $parenExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitParenExpression($parenExpressionAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitParenExpression($parenExpressionAst) : [object] - should return type [object]' {

# -- Arrange
[ParenExpressionAst] $parenExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitParenExpression($parenExpressionAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitExpandableStringExpression($expandableStringExpressionAst) : [object] - should Not Throw' {

# -- Arrange

[ExpandableStringExpressionAst] $expandableStringExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitExpandableStringExpression($expandableStringExpressionAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitExpandableStringExpression($expandableStringExpressionAst) : [object] - should return type [object]' {

# -- Arrange
[ExpandableStringExpressionAst] $expandableStringExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitExpandableStringExpression($expandableStringExpressionAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitIndexExpression($indexExpressionAst) : [object] - should Not Throw' {

# -- Arrange

[IndexExpressionAst] $indexExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitIndexExpression($indexExpressionAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitIndexExpression($indexExpressionAst) : [object] - should return type [object]' {

# -- Arrange
[IndexExpressionAst] $indexExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitIndexExpression($indexExpressionAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitAttributedExpression($attributedExpressionAst) : [object] - should Not Throw' {

# -- Arrange

[AttributedExpressionAst] $attributedExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitAttributedExpression($attributedExpressionAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitAttributedExpression($attributedExpressionAst) : [object] - should return type [object]' {

# -- Arrange
[AttributedExpressionAst] $attributedExpressionAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitAttributedExpression($attributedExpressionAst)).GetType().Name | should be object

} #End It Block

#Public Method
It '[AstVisitor] --> VisitBlockStatement($blockStatementAst) : [object] - should Not Throw' {

# -- Arrange

[BlockStatementAst] $blockStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()

# -- Assert

{$Instance.VisitBlockStatement($blockStatementAst)} | Should Not Throw

} #End It Block

#Public Method
It '[AstVisitor] --> VisitBlockStatement($blockStatementAst) : [object] - should return type [object]' {

# -- Arrange
[BlockStatementAst] $blockStatementAst = ''

# -- Act

$Instance = [AstVisitor]::New()
# -- Assert

($Instance.VisitBlockStatement($blockStatementAst)).GetType().Name | should be object

} #End It Block

}#EndDescribeBlock

}#End InModuleScope


