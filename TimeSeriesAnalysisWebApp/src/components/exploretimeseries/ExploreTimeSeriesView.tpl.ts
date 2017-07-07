export const ExploreTimeSeriesView = `
    <div class="col-xs-12 col-sm-6 col-md-6 col-lg-6 panel panel-primary list-timeseries full-container">
        <h3>Explore public time series</h3>
        <loading [isLoading]="loadingTimeSeries"></loading>
        <table class="table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Values</th>
                    <th>Variables</th>
                    <th>Uploaded by</th>
                </tr>
            </thead>
            <tbody *ngIf="timeSeriesList && timeSeriesList.length">
                <tr *ngFor="let timeSeries of timeSeriesList"
                    class="select-time-series"
                    routerLink="/analysisapp/timeseries/{{timeSeries.id}}"
                    routerLinkActive="active">
                    <td>{{timeSeries.id}}</td>
                    <td>{{timeSeries.numberOfValues}}</td>
                    <td>{{timeSeries.numberOfVars}}</td>
                    <td>{{timeSeries.username}}</td>
                </tr>
            </tbody>
        </table>
        <div *ngIf="!loadingTimeSeries && (!timeSeriesList || !timeSeriesList.length)" class="alert alert-info">
            <strong>No time series founds.</strong>
        </div>
        <div *ngIf="errorLoading" class="alert alert-danger">
            <strong>Error!</strong> Something failed while loading the list of time series.
        </div>
    </div>
`;