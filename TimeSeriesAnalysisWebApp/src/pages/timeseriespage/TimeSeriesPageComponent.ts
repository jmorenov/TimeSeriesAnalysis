/**
 * Created by jmorenov on 1/09/16.
 */
import {
    Component, OnDestroy, OnInit, ViewChild, ElementRef, ViewContainerRef, ChangeDetectorRef
} from '@angular/core';
import { Subscription } from 'rxjs/Subscription';
import { ActivatedRoute } from '@angular/router';
import { TimeSeries } from '../../model/TimeSeries';
import { TimeSeriesDataService } from '../../services/TimeSeriesDataService';
import { TimeSeriesAnalysisService } from '../../services/TimeSeriesAnalysisService';
import { TimeSeriesTransformationType } from "../../model/TimeSeriesTransformationType";
import { TimeSeriesPredictMethod } from '../../model/TimeSeriesPredictMethod';
import { TimeSeriesComplexityMeasureType } from '../../model/TimeSeriesComplexityMeasureType';
import { AnalysisResult } from '../../model/AnalysisResult';
import { TimeSeriesPageView } from './TimeSeriesPageView.tpl';
import {UserAuthenticationService} from "../../services/UserAuthentificationService";

@Component({
    template: TimeSeriesPageView
})
export class TimeSeriesPageComponent implements OnInit, OnDestroy {
    timeSeries: TimeSeries;
    transformations: TimeSeriesTransformationType[];
    predictMethods: TimeSeriesPredictMethod[];
    complexityMeasures: TimeSeriesComplexityMeasureType[];
    loadingTimeSeries: boolean;
    timeSeriesNotFound: boolean;
    loadingTransformations: boolean;
    loadingPredictMethods: boolean;
    loadingComplexityMeasures: boolean;
    id: number;
    private sub: Subscription;
    options: Object;
    analysisResults = [];
    // Select
    methods: Object;
    errorLoading = false;
    errorLoadingMessage = undefined;
    parameters = undefined;
    initializing = true;

    constructor(private route: ActivatedRoute,
                private timeSeriesDataService: TimeSeriesDataService,
                private timeSeriesAnalysisService: TimeSeriesAnalysisService,
                private window: Window,
                private userAuthenticationService: UserAuthenticationService ) {
        this.userAuthenticationService.loginStatus$.subscribe(isUserLogged => this.isUserLoggedEvent(isUserLogged));
    }

    ngOnInit() {
        this.userAuthenticationService.isLogged().then((isLogged) => {
            if (isLogged) {
                this.userAuthenticationService.setLogged();
            } else {
                this.userAuthenticationService.logout();
            }
        });

        this.sub = this.route.params.subscribe(params => {
            this.id = params['id'];
        });

        this.getTimeSeries(this.id).then(() => {
            this.getComplexityMeasures().then(() => {
                this.getPredictMethods().then(() => {
                    this.getTransformations();
                    this.initializing = false;
                });
            });
        });
    }

    isUserLoggedEvent(isLogged) {
        if (!this.initializing && (!this.timeSeries || this.timeSeries['public'] === '0')) {
            this.getTimeSeries(this.id);
        }
    }

    ngOnDestroy() {
        this.sub.unsubscribe();
    }

    initAnalysisSelect() {
        this.applySelected = this.applyTypes[0];
        this.methods = this.complexityMeasures;
        this.methodSelected = this.methods[0];
        this.toSelected = this.originalTimeSeries;
        this.parameters = undefined;
    }

    applyTypes = [
        {id: 'complexitymeasure'},
        {id: 'transformation'},
        {id: 'prediction'},
        {id: 'classification'}
    ];
    classificationMethods = [
        {id: 'automatic'}
    ];
    applySelected = this.applyTypes[0];
    onChangeApply(applySelected: string) {
        this.applySelected = JSON.parse(applySelected);
        if (this.applySelected['id'] === 'complexitymeasure') {
            this.methods = this.complexityMeasures;
        } else if (this.applySelected['id'] === 'transformation') {
            this.methods = this.transformations;
        } else if (this.applySelected['id'] === 'prediction') {
            this.methods = this.predictMethods;
        } else {
            this.methods = this.classificationMethods;
        }
        this.methodSelected = this.methods[0];
    }

    stringify(o:any): string{
        return JSON.stringify(o);
    }

