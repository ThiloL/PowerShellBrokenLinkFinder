function Check-Uri([string]$Uri)
{
    Write-Verbose "Check-Uri '$Uri'"

    try 
    {
        Invoke-WebRequest -Uri $Uri -ErrorAction Stop | Select-Object -ExpandProperty StatusCode    
    }
    catch [System.Net.WebException] 
    {
        500
    }
}