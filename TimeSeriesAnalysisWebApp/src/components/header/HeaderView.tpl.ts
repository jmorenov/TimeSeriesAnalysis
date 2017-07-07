export const HeaderView = `
<div id="home" class="intro-header">
    <div class="col-xs-12 text-center">
        <h1 class="h1_home">Time Series Analysis</h1>
        <h3 class="h3_home">Interactive & simple application</h3>
    </div>

    <div class="col-xs-12 text-center fade-in">
        <button type="button" routerLink="/analysisapp" routerLinkActive="active" class="btn btn-default btn-xlarge">
            Start Analysis App
        </button>
    </div>

    <div class="col-xs-12 text-center fade-in button_down">
        <a class="imgcircle" pageScroll [pageScrollDuration]="500" href="#project"> <img class="img_scroll" src="content/images/circle.png" alt=""> </a>
    </div>
</div>
`