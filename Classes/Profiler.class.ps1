using namespace System.Collections.Generic
using namespace System.Diagnostics
using namespace System.Management.Automation.Language

#region Profiler
class Profiler
{
    [Stopwatch[]]$StopWatches
    [TimeLine[]]$TimeLines

    Profiler([IScriptExtent]$extent)
    {
        $lines = $extent.EndLineNumber
        $this.StopWatches = [Stopwatch[]]::new($lines)
        $this.TimeLines   = [TimeLine[]]::new($lines)

        for ($i = 0; $i -lt $lines; $i++)
        {
            $this.StopWatches[$i] = [Stopwatch]::new()
            $this.TimeLines[$i]   = [TimeLine]::new()
        }
    }

    [void] StartLine([int] $lineNo)
    {        
        $this.StopWatches[$lineNo].Start()
    }

    [void] EndLine([int] $lineNo)
    {
        $this.StopWatches[$lineNo].Stop()
        $this.TimeLines[$lineNo].Add($this.StopWatches[$lineNo].Elapsed)
        $this.StopWatches[$lineNo].Reset()
    }
}
#endregion