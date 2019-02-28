function Check-Uri([string]$Uri) {
    $Static_Extensions = @("jpg", "pdf")
    [bool]$Is_Static = $false;

    $Uri = $Uri.Trim().ToLower()

    Write-Verbose "Check-Uri '$Uri'"

    foreach ($s in $Static_Extensions) {
        if ($uri.EndsWith($s)) { $Is_Static = $true}
    }

    try {
        if ($Is_Static) {
            Invoke-WebRequest -Uri $Uri -Method Head -ErrorAction Stop | Select-Object -ExpandProperty StatusCode    
        }
        else {
            Invoke-WebRequest -Uri $Uri -Method Get -ErrorAction Stop | Select-Object -ExpandProperty StatusCode        
        }
        
    }
    catch [System.Net.WebException] {
        500
    }
}