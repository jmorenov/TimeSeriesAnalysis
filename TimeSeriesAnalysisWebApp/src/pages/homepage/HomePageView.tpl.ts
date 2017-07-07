export const HomePageView = `
<div>
    <header-component></header-component>
    <nav-bar></nav-bar>
    <div class="navbar-space"></div>
    <div class="section first-section" id="project">
        <h1 class="project-title">The basis of the project</h1>
        <div class="container">
            <div class="row">
                <div class="col-lg-4">
                    <img class="img-circle project-images" src="content/images/r_project.png" alt="Generic placeholder image">
                    <h2>R Project</h2>
                    <p>Our analysis system is implemented mainly in R language, although more complex algorithms have been adapted into C ++.</p>
                    <p><button class="btn btn-default" (click)="openRProjectModal()" role="button">View details &raquo;</button></p>
                </div><!-- /.col-lg-4 -->
                <div class="col-lg-4">
                    <img class="img-circle project-images" src="content/images/complexity_measures.png" alt="Generic placeholder image">
                    <h2>Complexity Measures</h2>
                    <p>We use some measures of complexity with which to extract the properties of each time series to classify.</p>
                    <p><a class="btn btn-default" (click)="openComplexityMeasureModal()" role="button">View details &raquo;</a></p>
                </div><!-- /.col-lg-4 -->
                <div class="col-lg-4">
                    <img class="img-circle project-images" src="content/images/timeseries-database.png" alt="Generic placeholder image">
                    <h2>Time Series Database</h2>
                    <p>All the time series used are stored in our databases, to construct an entire library of different time series.</p>
                    <p><a class="btn btn-default" (click)="openTimeSeriesDatabaseModal()" role="button">View details &raquo;</a></p>
                </div>
            </div>
        </div>
    </div>
    <div class="section section-different" id="timeseries">
        <div class="container">
            <div class="row">
                <div class="col-md-7">
                    <h2 class="featurette-heading">Time series. <span class="text-muted">Its use is more important than it seems.</span></h2>
                    <p class="lead">The time series data sets are used in many fields of research. 
                    Our intention is to provide a system to help us understand.</p>
                    <p></p>
                </div>
                <div class="col-md-5">
                    <img class="featurette-image img-responsive center-block" src="content/images/big-data.jpg" alt="Generic placeholder image" width="458" height="267">
                </div>
            </div>
        </div>
    </div>
    <div class="section" id="timeseries-analysis">
        <div class="container">
            <div class="row">
                <div class="col-md-7 col-md-push-5">
                    <h2 class="featurette-heading">Time Series Analysis. <span class="text-muted">Intelligent system for analysis, classification and time series prediction.</span></h2>
                    <p class="lead">With our system you can upload files containing time series data and an automatic way you describe your time series, drawing properties, classify in a group and forecast with an error rate.</p>
                </div>
                <div class="col-md-5 col-md-pull-7">
                    <img class="featurette-image img-responsive center-block" src="content/images/timeseries.png" alt="Generic placeholder image">
                </div>
            </div>
        </div>
    </div>
    <div class="section section-different" id="application">
        <div class="container">
            <div class="row">
                <div class="col-md-7">
                    <h2 class="featurette-heading">Application features. <span class="text-muted">Simple and easy to use.</span></h2>
                    <p class="lead">With efficient implementation and an adapted and simple interface, any user without knowledge of time series can use it and get correct results.</p>
                </div>
                <div class="col-md-5">
                    <img class="featurette-image img-responsive center-block" src="content/images/code.png" alt="Generic placeholder image">
                </div>
            </div>
        </div>
    </div>
    <modal #rProjectModal title="R Project"
        modalClass="modal-lg"
        [hideCloseButton]="false"
        [closeOnEscape]="true"
        [closeOnOutsideClick]="true">

        <modal-header>
            <img class="img-circle modal-image-header" src="content/images/r_project.png" alt="Generic placeholder image">
        </modal-header>
    
        <modal-content>
            <p>The built-in analysis system is based on the <a href="https://www.r-project.org/">R language</a> because of the number of available libraries created by users to analyze time series.</p>
            <p>We have created a library of analysis methods that we have called TimeSeriesAnalysisLibrary, which offers us:</p>
            <ul>
                <li>Complexity measures.</li>
                <li>Clustering of results of complexity measures.</li>
                <li>Chiu calculate method of number of centers to Clustering.</li>
                <li>Time series transformations.</li>
                <li>Time series forecasting.</li>
                <li>Time series classification.</li>
                <li>And much more...</li>
            </ul>
            <p>Most of this functionality is written in R, although to improve the efficiency in the calculations more complex functions have been extracted in C ++.</p>
            <p>This library is accessed through an API (TimeSeriesAnalysisAPI) that makes the calls through script executions in R.</p>
        </modal-content>
    </modal>
    <modal #complexityMeasuresModal title="Complexity Measures"
        modalClass="modal-lg"
        [hideCloseButton]="false"
        [closeOnEscape]="true"
        [closeOnOutsideClick]="true">

        <modal-header>
            <img class="img-circle modal-image-header" src="content/images/complexity_measures.png" alt="Generic placeholder image">
        </modal-header>
    
        <modal-content>
            <p>To analyze the time series we will use measures of complexity. Each measure of complexity can be considered as a calculation that is done on the time series and returns a numerical result that identifies the complexity of the same.</p>
            <p>Complexity is a measure of the level of difficulty required to express or predict the properties of a time series.</p> 
            <p>In this system the complexity of a series is used to generate a classification tree and to make experiments and try to generate a taxonomy of time series, later obtaining an automatic method of classification of time series and choose the most accurate prediction method.</p>
            <p>The measures of complexity that we have developed have been:</p>
            <ul>
                <li>Kolmogorov</li>
                <li>LempelZiv</li>
                <li>Aproximation Entropy</li>
                <li>Permutation Entropy</li>
                <li>PracmaSample Entropy</li>
                <li>Sample Entropy</li>
                <li>Shannon Entropy</li>
                <li>ChaoSen Entropy</li>
                <li>Dirichlet Entropy</li>
                <li>MillerMadow Entropy</li>
                <li>Shrink Entropy</li>
            </ul>
        </modal-content>
    </modal>
    <modal #timeSeriesDatabaseModal title="Time Series Database"
        modalClass="modal-lg"
        [hideCloseButton]="false"
        [closeOnEscape]="true"
        [closeOnOutsideClick]="true">

        <modal-header>
            <img class="img-circle modal-image-header" src="content/images/timeseries-database.png" alt="Generic placeholder image">
        </modal-header>
    
        <modal-content>
            <p>All time series of the system that the users are adding are stored in our database, making use of the software <a href="https://www.influxdata.com/">InfluxDB</a></p>
            <p>In addition, we have built a shrinking layer with our API (TimeSeriesAnalysisAPI) that directly accesses the time series and shows them to the user dynamically and simply in our web application.</p>
        </modal-content>
    </modal>
</div>
`