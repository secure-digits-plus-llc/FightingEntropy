# https://youtu.be/vmDVKwTF2Zc

# I originally blamed Microsoft for these attacks...

# Here is the link: https://vuxml.freebsd.org/freebsd/c2576e14-36e2-11e9-9eda-206a8a720317.html

# A crafted malicious authenticated mode 6 (ntpq) packet from a permitted network address can trigger a NULL pointer dereference, crashing ntpd.
# Note that for this attack to work, the sending system must be on an address that the target's ntpd accepts mode 6 packets from, and must use a private key that is specifically listed as being used for mode 6 authorization.
# Impact: The ntpd daemon can crash due to the NULL pointer dereference, causing a denial of service

# In laymans terms, what it means is that a former employer who has shadowed me over the course of the last 9 years 
# AKA, the company known as Nfrastructure, 
# AKA, a tiny dicked douchebag named Daniel Pickett, 
# And, an additional tiny dicked douchebag previous employee/manager, CCNA Matthew Caldwell...
#
# These individuals used a Microsoft certificate from a government time server called 'time.nist.gov', and/or 
# 'time.windows.com' to deposit a ransomware attack that resulted in: 

# (2) systems with Michael Niehaus's PSD-Master scripts on them, AND, 
# (1) system that happened to be FreeBSD based enterprise routing solution...

# All of these systems required a 100% format and restore, and 100% loss of any meaningful data...
# To which I was 100% able to restore...
# https://youtu.be/5Cyp3pqIMRs 
# ...because I do not have a tiny dick at all. I know they probably thought that I did... but unfortunately, they are both
# very upset that I do not have a penis that requires a microscope to actually see. 

# The reason I am certain that it had something to do with these 'small dicked' individuals I have mentioned, is two fold...

# They were foolish enough to use the same exact CVE on (3/6/19 - 3/7/19) when I had a completely different setup, (still BSD based),
# when I had a completely different ISP, in a place that was 40 miles away, on totally different equipment...

# But also, because I had made an audio recording on my Apple iPhone 8+ on January 11, 2019 where I talked about how
# I highly suspected that some tiny dicked little douchebag from Nfrastructure was watching me and listening to my voice
# recordings even though I hadn't even UPLOADED them anywhere... ever since they fired me 8 years prior...
# ...for telling them that they should learn how to stop sucking each other's dicks, and make sure their employees have the
# information they need to do their job. Unfortunately, they would rather continue blowing each other and then pay the FBI to 
# continue watching everything I do... and then use PRISM to send all of my social media posts in some completely other direction...
# and then additionally use Javascript attacks to keylog my activities on a constant basis, whereby resulting in the video I made 
# last night... 

# https://youtu.be/xyfW9CdOYJY

# Pretty cool stuff.

# It is for all of these reasons listed above that I began to suspect that the USA-Patriot Act of 2001 was actually a way for
# companies like his to routinely generate revenue and completely bypass any requirement to prove to anybody how small their
# penises happen to be... Because... they can pay the FBI, NSA, State Police, Comcast, Spectrum, etc, so forth...

# ...even when I am doing nothing illegal. At all. I have contacted *ALL* of these organizations, even Verizon... every 
# single one of these organizations 'ignored me'. Which is cool.

# In order to routinely prove just how small these men's penises actually are, they will use 'Technological Tyranny'.

# 'Technological Tyranny' is a term, when you happen to have such a tiny dick, that you can't help but abuse your power and
# or authority, and will do whatever it takes to censor anyone from sharing how small your penis actually is AKA, PRISM.

# Now, I would have to have a lot of luck and knowledge on my side to do these things I've suggested... to build a program 
# that proves how corrupt the system is, including the judges, police officers, federal agents....

# But Satya Nadella saved me quite a lot of trouble by coming out on Microsoft Ignite and explaining to people that 
# the government is awesome at being so incompetent at the work they do..? That somehow... $1T of cybercriminal activities took place
# in the whole entire year.

# Thank you Mr. Nadella, and thank you Mr. Niehaus for your assistance thus far. I am eternally grateful.

