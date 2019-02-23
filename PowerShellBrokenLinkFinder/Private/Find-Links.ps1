function Find-Links([string]$Url)
{
    $Site = Invoke-WebRequest -Uri $Url
    $Base = $Site.BaseResponse.ResponseUri.AbsoluteUri
    $Base_Uri = [Uri]$Base

    $All_Hyperlinks = @($Site.Links.Href | Get-Unique)
    
    if ($All_Hyperlinks.Count -eq 0) { return}
    
    $All_Hyperlinks | Where-Object {$_ -ne $null } | ForEach-Object {

        $This_Uri = [uri]$_

        if ($_ -notlike "#*")
        {
            if (-not $This_Uri.IsAbsoluteUri)
            {
                $This_Uri = New-Object System.Uri $Base_Uri, $_
            }

            if (($This_Uri.Scheme -eq "http") -or ($This_Uri.Scheme -eq "https"))
            {
                New-Object psobject -Property @{
                    Uri = $This_Uri.AbsoluteUri
                    External = ($This_Uri.Host -ne $Base_Uri.Host)
                }
            }
        }
    }
}