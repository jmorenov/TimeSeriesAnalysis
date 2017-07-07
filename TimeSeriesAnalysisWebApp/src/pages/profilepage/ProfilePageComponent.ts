import { Component, OnInit, ViewChild } from '@angular/core';
import { ProfilePageView } from './ProfilePageView.tpl';
import { UserAuthenticationService } from "../../services/UserAuthentificationService";
import { EntryUserModal } from "../../modals/entryuser/EntryUserModal";
import { UserService } from "../../services/UserService";
import { User } from "../../model/User";
import {TimeSeriesListService} from "../../services/TimeSeriesListService";
import {TimeSeries} from "../../model/TimeSeries";
import {EditUserModal} from "../../modals/edituser/EditUserModal";

@Component({
    template: ProfilePageView
})
export class ProfilePageComponent implements OnInit {
    @ViewChild(EntryUserModal) entryUserModal: EntryUserModal;
    @ViewChild(EditUserModal) editUserModal: EditUserModal;

    private errorLoadingUser: boolean;
    private errorLoadingTimeSeries: boolean;
    private loadingUser: boolean;
    private unauthorizedUser: boolean;
    private loadingTimeSeries: boolean;
    private timeSeriesList: TimeSeries[];
    private isUserLoggedSubscription: any;
    private user: User;

    constructor(private userAuthenticationService: UserAuthenticationService,
                private userService: UserService,
                private timeSeriesListService: TimeSeriesListService) {
        this.initVariables();
    }

    initVariables() {
        this.errorLoadingUser = false;
        this.errorLoadingTimeSeries = false;
        this.loadingUser = true;
        this.unauthorizedUser = false;
        this.loadingTimeSeries = false;
        this.timeSeriesList = undefined;
        this.user = undefined;
    }

    ngAfterViewInit() {
        this.isUserLoggedSubscription = this.userAuthenticationService.loginStatus$.subscribe(isUserLogged => this.isUserLoggedEvent(isUserLogged));
    }

    ngOnDestroy() {
        this.isUserLoggedSubscription.unsubscribe();
    }

    ngOnInit() {
        let me = this;

        this.userAuthenticationService.isLogged().then((isLogged) => {
            if (isLogged) {
                me.userAuthenticationService.setLogged();
            } else {
                me.loadingUser = false;
                me.unauthorizedUser = true;
                me.userAuthenticationService.logout();
                me.entryUserModal.openLoginUserModal();
            }
        });
    }

    isUserLoggedEvent(isLogged: boolean) {
        if (isLogged) {
            this.initVariables();
            this.unauthorizedUser = false;
            this.getloggedUser();
        } else {
            this.unauthorizedUser = true;
        }
    }

    getTimeSeriesList(): void {
        this.loadingTimeSeries = true;
        this.timeSeriesListService
            .getUserTimeSeriesList(this.user.username, this.user.authToken)
            .then((timeSeriesList) => {
                if (timeSeriesList['error']) {
                    this.errorLoadingTimeSeries = true;
                } else {
                    this.timeSeriesList = timeSeriesList;
                }
                this.loadingTimeSeries = false;
            }).catch(() => {
                this.errorLoadingTimeSeries = true;
                this.loadingTimeSeries = false;
        });
    }

    getloggedUser(): void {
        let me = this,
            loggedUser = me.userAuthenticationService.getUserLogged();

        me.userService.get(loggedUser.username, loggedUser.authToken)
            .then((user) => {
                if (user['error']) {
                    me.errorLoadingUser = true;
                } else {
                    me.userAuthenticationService.setUserLogged(user);
                    me.user = me.userAuthenticationService.getUserLogged();
                    me.getTimeSeriesList();
                }
                me.loadingUser = false;
            }).catch(() => {
                me.loadingUser = false;
                me.errorLoadingUser = true;
            });
    }
}