    runAnalysis(analysisResult: AnalysisResult) {
        analysisResult.runningAnalysis = true;
        var transformationType = analysisResult.to['id'] !== 'original' ? analysisResult.to : undefined;

        if (analysisResult.applyType['id'] === 'complexitymeasure') {
            this.timeSeriesAnalysisService.applyComplexityMeasure(this.id,
                <TimeSeriesComplexityMeasureType> analysisResult.method, <TimeSeriesTransformationType> transformationType)
                .then((timeSeriesComplexityMeasureResult) => {
                    analysisResult.setResult(timeSeriesComplexityMeasureResult);
                }).catch((error) => {
                    analysisResult.setError();
            });
        } else if (analysisResult.applyType['id'] === 'transformation') {
            this.timeSeriesAnalysisService.applyTransformation(this.id,
                <TimeSeriesTransformationType> analysisResult.method)
                .then((timeSeriesTransformationResult) => {
                    analysisResult.setResult(timeSeriesTransformationResult);
                }).catch((error) => {
                analysisResult.setError();
            });
        } else if (analysisResult.applyType['id'] === 'prediction') {
            this.timeSeriesAnalysisService.predict(this.id,
                <TimeSeriesPredictMethod> analysisResult.method,
                <TimeSeriesTransformationType> transformationType)
                .then((timeSeriesPredictResult) => {
                    analysisResult.setResult(timeSeriesPredictResult);
                }).catch((error) => {
                analysisResult.setError();
            });
        } else if (analysisResult.applyType['id'] === 'classification') {
            this.timeSeriesAnalysisService.classify(this.id,
                <TimeSeriesTransformationType> transformationType)
                .then((timeSeriesClassification) => {
                    analysisResult.setResult(timeSeriesClassification);
                }).catch((error) => {
                analysisResult.setError();
            });
        }
    }

    methodSelected: Object;
    onChangeMethod(methodSelected) {
        this.methodSelected = JSON.parse(methodSelected);
    }

    originalTimeSeries = {id: 'original'};
    toSelected = this.originalTimeSeries;
    onChangeTo(toSelected) {
        this.toSelected = JSON.parse(toSelected);
    }

    addAnalysis() {
        this.methodSelected['parameters'] = this.parameters;
        this.methodSelected = JSON.parse(JSON.stringify(this.methodSelected));

        var analysisResult = new AnalysisResult(this.applySelected, this.methodSelected, this.toSelected);

        this.analysisResults.push(analysisResult);
        this.initAnalysisSelect();
    }

    getTimeSeries(id: number) {
        var user;

        this.loadingTimeSeries = true;
        this.timeSeriesNotFound = false;
        user = this.userAuthenticationService.getUserLogged();

        return this.timeSeriesDataService
            .getTimeSeries(id, user)
            .then((timeSeries) => {
                if (!timeSeries) {
                    this.timeSeriesNotFound = true;
                    this.errorLoading = false;
                } else if (timeSeries['error']) {
                    this.timeSeriesNotFound = false;
                    this.errorLoading = true;
                    this.errorLoadingMessage = timeSeries['error'];
                } else {
                    this.errorLoading = false;
                    this.timeSeriesNotFound = false;
                    this.timeSeries = timeSeries;
                    this.initChart();
                }
                this.loadingTimeSeries = false;
            }).catch((error) => {
                this.errorLoading = true;
                this.errorLoadingMessage = error | error.message;
                this.loadingTimeSeries = false;
            });
    }

    getTransformations() {
        this.loadingTransformations = true;
        return this.timeSeriesAnalysisService
            .getTransformations()
            .then((transformations) => {
                if (transformations['error']) {
                    this.errorLoading = true;
                } else {
                    this.transformations = transformations;
                }
                this.loadingTransformations = false;
            }).catch((error) => {
                this.errorLoading = true;
                this.loadingTransformations = false;
            });
    }

    getPredictMethods() {
        this.loadingPredictMethods = true;
        return this.timeSeriesAnalysisService
            .getPredictMethods()
            .then((predictMethods) => {
                if (predictMethods['error']) {
                    this.errorLoading = true;
                } else {
                    this.predictMethods = predictMethods;
                }

                this.loadingPredictMethods = false;
            }).catch((error) => {
                this.errorLoading = true;
                this.loadingPredictMethods = false;
            });
    }

    getComplexityMeasures() {
        this.loadingComplexityMeasures = true;
        return this.timeSeriesAnalysisService
            .getComplexityMeasures()
            .then((complexityMeasures) => {
                if (complexityMeasures['error']) {
                    this.errorLoading = true;
                } else {
                    this.complexityMeasures = complexityMeasures;
                    this.methods = this.complexityMeasures;
                    this.methodSelected = this.methods[0];
                }

                this.loadingComplexityMeasures = false;
            }).catch((error) => {
                this.errorLoading = true;
                this.loadingComplexityMeasures = false;
            });
    }

    initChart() {
        var values = this.timeSeries.data.values;
        var dates = this.timeSeries.data.dates;
        var data = [];
        for (var i=0; i<values.length; i++) {
            data[i] = [dates[i]['date'], +values[i][0]];
        }

        this.options = {
            xAxis: {
                type: 'datetime',
                title: {
                    text: 'Date'
                }
            },
            series: [{
                data: data,
            }],
            chart: {
                width: this.window.innerWidth - 50
            },
            title: {
                text: ''
            }
        };
    }
}