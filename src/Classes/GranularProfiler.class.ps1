using namespace System.Collections.Generic
using namespace System.Diagnostics
using namespace System.Management.Automation.Language

#region Profiler
class GranularProfiler
{
    [IScriptExtent]$RootExtent
    [List[IScriptExtent]]$MeasuredExtents
    [Dictionary[string,Stopwatch]]$StopWatches
    [Dictionary[string,TimeLine]]$TimeLines

    GranularProfiler([IScriptExtent]$extent)
    {
        $this.RootExtent = $extent
        $this.MeasuredExtents = [List[IScriptExtent]]::new()
        $this.StopWatches = [Dictionary[string,Stopwatch]]::new()
        $this.TimeLines   = [Dictionary[string,TimeLine]]::new()
    }

    [void] MeasureExtent([IScriptExtent]$extent)
    {
        $this.MeasuredExtents.Add($extent)
    }

    [void] StartExtent([string]$id)
    {
        if(-not $this.StopWatches.ContainsKey("$id")){
            $this.StopWatches[$id] = [StopWatch]::new()
            $this.TimeLines[$id] = [TimeLine]::new()
        }
        $this.StopWatches[$id].Start()
    }

    [void] EndExtent([string]$id)
    {
        $this.StopWatches[$id].Stop()
        $this.TimeLines[$id].Add($this.StopWatches[$id].Elapsed)
        $this.StopWatches[$id].Reset()
    }
}
#endregion