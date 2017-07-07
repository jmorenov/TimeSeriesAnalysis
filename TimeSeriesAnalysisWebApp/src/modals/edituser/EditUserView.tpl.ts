export const EditUserView = `
<modal #editUserModal
        title="Edit user"
        modalClass="modal-sm entry-user-modal"
        [hideCloseButton]="false"
        [closeOnEscape]="true"
        [closeOnOutsideClick]="true"
        (onOpen)="resetEditUserForm()">
     
        <modal-content>
            <form [formGroup]="editUserForm">       
                <div class="form-group not-border-left-red" formGroupName="passwords">
                    <label for="newPassword" class="control-label">New Password</label>
                    <input type="password" class="form-control" id="newPassword"
                           placeholder="Enter your new password"
                           name="newPassword"
                           formControlName="newPassword">
                    <label for="repeatNewPassword" class="control-label">Repeat new password</label>
                    <input type="password" class="form-control" id="repeatNewPassword"
                           placeholder="Repeat your new password"
                           name="repeatNewPassword"
                           formControlName="repeatNewPassword">
                    <div *ngIf="editUserForm.controls.passwords.controls['newPassword'].touched">
                        <div *ngIf="editUserForm.controls.passwords.controls['newPassword'].hasError('passwordFormatIncorrect')" class="alert alert-danger">
                                Password must be longer than 6 characters, contains at least one number, one lowercase and one uppercase letter.
                        </div>
                    </div>
                    <div *ngIf="editUserForm.controls.passwords.controls['newPassword'].touched && editUserForm.controls.passwords.controls['repeatNewPassword'].touched">
                        <div *ngIf="editUserForm.controls.passwords.hasError('passwordsNotEqual')" class="alert alert-danger">
                            Passwords are not the same
                        </div>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="email" class="control-label">New Email</label>
                    <input type="email" class="form-control" id="email"
                           placeholder="Enter your new E-mail"
                           name="email"
                           formControlName="email">
                    <div *ngIf="editUserForm.controls['email'].touched">
                        <div *ngIf="editUserForm.controls['email'].hasError('emailUsed')" class="alert alert-danger">
                            Email account in use
                        </div>
                        <div *ngIf="editUserForm.controls['email'].hasError('incorrectMailFormat')" class="alert alert-danger">
                            Incorrect format of the email account.
                        </div>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="fullName" class="control-label">New name</label>
                    <input type="text" class="form-control" id="fullName"
                           placeholder="Enter new your name"
                           name="fullName"
                           formControlName="fullName">
                </div>
                
                <button type="submit" (click)="editUserSubmit()" class="btn btn-default"
                        [disabled]="!editUserForm.valid || !editUserForm.touched">
                        Update
                </button>
                <div *ngIf="errorUpdatingUser">
                    <div class="alert alert-danger" role="alert">
                        <span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>
                        <span class="sr-only">Error:</span>
                        Something failed while updating your account.
                     </div>
                </div>
            </form>
        </modal-content>
    </modal>
`;