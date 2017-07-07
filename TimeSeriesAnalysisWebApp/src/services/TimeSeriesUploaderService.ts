import { Injectable }    from '@angular/core';
import 'rxjs/add/operator/toPromise';
import { Observable } from 'rxjs/Rx';
import { TimeSeriesUpload } from "../model/TimeSeriesUpload";
import {AppSettings} from "../AppSettings";
import { User } from "../model/User";

@Injectable()
export class TimeSeriesUploaderService {
    private timeSeriesUploadUrl = AppSettings.API_HOST + '/timeseries';
    public progress$;
    private progressObserver;
    private progress;

    constructor() {
        this.progress$ = Observable.create(observer => {
            this.progressObserver = observer
        }).share();
    }

    upload(timeSeriesUpload: TimeSeriesUpload, user: User): Observable<number> {
        return Observable.create(observer => {
            let formData: any = new FormData();
            let xhr = new XMLHttpRequest();

            formData.append('timeseriesfile[]', timeSeriesUpload.file, timeSeriesUpload.file.name);
            formData.append('user', JSON.stringify(user));
            formData.append('timeseries', JSON.stringify(timeSeriesUpload));
            xhr.onreadystatechange = function () {
                if (xhr.readyState == 4) {
                    if (xhr.status == 200) {
                        observer.next(JSON.parse(xhr.response));
                        observer.complete();
                    } else {
                        observer.error(xhr.response);
                    }
                }
            };
            xhr.upload.onprogress = (event) => {
                this.progress = Math.round(event.loaded / event.total * 100);

                this.progressObserver.next(this.progress);
            };
            xhr.open("POST", this.timeSeriesUploadUrl, true);
            xhr.send(formData);
        });
    }
}