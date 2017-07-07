import {Component, ViewChild, OnInit} from '@angular/core';
import { EditUserView } from './EditUserView.tpl';
import {FormGroup, FormBuilder, Validators, FormControl} from "@angular/forms";
import {UserAuthenticationService} from "../../services/UserAuthentificationService";
import {UserService} from '../../services/UserService';
import {UserValidatorService} from '../../services/UserValidatorService';
import {Modal} from 'ngx-modal';

@Component({
    selector: 'edit-user-modal',
    template: EditUserView
})
export class EditUserModal implements OnInit {
    @ViewChild('editUserModal') editUserModal: Modal;

    private editUserForm: FormGroup;
    private errorUpdatingUser = false;

    constructor(private formBuilder: FormBuilder, private userAuthenticationService: UserAuthenticationService,
                private userValidatorService: UserValidatorService, private userService: UserService) {
    }

    ngOnInit() {
        this.editUserForm = this.formBuilder.group({
            passwords: this.formBuilder.group({
                newPassword: ['', this.validatePasswordFormat.bind(this)],
                repeatNewPassword: ['']
            }, {validator: this.passwordsAreEqual}),
            fullName: [],
            email: ['', ,
                this.validateEmail.bind(this)
            ]
        }, {validator: this.validateForm.bind(this)});
    }

    validateForm(group: FormGroup) {
        if (this.isNull(group.controls['passwords']['controls']['newPassword']['value'])
            && this.isNull(group.controls['email'].value)
            && this.isNull(group.controls['fullName'].value)) {
            return {
                allFieldsEmptyError: true
            };
        }

        return null;
    }

    validatePasswordFormat(control: FormControl): {[key: string]: any} {
        var PASSWORD_REGEXP= /(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}/;
        var WITHOUT_SPACES = /^\S*$/;

        if (!this.isNull(control.value) && (!PASSWORD_REGEXP.test(control.value) || !WITHOUT_SPACES.test(control.value))) {
            return { passwordFormatIncorrect: true };
        }

        return null;
    }

    passwordsAreEqual(group: FormGroup) {
        if (group.controls['newPassword'].value === group.controls['repeatNewPassword'].value) {
            return null;
        }

        return {
            passwordsNotEqual: true
        };
    }

    validateEmailFormat(control: FormControl): {[key: string]: any} {
        var EMAIL_REGEXP = /^[a-z0-9!#$%&'*+\/=?^_`{|}~.-]+@[a-z0-9]([a-z0-9-]*[a-z0-9])?(\.[a-z0-9]([a-z0-9-]*[a-z0-9])?)*$/i;

        if (!this.isNull(control.value) && (control.value.length <= 5 || !EMAIL_REGEXP.test(control.value))) {
            return { incorrectMailFormat: true };
        }

        return null;
    }

    validateEmail(control: FormControl): {[key: string]: any} {
        return new Promise( resolve => {
            var validateEmailFormat = this.validateEmailFormat(control);

            if (!this.isNull(control.value) && validateEmailFormat === null) {
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

    isNull(value) {
        return value === '' || value === undefined || value === null;
    }

    resetEditUserForm() {
        this.editUserForm.reset();
        this.errorUpdatingUser = false;
    }

    editUserSubmit() {
        let loggedUser = this.userAuthenticationService.getUserLogged();
        let newPassword = this.editUserForm.controls['passwords'].value['newPassword'];
        let email = this.editUserForm.value['email'];
        let name = this.editUserForm.value['fullName'];

        loggedUser.email = !this.isNull(this.editUserForm.value['email']) ? this.editUserForm.value['email'] : loggedUser.email;
        loggedUser.name = !this.isNull(this.editUserForm.value['fullName']) ? this.editUserForm.value['fullName'] : loggedUser.name;

        this.userService.update(loggedUser, newPassword).then((updatedUser) => {
            if (!updatedUser['error']) {
                this.editUserModal.close();
                this.userAuthenticationService.setLogged();
            } else {
                this.errorUpdatingUser = true;
            }
        }).catch((error) => {
           this.errorUpdatingUser = true;
        });
    }

    open() {
        this.editUserModal.open();
    }
}