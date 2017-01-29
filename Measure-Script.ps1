#region Profiler
class Profiler
{
    [System.Diagnostics.Stopwatch[]]$StopWatches
    Profiler([System.Management.Automation.Language.IScriptExtent]$extent)
    {
        $lines = $extent.EndLineNumber
        $this.StopWatches = [System.Diagnostics.Stopwatch[]]::new($lines)
        for ($i = 0; $i -lt $lines; $i++)
        {
            $this.StopWatches[$i] = [System.Diagnostics.Stopwatch]::new()
        }
    }

    [void] StartLine([int] $lineNo)
    {        
        $this.StopWatches[$lineNo].Start()
    }

    [void] EndLine([int] $lineNo)
    {
        $this.StopWatches[$lineNo].Stop()
    }
}
#endregion

#region AstVisitor 
class AstVisitor : System.Management.Automation.Language.ICustomAstVisitor
{
    [Profiler]$Profiler = $null
    AstVisitor([Profiler]$profiler) {
        $this.Profiler = $profiler
    }
    [System.Object] VisitElement([object]$element) {
        if ($element -eq $null) {
            return $null
        }
        $res = $element.Visit($this)
        return $res
    }
    [System.Object] VisitElements([System.Object]$elements) {
            if ($elements -eq $null -or $elements.Count -eq 0)
            {
                return $null
            }
            $typeName = $elements.gettype().GenericTypeArguments.Fullname

            $newElements = New-Object -TypeName "System.Collections.Generic.List[$typeName]"
            foreach($element in $elements) {
                $visitedResult = $element.Visit($this)
                $newElements.add($visitedResult)
            }
            return $newElements 
    }
    [System.Management.Automation.Language.StatementAst[]] VisitStatements([object]$Statements)
    {
            $newStatements = [System.Collections.Generic.List[System.Management.Automation.Language.StatementAst]]::new()
            foreach ($statement in $statements)
            {
                [bool]$instrument = $statement -is [System.Management.Automation.Language.PipelineBaseAst]
                $extent = $statement.Extent
                if ($instrument)
                {
                    $expressionAstCollection = [System.Collections.Generic.List[System.Management.Automation.Language.ExpressionAst]]::new()
                    $constantExpression = [System.Management.Automation.Language.ConstantExpressionAst]::new($extent, $extent.StartLineNumber - 1)
                    $expressionAstCollection.Add($constantExpression)
                    $constantProfiler = [System.Management.Automation.Language.ConstantExpressionAst]::new($extent, $this.Profiler)
                    $constantStartline = [System.Management.Automation.Language.StringConstantExpressionAst]::new($extent, "StartLine", [System.Management.Automation.Language.StringConstantType]::BareWord)
                    $invokeMember = [System.Management.Automation.Language.InvokeMemberExpressionAst]::new(
                            $extent,
                            $constantProfiler,
                            $constantStartline,
                            $expressionAstCollection,
                            $false
                        )
                    $startLine = [System.Management.Automation.Language.CommandExpressionAst]::new(
                        $extent, 
                        $invokeMember, 
                        $null
                    )
                    $pipe = [System.Management.Automation.Language.PipelineAst]::new($extent, $startLine);
                    $newStatements.Add($pipe)
                }
                $newStatements.Add($this.VisitElement($statement))
                if ($instrument)
                {
                    $expressionAstCollection = [System.Collections.Generic.List[System.Management.Automation.Language.ExpressionAst]]::new()
                    $expressionAstCollection.Add([System.Management.Automation.Language.ConstantExpressionAst]::new($extent, $extent.StartLineNumber - 1))
                    $endLine = [System.Management.Automation.Language.CommandExpressionAst]::new(
                        $extent, 
                        [System.Management.Automation.Language.InvokeMemberExpressionAst]::new(
                            $extent,
                            [System.Management.Automation.Language.ConstantExpressionAst]::new($extent, $this.Profiler),
                            [System.Management.Automation.Language.StringConstantExpressionAst]::new($extent, "EndLine", [System.Management.Automation.Language.StringConstantType]::BareWord),
                            $expressionAstCollection, 
                            $false
                        ), 
                        $null
                    )
                    $pipe = [System.Management.Automation.Language.PipelineAst]::new($extent, $endLine)
                    $newStatements.add($pipe)
                }
            }
            return $newStatements
        }

