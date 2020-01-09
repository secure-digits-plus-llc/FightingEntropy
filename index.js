
    var start                  = window.innerWidth;
    var scale                  = start;
    var wait                   = true;
    var font                   = 48;
    var h1                     = document.querySelector('h1');

    h1.style.setProperty("--h1-size",font);

    function getWindowWidth()
    {
        if ( scale    != window.innerWidth )
        {
            scale              = window.innerWidth
            font               = scale / 28

            var h1             = document.querySelector('h1');
            h1.style.setProperty("--h1-size",font);

            if ( wait == true )
            {
                console.log( scale );

                wait = false;

                setTimeout( () =>
                {
                    wait = true;

                }, 200 );
            }
        }
    }

    getWindowWidth();

    window.addEventListener("resize",getWindowWidth);
