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

    [String]GetTotalFormatted([boolean]$HumanReadable)
    {
        if ($HumanReadable) {
            return '{0}ms' -f $([math]::Round($this.Total.TotalMilliseconds))
        }
        return '{0:mm\:ss\.fffffff}' -f $this.Total
    }

    [TimeSpan]GetAverage()
    {
        if($count = $this.GetCount() -eq 0){
            return [TimeSpan]::Zero
        }

        return [TimeSpan]::FromTicks($this.GetTotal().Ticks / $this.GetCount())
    }

    [int]GetCount()
    {
        return $this.TimeSpans.Count
    }
}
#endregion