    [system.object] VisitScriptBlock([System.Management.Automation.Language.ScriptBlockAst] $scriptBlockAst)
    {
        $newParamBlock = $this.VisitElement($scriptBlockAst.ParamBlock)
        $newBeginBlock = $this.VisitElement($scriptBlockAst.BeginBlock)
        $newProcessBlock = $this.VisitElement($scriptBlockAst.ProcessBlock)
        $newEndBlock = $this.VisitElement($scriptBlockAst.EndBlock)
        $newDynamicParamBlock = $this.VisitElement($scriptBlockAst.DynamicParamBlock)
        return [System.Management.Automation.Language.ScriptBlockAst]::new($scriptBlockAst.Extent, $newParamBlock, $newBeginBlock, $newProcessBlock, $newEndBlock, $newDynamicParamBlock)
    }


    [system.object] VisitNamedBlock([System.Management.Automation.Language.NamedBlockAst] $namedBlockAst)
    {
        $newTraps = $this.VisitElements($namedBlockAst.Traps)
        $newStatements = $this.VisitStatements($namedBlockAst.Statements)
        $statementBlock = [System.Management.Automation.Language.StatementBlockAst]::new($namedBlockAst.Extent,$newStatements,$newTraps)
        return [System.Management.Automation.Language.NamedBlockAst]::new($namedBlockAst.Extent, $namedBlockAst.BlockKind, $statementBlock, $namedBlockAst.Unnamed)
    }

    [system.object] VisitFunctionDefinition([System.Management.Automation.Language.FunctionDefinitionAst] $functionDefinitionAst)
    {
        $newBody = $this.VisitElement($functionDefinitionAst.Body)
        return [System.Management.Automation.Language.FunctionDefinitionAst]::new($functionDefinitionAst.Extent, $functionDefinitionAst.IsFilter,$functionDefinitionAst.IsWorkflow, $functionDefinitionAst.Name, $this.VisitElements($functionDefinitionAst.Parameters), $newBody);
    }

    [system.object] VisitStatementBlock([System.Management.Automation.Language.StatementBlockAst] $statementBlockAst)
    {
        $newStatements = $this.VisitStatements($statementBlockAst.Statements)
        $newTraps = $this.VisitElements($statementBlockAst.Traps)
        return [System.Management.Automation.Language.StatementBlockAst]::new($statementBlockAst.Extent, $newStatements, $newTraps)
    }

    [system.object] VisitIfStatement([System.Management.Automation.Language.IfStatementAst] $ifStmtAst)
    {
        $newClauses = $ifStmtAst.Clauses | ForEach-Object {
            $newClauseTest = $this.VistitElement($_.Item1)
            $newStatementBlock = $this.VistitElement($_.Item2)
            [System.Tuple[System.Management.Automation.Language.PipelineBaseAst,System.Management.Automation.Language.StatementBlockAst]]::new($newClauseTest,$newStatementBlock)
        }
        $newElseClause = $this.VisitElement($ifStmtAst.ElseClause)
        return [System.Management.Automation.Language.IfStatementAst]::new($ifStmtAst.Extent, $newClauses, $newElseClause)
    }

    [system.object] VisitTrap([System.Management.Automation.Language.TrapStatementAst] $trapStatementAst)
    {
        return [System.Management.Automation.Language.TrapStatementAst]::new($trapStatementAst.Extent, $this.VisitElement($trapStatementAst.TrapType), $this.VisitElement($trapStatementAst.Body))
    }

    [system.object] VisitSwitchStatement([System.Management.Automation.Language.SwitchStatementAst] $switchStatementAst)
    {
        $newCondition = $this.VisitElement($switchStatementAst.Condition)
        $newClauses = $switchStatementAst.Clauses | ForEach-Object {
            $newClauseTest = $this.VistitElement($_.Item1)
            $newStatementBlock = $this.VistitElement($_.Item2)
            [System.Tuple[System.Management.Automation.Language.ExpressionAst,System.Management.Automation.Language.StatementBlockAst]]::new($newClauseTest,$newStatementBlock)
        }
        $newDefault = $this.VisitElement($switchStatementAst.Default)
        return [System.Management.Automation.Language.SwitchStatementAst]::new($switchStatementAst.Extent, $switchStatementAst.Label,$newCondition,$switchStatementAst.Flags, $newClauses, $newDefault)
    }

