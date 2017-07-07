export const AnalysisPageView = `
<div class="analysis-application-parent-container">
    <a class="imgcircle logo-header" routerLink="/" routerLinkActive="active" href="#"> <img class="img_scroll" src="content/images/circle.png" alt=""></a>
    <user-control-component></user-control-component>
    <div class="analysis-application-container">
        <explore-time-series-component></explore-time-series-component>
        <upload-time-series-component></upload-time-series-component>
    </div>
</div>
`;