using namespace System.Collections.Generic

#region TimeLine
class TimeLine
{
    [List[TimeSpan]]$TimeSpans
    hidden [TimeSpan]$Total

    TimeLine()
    {
        $this.TimeSpans = [List[TimeSpan]]::new()
    }

    [void]Add([TimeSpan]$TimeSpan)
    {
        $this.TimeSpans.Add($TimeSpan)
        $this.Total = $this.Total.Add($TimeSpan)
    }

    [TimeSpan]GetTotal()
    {
        return $this.Total
    }

    [TimeSpan]GetAverage()
    {
        return [TimeSpan]::FromTicks($this.GetTotal().Ticks / $this.GetCount())
    }

    [int]GetCount()
    {
        return $this.TimeSpans.Count
    }
}
#endregion