    [system.object] VisitDataStatement([System.Management.Automation.Language.DataStatementAst] $dataStatementAst)
    {
        $newBody = $this.VisitElement($dataStatementAst.Body)
        $newCommandsAllowed = $this.VisitElements($dataStatementAst.CommandsAllowed)
        return [System.Management.Automation.Language.DataStatementAst]::new($dataStatementAst.Extent, $dataStatementAst.Variable, $newCommandsAllowed, $newBody)
    }

    [system.object] VisitForEachStatement([System.Management.Automation.Language.ForEachStatementAst] $forEachStatementAst)
    {
        $newVariable = $this.VisitElement($forEachStatementAst.Variable)
        $newCondition = $this.VisitElement($forEachStatementAst.Condition)
        $newBody = $this.VisitElement($forEachStatementAst.Body)
        return [System.Management.Automation.Language.ForEachStatementAst]::new($forEachStatementAst.Extent, $forEachStatementAst.Label, [System.Management.Automation.Language.ForEachFlags]::None, $newVariable, $newCondition, $newBody)
    }

    [system.object] VisitDoWhileStatement([System.Management.Automation.Language.DoWhileStatementAst] $doWhileStatementAst)
    {
        $newCondition = $this.VisitElement($doWhileStatementAst.Condition)
        $newBody = $this.VisitElement($doWhileStatementAst.Body)
        return [System.Management.Automation.Language.DoWhileStatementAst]::new($doWhileStatementAst.Extent, $doWhileStatementAst.Label, $newCondition, $newBody)
    }

    [system.object] VisitForStatement([System.Management.Automation.Language.ForStatementAst] $forStatementAst)
    {
        $newInitializer = $this.VisitElement($forStatementAst.Initializer)
        $newCondition = $this.VisitElement($forStatementAst.Condition)
        $newIterator = $this.VisitElement($forStatementAst.Iterator)
        $newBody = $this.VisitElement($forStatementAst.Body)
        return [System.Management.Automation.Language.ForStatementAst]::new($forStatementAst.Extent, $forStatementAst.Label, $newInitializer, $newCondition, $newIterator, $newBody)
    }

    [system.object] VisitWhileStatement([System.Management.Automation.Language.WhileStatementAst] $whileStatementAst)
    {
        $newCondition = $this.VisitElement($whileStatementAst.Condition)
        $newBody = $this.VisitElement($whileStatementAst.Body)
        return [System.Management.Automation.Language.WhileStatementAst]::new($whileStatementAst.Extent, $whileStatementAst.Label, $newCondition, $newBody)
    }

    [system.object] VisitCatchClause([System.Management.Automation.Language.CatchClauseAst] $catchClauseAst)
    {
        $newBody = $this.VisitElement($catchClauseAst.Body)
        return [System.Management.Automation.Language.CatchClauseAst]::new($catchClauseAst.Extent, $catchClauseAst.CatchTypes, $newBody)
    }

    [system.object] VisitTryStatement([System.Management.Automation.Language.TryStatementAst] $tryStatementAst)
    {
        $newBody = $this.VisitElement($tryStatementAst.Body)
        $newCatchClauses = $this.VisitElements($tryStatementAst.CatchClauses)
        $newFinally = $this.VisitElement($tryStatementAst.Finally)
        return [System.Management.Automation.Language.TryStatementAst]::new($tryStatementAst.Extent, $newBody, $newCatchClauses, $newFinally)
    }

    [system.object] VisitDoUntilStatement([System.Management.Automation.Language.DoUntilStatementAst] $doUntilStatementAst)
    {
        $newCondition = $this.VisitElement($doUntilStatementAst.Condition)
        $newBody = $this.VisitElement($doUntilStatementAst.Body)
        return [System.Management.Automation.Language.DoUntilStatementAst]::new($doUntilStatementAst.Extent, $doUntilStatementAst.Label, $newCondition, $newBody)
    }

