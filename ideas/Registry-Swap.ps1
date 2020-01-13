    # For looping the same registry file instead of all 4, from https://www.blackmanticore.com/268d200a495b21106add763beefe757c
    # Needs params to be more amphibuous

     $File      = [ PSCustomObject ]@{

        Path   = "$Home\Desktop"
        File   = "test.reg"
        Type   = "png"
        Next   = "jpg"
        Pull   = ""
        Swap   = ""
        Dest   = ""
    }

    $File | % {

        $_.Pull = "{0}\{1}"     -f $_.Path , $_.File

        $_.Swap = ( GC $_.Pull ).Replace( $_.Type , $_.Next )

        $_.Dest = "{0}\{1}.reg" -f $_.Path , $_.Next

        SC $_.Dest $_.Swap

        REG IMPORT $_.Dest

        RI $_.Dest 
    }
