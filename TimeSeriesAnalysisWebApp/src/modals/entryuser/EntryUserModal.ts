import {Component, ViewChild, OnInit, Output, EventEmitter} from '@angular/core';
import { EntryUserView } from './EntryUserView.tpl';
import { Modal } from 'ngx-modal';
import {FormBuilder, FormGroup, Validators, FormControl} from '@angular/forms';
import { UserAuthenticationService } from '../../services/UserAuthentificationService';
import {UserValidatorService} from "../../services/UserValidatorService";
import {UserService} from "../../services/UserService";

@Component({
    selector: 'entry-user-modal',
    template: EntryUserView
})
export class EntryUserModal implements OnInit {
    @ViewChild('loginUserModal') loginUserModal: Modal;
    @ViewChild('newUserModal') newUserModal: Modal;

    loginUserForm: FormGroup;
    newUserForm: FormGroup;
    errorLoginUser = false;
    errorCreatingUser = false;

    constructor(private formBuilder: FormBuilder, private userAuthenticationService: UserAuthenticationService,
                private userValidatorService: UserValidatorService, private userService: UserService) {
    }

    ngOnInit() {
        this.loginUserForm = this.formBuilder.group({
            username: ['', Validators.compose([Validators.required, this.validateUsernameFormat])],
            password: ['', Validators.required]
        });

        this.newUserForm = this.formBuilder.group({
            username: ['',
                Validators.required,
                this.validateUsername.bind(this)
            ],
            passwords: this.formBuilder.group({
                password: ['', Validators.compose([Validators.required, this.validatePasswordFormat])],
                repeatPassword: ['', Validators.required]
            }, {validator: this.passwordsAreEqual}),
            fullName: [],
            email: ['',
                Validators.required,
                this.validateEmail.bind(this)
            ]
        });

        /*this.newUserForm.valueChanges.subscribe(data => {
            console.log('form changes', data);
        });*/
    }

    validatePasswordFormat(control: FormControl): {[key: string]: any} {
        var PASSWORD_REGEXP= /(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}/;
        var WITHOUT_SPACES = /^\S*$/;

        if (control.value !== "" && (!PASSWORD_REGEXP.test(control.value) || !WITHOUT_SPACES.test(control.value))) {
            return { passwordFormatIncorrect: true };
        }

        return null;
    }

    passwordsAreEqual(group: FormGroup) {
        var valid = false;

        if (group.controls['password'].value === group.controls['repeatPassword'].value) {
            return null;
        }

        return {
            passwordsNotEqual: true
        };
    }

    validateUsernameFormat(control: FormControl): {[key: string]: any} {
        var USERNAME_REGEXP = /[A-Za-z0-9\S]{2,25}/;
        var WITHOUT_SPACES = /^\S*$/;

        if (control.value !== "" && (!USERNAME_REGEXP.test(control.value) || !WITHOUT_SPACES.test(control.value))) {
            return { incorrectUsernameFormat: true };
        }

        return null;
    }

    validateEmailFormat(control: FormControl): {[key: string]: any} {
        var EMAIL_REGEXP = /^[a-z0-9!#$%&'*+\/=?^_`{|}~.-]+@[a-z0-9]([a-z0-9-]*[a-z0-9])?(\.[a-z0-9]([a-z0-9-]*[a-z0-9])?)*$/i;

        if (control.value !== "" && (control.value.length <= 5 || !EMAIL_REGEXP.test(control.value))) {
            return { incorrectMailFormat: true };
        }

        return null;
    }

    validateEmail(control: FormControl): {[key: string]: any} {
        return new Promise( resolve => {
            var validateEmailFormat = this.validateEmailFormat(control);

            if (validateEmailFormat === null) {
                this.userValidatorService.email(control.value).then((valid) => {
                    if (valid) {
                        resolve(null);
                    } else {
                        resolve({
                            emailUsed: true
                        });
                    }
                });
            } else {
                resolve(validateEmailFormat);
            }
        });
    }

    validateUsername(control: FormControl): {[key: string]: any} {
        return new Promise( resolve => {
            var validateUsernameFormat = this.validateUsernameFormat(control);

            if (validateUsernameFormat === null) {
                this.userValidatorService.username(control.value).then((valid) => {
                    if (valid) {
                        resolve(null);
                    } else {
                        resolve({
                            usernameUsed: true
                        });
                    }
                });
            } else {
                resolve(validateUsernameFormat);
            }
        });
    }

    openLoginUserModal() {
        this.newUserModal.close();
        this.loginUserModal.open();
    }

    openNewUserModal() {
        this.loginUserModal.close();
        this.newUserModal.open();
    }

    loginUserSubmit() {
        this.userAuthenticationService.login(this.loginUserForm.value['username'], this.loginUserForm.value['password'])
            .then((result) => {
                this.loginUserModal.close();
                this.userAuthenticationService.setLogged();
            }).catch((error) => {
                this.errorLoginUser = true;
        });
    }

    newUserSubmit() {
        let username = this.newUserForm.value['username'];
        let password = this.newUserForm.controls['passwords'].value['password'];
        let email = this.newUserForm.value['email'];
        let name = this.newUserForm.value['fullName'];

        this.userService.create(username, password, email, name).then((user) => {
            if (user && user.username) {
                this.userAuthenticationService.login(
                    username,
                    password)
                    .then((result) => {
                        this.newUserModal.close();
                        this.userAuthenticationService.setLogged();
                    }).catch((error) => {
                    this.errorCreatingUser = true;
                });
            } else {
                this.errorCreatingUser = true;
            }
        }).catch((error) => {
            this.errorCreatingUser = true;
        });
    }

    resetLoginUserForm() {
        this.loginUserForm.reset();
        this.errorLoginUser = false;
    }

    resetNewUserForm() {
        this.newUserForm.reset();
        this.errorCreatingUser = false;
    }
}
