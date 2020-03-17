# For collecting information related to AD/OU/CN/Proxy Information etc.

Function Get-TelemetryData
{
    [ CmdLetBinding () ] Param (

        [ Parameter ( ) ] [ String ] $Organization = "Default" ,
        [ Parameter ( ) ] [ String ] $CommonName   = "Default" )
    
    If ( ( Test-Connection 1.1.1.1 -Count 1 ) -ne $Null )
    {
        [ Net.ServicePointManager ]::SecurityProtocol = 3072

        $Location                  = ( IWR -URI "http://ifconfig.me/ip" ).Content | % { IRM -URI "http://ipinfo.io/$_" -Method Get }
        $APIKey                    = "tZqSUOHxpjLy9kyOLKspvyZmjciB0nWpxz6PMl3KQNQBNEnW5sCbTKkKBPalSOBk"
        $Region                    = $( Try { IRM -URI "https://www.zipcodeapi.com/rest/$APIKey/info.json/$( $Location.Postal )/degrees" } Catch { $Location.City } )
        $SiteLink                  = ( ( $Region.Split( ' ' ) | % { $_[0] } ) -join '' ) , $Location.Postal -join '-'

        [ PSCustomObject ]@{

            ExternalIP             = $Location.IP
            State                  = $Location.Region
            Organization           = $Organization
            CommonName             = $CommonName
            Location               = $Region.City | % { If ( $_ -ne $Null ) { $_ } Else { $Location.City } }
            Country                = $Location.Country
            ZipCode                = $Location.Postal
            TimeZone               = $Location.TimeZone 
            SiteLink               = $SiteLink
        }
    }
    
    Else 
    { 
        "Failed"
        Break  
    }
}
