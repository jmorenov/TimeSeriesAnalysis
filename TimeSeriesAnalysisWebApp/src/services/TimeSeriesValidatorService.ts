import { Injectable }    from '@angular/core';
import {Http} from '@angular/http';
import 'rxjs/add/operator/toPromise';
import { AppSettings } from '../AppSettings';

@Injectable()
export class TimeSeriesValidatorService {
    private timeSeriesValidatorUrl = AppSettings.API_HOST + '/validation/timeseries';

    constructor(private http: Http) { }

    id(id: string): Promise<boolean> {
        return this.http.get(this.timeSeriesValidatorUrl + '/' + id).toPromise()
            .then(response => response.json() as boolean);
    }
}