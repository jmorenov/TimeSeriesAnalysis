import { Injectable, EventEmitter }    from '@angular/core';
import { Http } from '@angular/http';
import 'rxjs/add/operator/toPromise';
import { TimeSeries } from '../model/TimeSeries';
import { AppSettings } from '../AppSettings';

@Injectable()
export class TimeSeriesListService {
    private timeSeriesUrl = AppSettings.API_HOST + '/timeseries';
    public refreshListEvent$: EventEmitter<boolean>;

    constructor(private http: Http) {
        this.refreshListEvent$ = new EventEmitter();
    }

    getPublicTimeSeriesList(): Promise<TimeSeries[]> {
        return this.http.get(this.timeSeriesUrl)
            .toPromise()
            .then(response => response.json() as TimeSeries[]);
    }

    getUserTimeSeriesList(username: string, authToken: string): Promise<TimeSeries[]> {
        return this.http.get(this.timeSeriesUrl + 'private/' + username + '?token=' + authToken)
            .toPromise()
            .then(response => response.json() as TimeSeries[]);
    }
}