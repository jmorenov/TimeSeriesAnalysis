export const UploadTimeSeriesView = `
    <entry-user-modal></entry-user-modal>
    <div class="upload-icon" *ngIf="!isUserLogged">
        <!--<img src="content/images/upload.png" alt="" (click)="openLoginModal()">-->
        <i class="fa fa-cloud-upload fa-5x" aria-hidden="true" (click)="openLoginModal()"></i>
    </div>
    <div class="upload-icon" *ngIf="isUserLogged">
       <!--<img src="content/images/upload.png" alt="" (click)="uploadTimeSeriesModal.open()">-->
       <i class="fa fa-cloud-upload fa-5x" aria-hidden="true" (click)="uploadTimeSeriesModal.open()"></i>
    </div>
    <modal #uploadTimeSeriesModal
        title="Upload new time series"
        modalClass=""
        [hideCloseButton]="false"
        [closeOnEscape]="true"
        [closeOnOutsideClick]="true"
        (onOpen)="resetUploadForm()">
     
        <modal-content>
            <div [hidden]="submitted || uploading || errorUploading">
                <form (ngSubmit)="onSubmit()" [formGroup]="uploadTimeSeriesForm">
                    <div class="form-group required">
                        <label for="id" class="control-label">Id</label>
                        <input type="text" class="form-control" id="id"
                               placeholder="My time series id"
                               required name="id"
                               formControlName="id">
                        <div *ngIf="uploadTimeSeriesForm.controls['id'].touched">
                            <div *ngIf="uploadTimeSeriesForm.controls['id'].hasError('idUsed')" class="alert alert-danger">
                                Id for time series in use
                            </div>
                            <div *ngIf="uploadTimeSeriesForm.controls['id'].hasError('incorrectIdFormat')" class="alert alert-danger">
                                Incorrect format of the Id
                            </div>
                            <div *ngIf="uploadTimeSeriesForm.controls['id'].hasError('required')" class="alert alert-danger">
                                Id is required
                            </div>
                        </div>
                    </div>
    
                    <div class="form-group required">
                        <label for="file" class="control-label">File</label>
                        <input type="file" id="file"
                               name="file"
                               formControlName="file"
                               (change)="onFileChange($event)"
                               [ngClass]="{ 'file-valid': fileSelected && !incorrectFileExtension && !fileSizeError, 
                               'file-invalid': !fileSelected || incorrectFileExtension || fileSizeError }">
                        
                        <p class="help-block">Example block-level help text here.</p>
                        <div *ngIf="uploadTimeSeriesForm.controls['file'].touched">
                            <div *ngIf="!fileSelected" class="alert alert-danger">
                                File is required
                            </div>
                            <div *ngIf="incorrectFileExtension" class="alert alert-danger">
                                File extension should be csv
                            </div>
                            <div *ngIf="fileSizeError" class="alert alert-danger">
                                File size is greater than the maximum (50MB)
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="isPrivate" class="control-label">Is time series private? (Public by defualt)</label><br/>
                        <label class="radio-inline" for="isPrivate">
                            <input type="radio" name="isPrivate"
                                    formControlName="isPrivate" [value]="'true'">Set private
                        </label>
                    </div>
                    
                    <div class="form-group">
                        <label for="withoutDates" class="control-label">Has not this time series dates? (False by defualt)</label><br/>
                        <label class="radio-inline" for="withoutDates">
                            <input type="radio" name="withoutDates"
                                    formControlName="withoutDates" [value]="'true'">Set without dates
                        </label>
                    </div>
                    
                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea class="form-control" rows="5"
                                  id="description" name="description"
                                  placeholder="This time series is about..."
                                  formControlName="description"></textarea>
                    </div>
                    <div class="form-group">
                        <label for="referenceUrl">Reference url</label>
                        <input type="url" class="form-control" id="referenceUrl"
                               name="referenceUrl" placeholder="http://mytimeseries.com"
                               formControlName="referenceUrl">
                    </div>
                    <div class="form-group">
                        <label for="timezone">Timezone</label>
                        <input type="text" class="form-control" id="timezone"
                               name="timezone" placeholder="GMT"
                               formControlName="timezone">
                    </div>
    
                    <button type="submit" class="btn btn-default"
                            [disabled]="!uploadTimeSeriesForm.valid || !fileSelected || incorrectFileExtension || fileSizeError">Upload
                    </button>
                    <button type="button" class="btn btn-default" (click)="uploadTimeSeriesModal.close()">Close</button>
                </form>
            </div>
            <div *ngIf="uploading">
                <div class="progress upload-time-series-progress">
                    <div class="progress-bar progress-bar-striped active" role="progressbar"
                         [attr.aria-valuenow]="progress" aria-valuemin="0" aria-valuemax="100"
                         [ngStyle]="{'width': progress+'%'}">
                    </div>
                </div>
                <div class="upload-time-series-progress-text">
                    {{progress}}%
                </div>
            </div>
            <div *ngIf="submitted && !errorUploading">
                <div class="alert alert-info" role="alert">
                    <span class="glyphicon glyphicon-ok" aria-hidden="true"></span>
                    <span class="sr-only">Congratulations:</span>
                    Time series successfully upload.
                </div>
                <i class="fa fa-check succesfull-upload" aria-hidden="true"></i>
                <button type="button" routerLink="/analysisapp/timeseries/{{timeSeries.id}}"
                        routerLinkActive="active" data-dismiss="modal" class="btn btn-info btn-start-timeseries">
                    Start time series analysis
                </button>
            </div>
            <div *ngIf="errorUploading">
                <div class="alert alert-danger" role="alert">
                    <span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>
                    <span class="sr-only">Error:</span>
                    {{errorUploading}}
                </div>
                <i class="fa fa-times error-upload" aria-hidden="true"></i>
            </div>
        </modal-content>
    </modal>
`;