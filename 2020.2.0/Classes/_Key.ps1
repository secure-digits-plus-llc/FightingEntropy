Class _Key
{
    [String]           $Path
    [String]       $Username
    [Object]       $Password

    Key([String]$Path,[String]$Username,[Object]$Password)
    {
        $This.Path     = $Path
        $This.Username = $Username
        $This.Password = $Password | ConvertTo-SecureString -AsPlainText -Force
    }
}