    [system.object] VisitParamBlock([System.Management.Automation.Language.ParamBlockAst] $paramBlockAst)
    {
        $newAttributes = $this.VisitElements($paramBlockAst.Attributes)
        $newParameters = $this.VisitElements($paramBlockAst.Parameters)
        return [System.Management.Automation.Language.ParamBlockAst]::new($paramBlockAst.Extent, $newAttributes, $newParameters)
    }

    [system.object] VisitErrorStatement([System.Management.Automation.Language.ErrorStatementAst] $errorStatementAst)
    {
        return $errorStatementAst
    }

    [system.object] VisitErrorExpression([System.Management.Automation.Language.ErrorExpressionAst] $errorExpressionAst)
    {
        return $errorExpressionAst
    }

    [system.object] VisitTypeConstraint([System.Management.Automation.Language.TypeConstraintAst] $typeConstraintAst)
    {
        return [System.Management.Automation.Language.TypeConstraintAst]::new($typeConstraintAst.Extent, $typeConstraintAst.TypeName)
    }

    [system.object] VisitAttribute([System.Management.Automation.Language.AttributeAst] $attributeAst)
    {
        $newPositionalArguments = $this.VisitElements($attributeAst.PositionalArguments)
        $newNamedArguments = $this.VisitElements($attributeAst.NamedArguments)
        return [System.Management.Automation.Language.AttributeAst]::new($attributeAst.Extent, $attributeAst.TypeName, $newPositionalArguments, $newNamedArguments)
    }

    [system.object] VisitNamedAttributeArgument([System.Management.Automation.Language.NamedAttributeArgumentAst] $namedAttributeArgumentAst)
    {
        $newArgument = $this.VisitElement($namedAttributeArgumentAst.Argument)
        return [System.Management.Automation.Language.NamedAttributeArgumentAst]::new($namedAttributeArgumentAst.Extent, $namedAttributeArgumentAst.ArgumentName, $newArgument,$namedAttributeArgumentAst.ExpressionOmitted)
    }

    [system.object] VisitParameter([System.Management.Automation.Language.ParameterAst] $parameterAst)
    {
        $newName = $this.VisitElement($parameterAst.Name)
        $newAttributes = $this.VisitElements($parameterAst.Attributes)
        $newDefaultValue = $this.VisitElement($parameterAst.DefaultValue)
        return [System.Management.Automation.Language.ParameterAst]::new($parameterAst.Extent, $newName, $newAttributes, $newDefaultValue)
    }

    [system.object] VisitBreakStatement([System.Management.Automation.Language.BreakStatementAst] $breakStatementAst)
    {
        $newLabel = $this.VisitElement($breakStatementAst.Label)
        return [System.Management.Automation.Language.BreakStatementAst]::new($breakStatementAst.Extent, $newLabel)
    }

    [system.object] VisitContinueStatement([System.Management.Automation.Language.ContinueStatementAst] $continueStatementAst)
    {
        $newLabel = $this.VisitElement($continueStatementAst.Label)
        return [System.Management.Automation.Language.ContinueStatementAst]::new($continueStatementAst.Extent, $newLabel)
    }

    [system.object] VisitReturnStatement([System.Management.Automation.Language.ReturnStatementAst] $returnStatementAst)
    {
        $newPipeline = $this.VisitElement($returnStatementAst.Pipeline)
        return [System.Management.Automation.Language.ReturnStatementAst]::new($returnStatementAst.Extent, $newPipeline)
    }

    [system.object] VisitExitStatement([System.Management.Automation.Language.ExitStatementAst] $exitStatementAst)
    {
        $newPipeline = $this.VisitElement($exitStatementAst.Pipeline)
        return [System.Management.Automation.Language.ExitStatementAst]::new($exitStatementAst.Extent, $newPipeline)
    }

    [system.object] VisitThrowStatement([System.Management.Automation.Language.ThrowStatementAst] $throwStatementAst)
    {
        $newPipeline = $this.VisitElement($throwStatementAst.Pipeline)
        return [System.Management.Automation.Language.ThrowStatementAst]::new($throwStatementAst.Extent, $newPipeline)
    }

