/**
 * Created by jmorenov on 1/09/16.
 */

import { Injectable }    from '@angular/core';
import { Http } from '@angular/http';
import 'rxjs/add/operator/toPromise';
import { TimeSeries } from '../model/TimeSeries';
import { AppSettings } from '../AppSettings';
import {User} from "../model/User";

@Injectable()
export class TimeSeriesDataService {
    private timeSeriesDataUrl = AppSettings.API_HOST + '/timeseries';

    constructor(private http: Http) { }

    getTimeSeries(id: number, user: User): Promise<TimeSeries> {
        var url;

        if (user === undefined) {
            url = this.timeSeriesDataUrl + '/' + id
        } else {
            url = this.timeSeriesDataUrl + '/' + id + '/' + user.username + '?token=' + user.authToken;
        }
        return this.http.get(url)
            .toPromise()
            .then(response => response.json() as TimeSeries);
    }
}