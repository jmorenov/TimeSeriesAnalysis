import { Injectable }    from '@angular/core';
import { Headers, Http } from '@angular/http';
import 'rxjs/add/operator/toPromise';
import { User } from '../model/User';
import { AppSettings } from '../AppSettings';

@Injectable()
export class UserService {
    private headers = new Headers({'Content-Type': 'application/json'});
    private userUrl = AppSettings.API_HOST + '/users';

    constructor(private http: Http) { }

    get(username: string, authToken: string): Promise<User> {
        return this.http.get(this.userUrl + '/' + username + '?token=' + authToken)
            .toPromise()
            .then(response => response.json() as User);
    }

    create(username: string, password: string, email: string, name: string): Promise<User> {
        return this.http.post(this.userUrl, JSON.stringify({
                user: {
                    username: username,
                    email: email,
                    name: name
                },
                password: password
            }), {headers: this.headers})
            .toPromise()
            .then(res => res.json() as User);
    }

    update(user: User, password: string): Promise<User> {
        return this.http.put(this.userUrl, JSON.stringify({
            user: user,
            password: password,
        }), {headers: this.headers})
            .toPromise()
            .then(res => res.json() as User);
    }
}