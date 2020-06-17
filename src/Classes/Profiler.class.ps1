using namespace System.Collections.Generic
using namespace System.Diagnostics
using namespace System.Management.Automation.Language

#region Profiler
class Profiler
{
    [Stopwatch[]]$StopWatches
    [TimeLine[]]$TimeLines
    [int]$Offset

    Profiler([IScriptExtent]$extent)
    {
        $lines = $extent.EndLineNumber
        $this.Offset = $extent.StartLineNumber - 1
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
        $this.StopWatches[$lineNo - $this.Offset].Start()
    }

    [void] EndLine([int] $lineNo)
    {
        $lineNo -= $this.Offset
        $this.StopWatches[$lineNo].Stop()
        $this.TimeLines[$lineNo].Add($this.StopWatches[$lineNo].Elapsed)
        $this.StopWatches[$lineNo].Reset()
    }
}
#endregion