    [system.object] VisitAssignmentStatement([System.Management.Automation.Language.AssignmentStatementAst] $assignmentStatementAst)
    {
        $newLeft = $this.VisitElement($assignmentStatementAst.Left)
        $newRight = $this.VisitElement($assignmentStatementAst.Right)
        return [System.Management.Automation.Language.AssignmentStatementAst]::new($assignmentStatementAst.Extent, $newLeft, $assignmentStatementAst.Operator,$newRight, $assignmentStatementAst.ErrorPosition)
    }

    [system.object] VisitPipeline([System.Management.Automation.Language.PipelineAst] $pipelineAst)
    {
        $newPipeElements = $this.VisitElements($pipelineAst.PipelineElements)
        return [System.Management.Automation.Language.PipelineAst]::new($pipelineAst.Extent, $newPipeElements)
    }

    [system.object] VisitCommand([System.Management.Automation.Language.CommandAst] $commandAst)
    {
        $newCommandElements = $this.VisitElements($commandAst.CommandElements)
        $newRedirections = $this.VisitElements($commandAst.Redirections)
        return [System.Management.Automation.Language.CommandAst]::new($commandAst.Extent, $newCommandElements, $commandAst.InvocationOperator, $newRedirections)
    }

    [system.object] VisitCommandExpression([System.Management.Automation.Language.CommandExpressionAst] $commandExpressionAst)
    {
        $newExpression = $this.VisitElement($commandExpressionAst.Expression)
        $newRedirections = $this.VisitElements($commandExpressionAst.Redirections)
        return [System.Management.Automation.Language.CommandExpressionAst]::new($commandExpressionAst.Extent, $newExpression, $newRedirections)
    }

    [system.object] VisitCommandParameter([System.Management.Automation.Language.CommandParameterAst] $commandParameterAst)
    {
        $newArgument = $this.VisitElement($commandParameterAst.Argument)
        return [System.Management.Automation.Language.CommandParameterAst]::new($commandParameterAst.Extent, $commandParameterAst.ParameterName, $newArgument, $commandParameterAst.ErrorPosition)
    }

    [system.object] VisitFileRedirection([System.Management.Automation.Language.FileRedirectionAst] $fileRedirectionAst)
    {
        $newFile = $this.VisitElement($fileRedirectionAst.Location)
        return [System.Management.Automation.Language.FileRedirectionAst]::new($fileRedirectionAst.Extent, $fileRedirectionAst.FromStream, $newFile, $fileRedirectionAst.Append)
    }

    [system.object] VisitMergingRedirection([System.Management.Automation.Language.MergingRedirectionAst] $mergingRedirectionAst)
    {
        return [System.Management.Automation.Language.MergingRedirectionAst]::new($mergingRedirectionAst.Extent, $mergingRedirectionAst.FromStream, $mergingRedirectionAst.ToStream)
    }

    [system.object] VisitBinaryExpression([System.Management.Automation.Language.BinaryExpressionAst] $binaryExpressionAst)
    {
        $newLeft = $this.VisitElement($binaryExpressionAst.Left)
        $newRight = $this.VisitElement($binaryExpressionAst.Right)
        return [System.Management.Automation.Language.BinaryExpressionAst]::new($binaryExpressionAst.Extent, $newLeft, $binaryExpressionAst.Operator, $newRight, $binaryExpressionAst.ErrorPosition)
    }

    [system.object] VisitUnaryExpression([System.Management.Automation.Language.UnaryExpressionAst] $unaryExpressionAst)
    {
        $newChild = $this.VisitElement($unaryExpressionAst.Child)
        return [System.Management.Automation.Language.UnaryExpressionAst]::new($unaryExpressionAst.Extent, $unaryExpressionAst.TokenKind, $newChild)
    }

    [system.object] VisitConvertExpression([System.Management.Automation.Language.ConvertExpressionAst] $convertExpressionAst)
    {
        $newChild = $this.VisitElement($convertExpressionAst.Child)
        $newTypeConstraint = $this.VisitElement($convertExpressionAst.Type)
        return [System.Management.Automation.Language.ConvertExpressionAst]::new($convertExpressionAst.Extent, $newTypeConstraint, $newChild)
    }

