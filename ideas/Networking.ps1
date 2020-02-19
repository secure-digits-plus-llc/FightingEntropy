    $ID           = [ PSCustomObject ]@{

        IPAddress = ( [ IPAddress ] "10.0.0.1" ).GetAddressBytes()
        Mask      = ( [ IPAddress ] "255.255.224.0" ).GetAddressBytes()
        Build     = 0..3
        Range     = 0..3
        Count     = @( )
    }

    ForEach ( $I in 0..3 )
    {
        $ID.Build[$I] = 256 - $ID.Mask[$I]

        If ( $ID.Build[$I] -eq 1 )
        {
            $ID.Range[$I] = $ID.IPAddress[$I]
        }

        If ( $ID.Build[$I] -in 2..255 )
        {
            $Z = $ID.Build[$I]

            ForEach ( $Y in 0..( ( 256 / $Z ) - 1 ) )
            { 
                $X = $Z * $Y | % { $_..( ( $Z * $Y ) + ( $Z - 1 ) ) }

                If ( $ID.IPAddress[$I] -in $X )
                {
                    $ID.Range[$I] = "$( $X[0] )..$( $X[$Z - 1] )"
                }
            }
        }

        If ( $ID.Build[$I] -eq    256 ) { $ID.Range[$I]  = "*" }
    }

    $ID.Count = ( IEX ( ( 0..3 | % { $ID.Build[$_] } ) -join "*" ) ) - 2
