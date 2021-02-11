Function Install-IISServer
{
    Get-WindowsFeature | ? Name -in ( [_iisfeatures]::New().Features ) | ? Installed -eq 0 | % { 
        
        Write-Host "{0}" -f $_.Name
        Install-WindowsFeature -Name $_.Name -IncludeAllSubFeature -IncludeManagementTools
    }
}
