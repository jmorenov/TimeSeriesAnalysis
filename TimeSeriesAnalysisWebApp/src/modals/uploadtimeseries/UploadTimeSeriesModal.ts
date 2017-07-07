import {Component, OnInit, ChangeDetectorRef, ViewChild, ChangeDetectionStrategy} from '@angular/core';
import { TimeSeriesUpload } from '../../model/TimeSeriesUpload';
import {FormBuilder, FormGroup, Validators, FormControl} from '@angular/forms';
import { TimeSeriesUploaderService } from "../../services/TimeSeriesUploaderService";
import { UploadTimeSeriesView } from './UploadTimeSeriesView.tpl';
import { UserAuthenticationService } from '../../services/UserAuthentificationService';
import { EntryUserModal } from '../entryuser/EntryUserModal';
import { Modal } from 'ngx-modal';
import {TimeSeriesValidatorService} from "../../services/TimeSeriesValidatorService";
import {AppSettings} from "../../AppSettings";
import {TimeSeriesListService} from "../../services/TimeSeriesListService";

@Component({
    selector: 'upload-time-series-modal',
    template: UploadTimeSeriesView
})
export class UploadTimeSeriesModal implements OnInit {
    submitted = false;
    timeSeries = new TimeSeriesUpload();
    uploadTimeSeriesForm: FormGroup;
    fileSelected = false;
    file: File;
    progress = 0;
    uploading = false;
    errorUploading = undefined;
    isUserLogged = false;
    incorrectFileExtension = false;
    fileSizeError = false;

    @ViewChild(EntryUserModal) entryUserModal: EntryUserModal;
    @ViewChild('uploadTimeSeriesModal') uploadTimeSeriesModal: Modal;

    constructor(private formBuilder: FormBuilder, private timeSeriesUploaderService: TimeSeriesUploaderService,
                private ref: ChangeDetectorRef, private userAuthenticationService: UserAuthenticationService,
                private timeSeriesValidatorService: TimeSeriesValidatorService,
                private timeSeriesListService: TimeSeriesListService) {

        this.userAuthenticationService.loginStatus$.subscribe(isUserLogged => this.isUserLoggedEvent(isUserLogged));
    }

    isUserLoggedEvent(isLogged: boolean) {
        this.isUserLogged = isLogged;
    }

    ngOnInit() {
        var me = this;

        this.uploadTimeSeriesForm = this.formBuilder.group({
            id: ['', Validators.required, this.validateId.bind(this)],
            file: [''],
            isPrivate: [''],
            withoutDates: [''],
            description: [],
            referenceUrl: [],
            timezone: ['GMT']
        });

        this.timeSeriesUploaderService.progress$.subscribe(
            data => {
                me.progress = data;
                me.ref.detectChanges();
            });

        //this.uploadTimeSeriesForm.valueChanges.subscribe(data => console.log('form changes', data));
    }

    ngOnDestroy(){
        this.ref.detach();
    }

    validateIdFormat(control: FormControl): {[key: string]: any} {
        var TIMESERIES_REGEXP = /[A-Za-z0-9]{2,25}/;
        var WITHOUT_SPACES = /^\S*$/;

        if (control.value !== "" && (!TIMESERIES_REGEXP.test(control.value) || !WITHOUT_SPACES.test(control.value))) {
            return { incorrectIdFormat: true };
        }

        return null;
    }

    validateId(control: FormControl): {[key: string]: any} {
        return new Promise( resolve => {
            var validateIdFormat = this.validateIdFormat(control);

            if (validateIdFormat === null) {
                this.timeSeriesValidatorService.id(control.value).then((valid) => {
                    if (valid) {
                        resolve(null);
                    } else {
                        resolve({
                            idUsed: true
                        });
                    }
                });
            } else {
                resolve(validateIdFormat);
            }
        });
    }

    onFileChange(event) {
        this.file = event.srcElement.files[0];

        if (this.file !== undefined) {
            this.fileSelected = true;
            if (this.file.type === 'text/csv' || (/\.(csv)$/i).test(this.file.name)) {
                this.incorrectFileExtension = false;
                if (this.file.size > AppSettings.MAX_SIZE_FILE) {
                    this.fileSizeError = true;
                } else {
                    this.fileSizeError = false;
                }
            } else {
                this.incorrectFileExtension = true;
            }
        } else {
            this.fileSelected = false;
            this.incorrectFileExtension = false;
        }
    }

    onSubmit() {
        var me = this,
            user;

        this.userAuthenticationService.isLogged().then((isLogged) => {
            if (isLogged) {
                this.userAuthenticationService.setLogged();
                user = this.userAuthenticationService.getUserLogged();
                this.timeSeries = this.uploadTimeSeriesForm.value;
                this.timeSeries.file = this.file;
                this.timeSeries.username = user.username;
                this.timeSeries.public = this.uploadTimeSeriesForm.value['isPrivate'] === 'true' ? false : true;
                this.timeSeries.withDates = this.uploadTimeSeriesForm.value['withoutDates'] === 'true' ? false : true;
                this.uploading = true;

                this.timeSeriesUploaderService.upload(this.timeSeries, user).subscribe((result) => {
                    this.uploading = false;
                    if (result['error']) {
                        this.errorUploading = result['error'];
                    } else {
                        this.submitted = true;
                        this.timeSeriesListService.refreshListEvent$.emit(true);
                    }
                }, (error) => {
                    this.errorUploading = error.message | error;
                });
            }
            else {
                this.userAuthenticationService.logout();
                this.uploadTimeSeriesModal.close();
                this.openLoginModal();
            }
        });
    }

    resetUploadForm() {
        this.uploadTimeSeriesForm.reset();
        this.fileSelected = false;
        this.submitted = false;
        this.uploading = false;
        this.progress = 0;
        this.errorUploading = undefined;
    }

    openLoginModal() {
        this.entryUserModal.openLoginUserModal();
    }
}