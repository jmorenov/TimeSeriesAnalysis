import { Injectable }    from '@angular/core';
import {Http} from '@angular/http';
import 'rxjs/add/operator/toPromise';
import { AppSettings } from '../AppSettings';

@Injectable()
export class UserValidatorService {
    private userValidatorUrl = AppSettings.API_HOST + '/validation/user';

    constructor(private http: Http) { }

    username(username: string): Promise<boolean> {
        return this.http.get(this.userValidatorUrl + '/username/' + username).toPromise()
            .then(response => response.json() as boolean);
    }

    email(email: string): Promise<boolean> {
        return this.http.get(this.userValidatorUrl + '/email/' + email).toPromise()
            .then(response => response.json() as boolean);
    }
}