$BrowserResize = [ PSCustomObject ]@{

    Name    = ".\BrowserResize.cs"
    Content = @"
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.JSInterop;

    namespace ShellBlaze
    {
        public class BrowserResize
        {
            int InnerHeight;
            int InnerWidth;

            public readonly IJSRuntime JSR;

            public static event Func<Task> OnResize;

            [JSInvokable]
            public static async Task OnBrowserResize()
            {
                await OnResize?.Invoke();
            }

            public async Task<int> GetInnerHeight()
            {
                return InnerHeight = await JSR.InvokeAsync<int>( "browserResize.getInnerHeight" );
            }

            public async Task<int> GetInnerWidth()
            {
                return InnerWidth = await JSR.InvokeAsync<int>( "browserResize.getInnerWidth" );
            }

            public async Task OnInitAsync()
            {
                OnResize += BrowserHasResized;

                await JSR.InvokeAsync<object>( "browserResize.registerResizeCallback" );

                InnerHeight = await GetInnerHeight();
                InnerWidth  = await GetInnerWidth();
            }

            public async Task BrowserHasResized()
            {
                InnerHeight = await GetInnerHeight();
                InnerWidth  = await GetInnerWidth();

                var Block   = new Style();

                await Block.Variables();

            }
        }
    }
"@ }

$Layout     = [ PSCustomObject ]@{

    Name    = ".\Layout.cs"
    Content = @"
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;

    namespace ShellBlaze
    {
        public class Layout
        {
            public string LToggle { get; set; }
            public string LLogo { get; set; }
            public string LId { get; set; }

            public object[] LCs = new string[7];

            public object[] LTag = new string[7];
        }
    }
"@ }

$Select     = [ PSCustomObject ]@{

    Name    = ".\Select.cs"
    Content = @"
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;

    namespace ShellBlaze
    {
        public class Select
        {
            public Task<Layout> GetLayout(int Width)
            {
                if (Width > 720)
                {
                    return Task.FromResult(new Layout
                    {

                        LToggle = 'top',
                        LLogo   = 'toplogo',
                        LId     = 'ti',
                        LCs     = new string[] { 't0', 't1', 't2', 't3', 't4', 't5', 't6' },
                        LTag    = new string[] { 'Home', 'App<br/>Development', 'Network<br/>Security', 'Enterprise', 'OS<br/>Management', 'Hardware', 'Data<br/>Management' }
                    });
                }

                else
                {
                    return Task.FromResult(new Layout
                    {
                        LToggle = 'side',
                        LLogo   = 'sidelogo',
                        LId     = 'si',
                        LCs     = new string[] { 's0', 's1', 's2', 's3', 's4', 's5', 's6' },
                        LTag    = new string[] { 'Home', 'App Development', 'Network Security', 'Enterprise', 'OS Management', 'Hardware', 'Data Management' }
                    });
                }
            }
        }
    }
"@ }

$Sheet      = [ PSCustomObject ]@{

    Name    = ".\Sheet.cs"
    Content = @"
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.JSInterop;

    namespace ShellBlaze
    {
        public class Sheet
        {
            public readonly IJSRuntime JSR;
            public object ID       { get; set; } = "";
            public string Tag      { get; set; } = "";
            public string Property { get; set; } = "";
            public string Value    { get; set; } = "";

            public async Task<object> QuerySelect( string Tag )
            {
                return await JSR.InvokeAsync<object>( "querySel", Tag );
            }

            public async Task SetProperty( object ID , string Property , string Value )
            {
                await JSR.InvokeVoidAsync( "setProp" , ID , Property , Value );
            }
        }
    }
"@ }

$Style      = [ PSCustomObject ]@{

    Name    = ".\Style.cs"
    Content = @"
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.JSInterop;

    namespace ShellBlaze
    {
        public class Style
        {
            public readonly IJSRuntime JSR;

            int InnerHeight { get; set; }
            int InnerWidth  { get; set; }
            double Side     { get; set; }
            double Main     { get; set; }
            double Pixel    { get; set; }

            public async Task<int> GetInnerHeight()
            {
                return InnerHeight = await JSR.InvokeAsync<int>( "browserResize.getInnerHeight" );
            }

            public async Task<int> GetInnerWidth()
            {
                return InnerWidth  = await JSR.InvokeAsync<int>( "browserResize.getInnerWidth" );
            }

            public async Task Variables()
            {
                InnerHeight = await GetInnerHeight();
                InnerWidth  = await GetInnerWidth();
                Side        = InnerWidth * 0.15f;
                Main        = InnerWidth * 0.85f;
                Pixel       = InnerWidth / 1920;

                var CSS     = new Sheet();

                var root    = CSS.QuerySelect( ":root" );

                await CSS.SetProperty( root , "--root"  , InnerWidth + "px" );
                await CSS.SetProperty( root , "--side"  ,       Side + "px" );
                await CSS.SetProperty( root , "--main"  ,       Main + "px" );
                await CSS.SetProperty( root , "--pixel" ,      Pixel + "px" );

                var top  = CSS.QuerySelect( "#top"  );
                var side = CSS.QuerySelect( "#side" );
                var body = CSS.QuerySelect( "body"  );
                var main = CSS.QuerySelect( "#main" );

                if ( InnerWidth <  720 )
                {
                    await CSS.SetProperty( side , "display"        , "none"            );
                    await CSS.SetProperty(  top , "display"        , "flex"            );
                    await CSS.SetProperty( body , "flex-direction" , "column"          );
                    await CSS.SetProperty( root , "--content"      , InnerWidth + "px" );
                }

                if ( InnerWidth >= 720 )
                {
                    await CSS.SetProperty( side , "display"        , "flex"      );
                    await CSS.SetProperty( top  , "display"        , "none"      );
                    await CSS.SetProperty( body , "flex-direction" , "row"       );
                    await CSS.SetProperty( root , "--content"      , main + "px" );
                }
            }
        }
    }
"@ }
