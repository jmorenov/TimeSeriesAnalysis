export const TimeSeriesPageView = `
<div class="analysis-application-parent-container analysis-application-parent-container-time-series">
    <a class="imgcircle logo-header" routerLink="/analysisapp" routerLinkActive="active" href="#"> <img class="img_scroll" src="content/images/circle.png" alt=""></a>
    <user-control-component></user-control-component>
    <div *ngIf="loadingTimeSeries" class="analysis-application-container">
        <loading [isLoading]="loadingTimeSeries"></loading>
    </div>
    <div *ngIf="errorLoading" class="analysis-application-container">
        <div class="alert alert-danger">
            <strong>Error!</strong> {{errorLoadingMessage}}
        </div>
    </div>
    <div *ngIf="!loadingTimeSeries && !errorLoading && timeSeriesNotFound" class="analysis-application-container">
            <div class="alert alert-danger">
                <strong>Error!</strong> Time series not found.
            </div>
    </div>
    <div *ngIf="!loadingTimeSeries && !errorLoading"
         class="analysis-application-container analysis-application-container-time-series">
        <div *ngIf="!timeSeriesNotFound">
            <div class="container bottom-space">
                <div class="row">
                    <div class="time-series-title">
                        {{timeSeries.id}}
                    </div>
                </div>
                <div class="row row-with-space">
                    <div *ngIf="timeSeries.description" class="col-xs-12 col-sm-6 col-lg-8">
                        <div class="time-series-description">
                            Description
                        </div>
                        <div class="time-series-description-content">
                            <span>{{timeSeries.description}}</span>
                        </div>
                    </div>
                    <div *ngIf="timeSeries.referenceUrl" class="col-xs-6 col-lg-4">
                        <div class="time-series-reference-url">
                            <span>
                                <a class="time-series-reference-url" href="timeSeries.referenceUrl">{{timeSeries.referenceUrl}}</a>
                            </span>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-xs-6 col-sm-4">
                        <span class="parameter-name">Start date: </span>
                        {{timeSeries.startDate.date}}
                    </div>
                    <div class="col-xs-6 col-sm-4">
                        <span class="parameter-name">End date: </span>
                        {{timeSeries.endDate.date}}
                    </div>
                    <div class="col-xs-6 col-sm-4">
                        <span class="parameter-name">Timezone: </span>
                        {{timeSeries.timezone}}
                    </div>
                </div>
                <div class="row">
                    <div class="col-xs-6 col-sm-4">
                        <span class="parameter-name">Number of values: </span>
                        {{timeSeries.numberOfValues}}
                    </div>
                    <div class="col-xs-6 col-sm-4">
                        <span class="parameter-name">Number of variables: </span>
                        {{timeSeries.numberOfVars}}
                    </div>
                    <div class="col-xs-6 col-sm-4">
                        <span class="parameter-name">Frequency: </span>
                        {{timeSeries.frequency}}
                    </div>
                </div>
                <div class="row">
                    <div class="col-xs-6 col-sm-4">
                        <span class="parameter-name">Maximum of the values: </span>{{timeSeries.max}}
                        <span class="parameter-name"> in the date</span> {{timeSeries.maxDate.date}}
                    </div>
                    <div class="col-xs-6 col-sm-4">
                        <span class="parameter-name">Minimum of the values: </span>{{timeSeries.min}}
                        <span class="parameter-name"> in the date</span> {{timeSeries.minDate.date}}
                    </div>
                    <div class="col-xs-6 col-sm-4">
                        <span class="parameter-name">Mean of the values: </span>
                        {{timeSeries.mean}}
                    </div>
                </div>
                <div class="row" *ngIf="timeSeries.username">
                    <div class="col-xs-6 col-sm-4">
                        <span class="parameter-name">Uploaded by: </span>{{timeSeries.username}}
                    </div>
                </div>
            </div>
            <chart [options]="options"></chart>
            <div class="analysis-results-table">
                <table class="table table-bordered">
                    <thead>
                    <tr>
                        <th>Apply</th>
                        <th>Method</th>
                        <th>Parameters</th>
                        <th>To</th>
                        <th>Result</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr *ngFor="let analysisResult of analysisResults; let i = index" >
                        <td>{{analysisResult.applyType.id}}</td>
                        <td>
                            {{analysisResult.method.id}}
                        </td>
                        <td>{{analysisResult.method.parameters}}</td>
                        <td>{{analysisResult.to.id}}</td>
                        <td>
                            <span *ngIf="!analysisResult.analysisFinished">
                                <button *ngIf="!analysisResult.runningAnalysis" (click)="runAnalysis(analysisResult)">Run</button>
                                <div *ngIf="analysisResult.runningAnalysis" class="loading-bar"></div>
                            </span>
                            <analysis-result-modal [analysisResult]="analysisResult"></analysis-result-modal>
                            <span *ngIf="analysisResult.analysisFinished && analysisResult.error">Error</span>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <select class="form-control" [ngModel]="stringify(applySelected)" (ngModelChange)="onChangeApply($event)">
                            <option *ngFor="let apply of applyTypes" [ngValue]=stringify(apply) >{{apply.id}}</option>
                            </select>
                        </td>
                        <td>
                            <select  class="form-control"
                                     [ngModel]="stringify(methodSelected)"
                                     (ngModelChange)="onChangeMethod($event)" id="method" name="method">
                                <option [ngValue]=stringify(method) *ngFor="let method of methods">{{method.id}}</option>
                            </select>
                        </td>
                        <td>
                            <input  *ngIf="applySelected.id === 'prediction'"
                                    class="form-control" 
                                    placeholder="Train percent"
                                     [(ngModel)]="parameters" type="number" id="parameters" name="parameters">
                        </td>
                        <td>
                            <select *ngIf="applySelected.id !== 'transformation'" class="form-control"
                                    [ngModel]="stringify(toSelected)"
                                    (ngModelChange)="onChangeTo($event)">
                                <option [ngValue]="stringify(originalTimeSeries)">{{originalTimeSeries.id}}</option>
                                <option [ngValue]=stringify(transformation) *ngFor="let transformation of transformations">Transformation {{transformation.id}}</option>
                            </select>
                            <span *ngIf="applySelected.id === 'transformation'">{{originalTimeSeries.id}}</span>
                        </td>
                        <td></td>
                    </tr>
                    <tr>
                        <td colspan="5">
                            <button (click)="addAnalysis()" class="btn btn-info btn-add-analysis">+</button>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
`