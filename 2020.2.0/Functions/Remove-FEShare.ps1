Function Remove-FEShare
{
    [CmdLetBinding()]Param(
    [ValidateNotNullOrEmpty()]
    [Parameter(ValueFromPipeline=$True,Mandatory)][Object]$Share)
    
    If (Get-PSDrive -Name $Share.Name)
    {
        Remove-PSDrive -Name $Share.Name
    }
}
