function Visit-Ast {
    param(
        [Ast]$Ast,

        $Profiler
    )

    if(-not $PSBoundParameters.ContainsKey('Profiler')){
        $profiler = [Profiler]::new($Ast.Extent)
    }
    $visitor  = [PSPVisitor]::new($profiler)

    return [PSCustomObject]@{
        Profiler = $profiler
        NewAst = $Ast.Visit($visitor)
    }
}