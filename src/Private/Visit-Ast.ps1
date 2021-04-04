function Visit-Ast {
    param(
        [Ast]$Ast
    )

    $profiler = [Profiler]::new($Ast.Extent)
    $visitor  = [PSPVisitor]::new($profiler)

    return [PSCustomObject]@{
        Profiler = $profiler
        NewAst = $Ast.Visit($visitor)
    }
}