import {UserControlView} from "./UserControlView";
import {Component, ViewChild} from "@angular/core";
import {UserAuthenticationService} from "../../services/UserAuthentificationService";
import {EntryUserModal} from "../../modals/entryuser/EntryUserModal";
import {User} from "../../model/User";

@Component({
    selector: 'user-control-component',
    template: UserControlView
})
export class UserControlComponent {
    private isUserLogged: boolean;
    private user: User;
    private isUserStatusChecked = false;

    @ViewChild(EntryUserModal) entryUserModal: EntryUserModal;

    constructor(private userAuthenticationService: UserAuthenticationService) {}

    ngAfterViewInit() {
        this.userAuthenticationService.loginStatus$.subscribe(isUserLogged => this.isUserLoggedEvent(isUserLogged));
    }

    isUserLoggedEvent(isLogged: boolean) {
        this.isUserLogged = isLogged;
        this.isUserStatusChecked = true;

        if(this.isUserLogged) {
            this.user = this.userAuthenticationService.getUserLogged();
        }
    }

    openLoginUserModal() {
        this.entryUserModal.openLoginUserModal();
    }

    openNewUserModal() {
        this.entryUserModal.openNewUserModal();
    }

    logout() {
        this.userAuthenticationService.logout();
    }
}