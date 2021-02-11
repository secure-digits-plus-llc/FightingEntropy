Function Load-FEShare
{
    [CmdLetBinding()]Param(
    [ValidateNotNullOrEmpty()]
    [Parameter(ValueFromPipeline=$True,Mandatory)][Object]$Share)
    
    If (!(Get-PSDrive -Name $Share.Name) )
    {
        New-PSDrive -Name $Share.Name -PSProvider MDTProvider -Root $Share.Path -Description $Share.Description 
    }
}
