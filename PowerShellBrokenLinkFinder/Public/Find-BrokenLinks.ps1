function Find-BrokenLinks([string]$Url, [bool]$First = $false)
{
    if ($First) { 
        $Global:All_Internal_Links += $Url
        Write-Host -ForegroundColor Green "START"
    }

    Write-Host -ForegroundColor Cyan "Find broken links for '$Url' ->"

    $Result = Check-Uri -Uri $Url
    if ($Result -eq 200) {
        # New-Object psobject -Property @{
        #     Base = $Url
        #     Uri = $_
        #     Status = "OK"
        # }
    }
    else {
        New-Object psobject -Property @{
            Base = $Url
            Uri = $_
            Status = "Error"
        }
    }

    $Links = Find-Links -Url $Url

    Write-Verbose "$($Links.Count) links found"

    # collext external links
    $External_Links = @($Links | Where-Object { $_.External -eq $true} | Select-Object -ExpandProperty Uri | Get-Unique)
    
    # collect internal links
    $Internal_Links = @($Links | Where-Object { $_.External -eq $false} | Select-Object -ExpandProperty Uri | Get-Unique)

    if ($External_Links.Count -gt 0)
    {
        Write-Host -ForegroundColor Green "External links..."

        $External_Links | ForEach-Object {

            $U = $_

            # check only once
            if ($U -in $Global:All_External_Links) { return }

            $Global:All_External_Links += $U

            $Result = Check-Uri -Uri $U
            if ($Result -eq 200) {
                
                # New-Object psobject -Property @{
                #     Base = $Url
                #     Uri = $_
                #     Status = "OK"
                # }
            }
            else {
                New-Object psobject -Property @{
                    Base = $Url
                    Uri = $U
                    Status = "Error"
                }
            }
        }
    }
    else {
        Write-Host -ForegroundColor Blue "No external links found"
    }

    #
    # Internal links
    #

    if ($Internal_Links.Count -gt 0)
    {
        Write-Host -ForegroundColor Green "Internal links..."

        $Internal_Links | ForEach-Object {
            
            $U = $_

            # check only once
            if ($U -in $Global:All_Internal_Links) { return }   

            $Global:All_Internal_Links += $U
            Find-BrokenLinks -Url $U
        }
    }
    else {
        Write-Host -ForegroundColor Blue "No internal links found"
    }
}

. .\PowerShellBrokenLinkFinder\Private\Find-Links.ps1
. .\PowerShellBrokenLinkFinder\Private\Check-Uri.ps1

Clear-Host
$Global:All_External_Links = @()
$Global:All_Internal_Links = @()

#Find-BrokenLinks -Url "https://sonneberg.de" -First $true