    [system.object] VisitTypeExpression([System.Management.Automation.Language.TypeExpressionAst] $typeExpressionAst)
    {
        return [System.Management.Automation.Language.TypeExpressionAst]::new($typeExpressionAst.Extent, $typeExpressionAst.TypeName)
    }

    [system.object] VisitConstantExpression([System.Management.Automation.Language.ConstantExpressionAst] $constantExpressionAst)
    {
        return [System.Management.Automation.Language.ConstantExpressionAst]::new($constantExpressionAst.Extent, $constantExpressionAst.Value)
    }

    [system.object] VisitStringConstantExpression([System.Management.Automation.Language.StringConstantExpressionAst] $stringConstantExpressionAst)
    {
        return [System.Management.Automation.Language.StringConstantExpressionAst]::new($stringConstantExpressionAst.Extent, $stringConstantExpressionAst.Value, $stringConstantExpressionAst.StringConstantType)
    }

    [system.object] VisitSubExpression([System.Management.Automation.Language.SubExpressionAst] $subExpressionAst)
    {
        $newStatementBlock = $this.VisitElement($subExpressionAst.SubExpression)
        return [System.Management.Automation.Language.SubExpressionAst]::new($subExpressionAst.Extent, $newStatementBlock)
    }

    [system.object] VisitUsingExpression([System.Management.Automation.Language.UsingExpressionAst] $usingExpressionAst)
    {
        $newUsingExpr = $this.VisitElement($usingExpressionAst.SubExpression)
        return [System.Management.Automation.Language.UsingExpressionAst]::new($usingExpressionAst.Extent, $newUsingExpr)
    }

    [system.object] VisitVariableExpression([System.Management.Automation.Language.VariableExpressionAst] $variableExpressionAst)
    {
        return [System.Management.Automation.Language.VariableExpressionAst]::new($variableExpressionAst.Extent, $variableExpressionAst.VariablePath.UserPath, $variableExpressionAst.Splatted)
    }

    [system.object] VisitMemberExpression([System.Management.Automation.Language.MemberExpressionAst] $memberExpressionAst)
    {
        $newExpr = $this.VisitElement($memberExpressionAst.Expression)
        $newMember = $this.VisitElement($memberExpressionAst.Member)
        return [System.Management.Automation.Language.MemberExpressionAst]::new($memberExpressionAst.Extent, $newExpr, $newMember, $memberExpressionAst.Static)
    }

    [system.object] VisitInvokeMemberExpression([System.Management.Automation.Language.InvokeMemberExpressionAst] $invokeMemberExpressionAst)
    {
        $newExpression = $this.VisitElement($invokeMemberExpressionAst.Expression)
        $newMethod = $this.VisitElement($invokeMemberExpressionAst.Member)
        $newArguments = $this.VisitElements($invokeMemberExpressionAst.Arguments)
        return [System.Management.Automation.Language.InvokeMemberExpressionAst]::new($invokeMemberExpressionAst.Extent, $newExpression, $newMethod, $newArguments, $invokeMemberExpressionAst.Static)
    }

    [system.object] VisitArrayExpression([System.Management.Automation.Language.ArrayExpressionAst] $arrayExpressionAst)
    {
        $newStatementBlock = $this.VisitElement($arrayExpressionAst.SubExpression)
        return [System.Management.Automation.Language.ArrayExpressionAst]::new($arrayExpressionAst.Extent, $newStatementBlock)
    }

    [system.object] VisitArrayLiteral([System.Management.Automation.Language.ArrayLiteralAst] $arrayLiteralAst)
    {
        $newArrayElements = $this.VisitElements($arrayLiteralAst.Elements)
        return [System.Management.Automation.Language.ArrayLiteralAst]::new($arrayLiteralAst.Extent, $newArrayElements)
    }

