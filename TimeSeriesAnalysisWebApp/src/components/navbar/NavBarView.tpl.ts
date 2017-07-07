export const NavBarView = `
    <nav class="navbar-default navbar-fixed-top" role="navigation" [ngClass]="{'navbar-fixed': navbarOnTop}">
        <div class="container">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-ex1-collapse">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand navbar-header" pageScroll [pageScrollDuration]="500" href="#home">TimeSeriesAnalysis</a>
            </div>
    
            <div #navbarmenu class="collapse navbar-collapse navbar-right navbar-ex1-collapse">
                <ul class="nav navbar-nav">
                    <li class="menuItem"><a class="navbar-menu-item" pageScroll [pageScrollDuration]="500" href="#project">Project</a></li>
                    <li class="menuItem"><a class="navbar-menu-item" pageScroll [pageScrollDuration]="500" href="#timeseries">Time Series</a></li>
                    <li class="menuItem"><a class="navbar-menu-item" pageScroll [pageScrollDuration]="500" href="#timeseries-analysis">Time Series Analysis</a></li>
                    <li class="menuItem"><a class="navbar-menu-item" pageScroll [pageScrollDuration]="500" href="#application">About Application</a></li>
                    <li class="menuItem"><button type="button" routerLink="/analysisapp" routerLinkActive="active" class="btn btn-info btn-navbar">Start Analysis App</button></li>
                </ul>
            </div>
        </div>
    </nav>
`