import { Injectable, EventEmitter } from '@angular/core';
import { Http, Headers } from '@angular/http';
import 'rxjs/add/operator/toPromise';
import {User} from "../model/User";
import {AppSettings} from "../AppSettings";

@Injectable()
export class UserAuthenticationService {
    public loginStatus$: EventEmitter<boolean>;
    private isUserLogged = false;

    private headers = new Headers({'Content-Type': 'application/json'});
    private authentificationUrl = AppSettings.API_HOST + '/authentification';

    constructor(private http: Http) {
        this.loginStatus$ = new EventEmitter();
    }

    isLogged(): Promise<boolean> {
        if (localStorage.getItem('user')) {
            let user = JSON.parse(localStorage.getItem('user')) as User;
            return this.http.get(this.authentificationUrl + '/' + user.username + '?token=' + user.authToken)
                .toPromise()
                .then(response => response.json() as boolean);
        }

        return Promise.resolve(false);
    }

    getUserLogged(): User {
        if (localStorage.getItem('user')) {
            let user = JSON.parse(localStorage.getItem('user')) as User;

            return user;
        }
    }

    setUserLogged(user: User) {
        localStorage.setItem('user', JSON.stringify(user));
    }

    login(username, password): Promise<any> {
        return this.http.post(this.authentificationUrl, JSON.stringify({ username: username, password: password }), {headers: this.headers})
            .toPromise()
            .then((response) => {
                return new Promise(function (resolve, reject) {
                    let user = response.json() as User;

                    if (user && user.authToken && !response.json().error) {
                        localStorage.setItem('user', JSON.stringify(user));

                        return resolve(user);
                    } else {
                        return reject(response.json().error);
                    }
                });
            });
    }

    logout() {
        localStorage.removeItem('user');
        this.isUserLogged = false;
        this.loginStatus$.emit(false);
    }

    setLogged() {
        this.isUserLogged = true;
        this.loginStatus$.emit(true);
    }
}