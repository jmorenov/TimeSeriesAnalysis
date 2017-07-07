/**
 * Created by jmorenov on 1/09/16.
 */
import { Injectable } from '@angular/core';
import {Headers, Http, RequestMethod, RequestOptions, Request, URLSearchParams} from '@angular/http';
import 'rxjs/add/operator/toPromise';
import { TimeSeriesClassification } from '../model/TimeSeriesClassification';
import { TimeSeriesComplexityMeasureType } from '../model/TimeSeriesComplexityMeasureType';
import { TimeSeriesPredictMethod } from '../model/TimeSeriesPredictMethod';
import { TimeSeriesPredictResult } from '../model/TimeSeriesPredictResult';
import { TimeSeriesTransformation } from '../model/TimeSeriesTransformation';
import { TimeSeriesTransformationType } from '../model/TimeSeriesTransformationType';
import {TimeSeriesComplexityMeasureResult} from "../model/TimeSeriesComplexityMeasureResult";
import { AppSettings } from '../AppSettings';

@Injectable()
export class TimeSeriesAnalysisService {
    private headers = new Headers({'Content-Type': 'application/json'});
    private timeSeriesAnalysisUrl = AppSettings.API_HOST + '/analysis';
    constructor(private http: Http) { }

    getPredictMethods(): Promise<TimeSeriesPredictMethod[]> {
        return this.http.get(this.timeSeriesAnalysisUrl + '/predict')
            .toPromise()
            .then(response => response.json() as TimeSeriesPredictMethod[])
            .catch(this.handleError);
    }

    getTransformations(): Promise<TimeSeriesTransformationType[]> {
        return this.http.get(this.timeSeriesAnalysisUrl + '/transformation')
            .toPromise()
            .then(response => response.json() as TimeSeriesTransformationType[])
            .catch(this.handleError);
    }

    getComplexityMeasures(): Promise<TimeSeriesComplexityMeasureType[]> {
        return this.http.get(this.timeSeriesAnalysisUrl + '/complexitymeasure')
            .toPromise()
            .then(response => response.json() as TimeSeriesComplexityMeasureType[])
            .catch(this.handleError);
    }

    applyTransformation(id: number, transformationType: TimeSeriesTransformationType):
    Promise<TimeSeriesTransformation> {
        return this.http.
        post(this.timeSeriesAnalysisUrl + '/transformation/', JSON.stringify({
            'id': id,
            'transformation': transformationType
        }), {headers: this.headers})
            .toPromise()
            .then(response => response.json() as TimeSeriesTransformation)
            .catch(this.handleError);
    }

    applyComplexityMeasure(id: number, complexityMeasure: TimeSeriesComplexityMeasureType, transformationType: TimeSeriesTransformationType):
    Promise<TimeSeriesComplexityMeasureResult> {
        return this.http.
        post(this.timeSeriesAnalysisUrl + '/complexitymeasure/', JSON.stringify({
            'id': id,
            'method': complexityMeasure,
            'transformation': transformationType
            }), {headers: this.headers})
            .toPromise()
            .then(response => response.json() as TimeSeriesComplexityMeasureResult)
            .catch(this.handleError);
    }

    predict(id: number, predictMethod: TimeSeriesPredictMethod, transformationType: TimeSeriesTransformationType):
    Promise<TimeSeriesPredictResult> {
        return this.http.
        post(this.timeSeriesAnalysisUrl + '/predict/', JSON.stringify({
            'id': id,
            'method': predictMethod,
            'transformation': transformationType
        }), {headers: this.headers})
            .toPromise()
            .then(response => response.json() as TimeSeriesPredictResult)
            .catch(this.handleError);
    }

    classify(id: number, transformationType: TimeSeriesTransformationType): Promise<TimeSeriesClassification> {
        return this.http.
        post(this.timeSeriesAnalysisUrl + '/classify/', JSON.stringify({
            'id': id,
            'transformation': transformationType
        }), {headers: this.headers})
            .toPromise()
            .then(response => response.json() as TimeSeriesClassification)
            .catch(this.handleError);
    }

    private handleError(error: any): Promise<any> {
        //console.error('An error occurred', error); // for demo purposes only
        return Promise.reject(error.message || error);
    }
}