    [system.object] VisitHashtable([System.Management.Automation.Language.HashtableAst] $hashtableAst)
    {
        $newKeyValuePairs = [System.Collections.Generic.List[System.Tuple[System.Management.Automation.Language.ExpressionAst,System.Management.Automation.Language.StatementAst]]]::new()
        foreach ($keyValuePair in $hashtableAst.KeyValuePairs)
        {
            $newKey = $this.VisitElement($keyValuePair.Item1);
            $newValue = $this.VisitElement($keyValuePair.Item2);
            $newKeyValuePairs.Add([System.Tuple[System.Management.Automation.Language.ExpressionAst,System.Management.Automation.Language.StatementAst]]::new($newKey, $newValue)) # TODO NOT SURE
        }
        return [System.Management.Automation.Language.HashtableAst]::new($hashtableAst.Extent, $newKeyValuePairs)
    }

    [system.object] VisitScriptBlockExpression([System.Management.Automation.Language.ScriptBlockExpressionAst] $scriptBlockExpressionAst)
    {
        $newScriptBlock = $this.VisitElement($scriptBlockExpressionAst.ScriptBlock)
        return [System.Management.Automation.Language.ScriptBlockExpressionAst]::new($scriptBlockExpressionAst.Extent, $newScriptBlock)
    }

    [system.object] VisitParenExpression([System.Management.Automation.Language.ParenExpressionAst] $parenExpressionAst)
    {
        $newPipeline = $this.VisitElement($parenExpressionAst.Pipeline)
        return [System.Management.Automation.Language.ParenExpressionAst]::new($parenExpressionAst.Extent, $newPipeline)
    }

    [system.object] VisitExpandableStringExpression([System.Management.Automation.Language.ExpandableStringExpressionAst] $expandableStringExpressionAst)
    {
        return [System.Management.Automation.Language.ExpandableStringExpressionAst]::new($expandableStringExpressionAst.Extent,$expandableStringExpressionAst.Value,$expandableStringExpressionAst.StringConstantType)
    }

    [system.object] VisitIndexExpression([System.Management.Automation.Language.IndexExpressionAst] $indexExpressionAst)
    {
        $newTargetExpression = $this.VisitElement($indexExpressionAst.Target)
        $newIndexExpression = $this.VisitElement($indexExpressionAst.Index)
        return [System.Management.Automation.Language.IndexExpressionAst]::new($indexExpressionAst.Extent, $newTargetExpression, $newIndexExpression)
    }

    [system.object] VisitAttributedExpression([System.Management.Automation.Language.AttributedExpressionAst] $attributedExpressionAst)
    {
        $newAttribute = $this.VisitElement($attributedExpressionAst.Attribute)
        $newChild = $this.VisitElement($attributedExpressionAst.Child)
        return [System.Management.Automation.Language.AttributedExpressionAst]::new($attributedExpressionAst.Extent, $newAttribute, $newChild)
    }

    [system.object] VisitBlockStatement([System.Management.Automation.Language.BlockStatementAst] $blockStatementAst)
    {
        $newBody = $this.VisitElement($blockStatementAst.Body)
        return [System.Management.Automation.Language.BlockStatementAst]::new($blockStatementAst.Extent, $blockStatementAst.Kind, $newBody)
    }
}
#endregion

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
        [hashtable]$Arguments,
        [parameter(Mandatory=$false,ParameterSetName="__AllParametersets")]
        [string]$VariableScope="1"
    )
    if($PSBoundParameters.Keys -icontains "Path") {
        if(-not (Test-Path $path)) {       
            throw "No such file"
        }
        $ScriptText = Get-Content $path -Raw 
        $ScriptBlock = [scriptblock]::Create($ScriptText)
    }
    $ScriptBlock = [scriptblock]::Create($ScriptBlock.ToString())
    $profiler = [Profiler]::new($ScriptBlock.Ast.Extent)
    $visitor  = [AstVisitor]::new($profiler)
    $newAst   = $ScriptBlock.Ast.Visit($visitor)
    $executionResult = . $newAst.GetScriptBlock() @Arguments

    [string[]]$lines = $ScriptBlock.ToString().Split("`n").TrimEnd()
    for($i = 0; $i -lt $lines.Count;$i++){
        [pscustomobject]@{
            LineNo = $i+1 
            ExecutionTime = $profiler.StopWatches[$i].Elapsed
            Line = $lines[$i]
        }
    }
    if($ExecutionResultVariable) {
        Set-Variable -Name $ExecutionResultVariable -Value $executionResult -Scope $VariableScope
    }
}
