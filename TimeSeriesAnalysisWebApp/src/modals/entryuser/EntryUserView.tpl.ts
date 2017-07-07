export const EntryUserView = `
    <modal #newUserModal
        title="Create free new user account"
        modalClass="modal-sm entry-user-modal"
        [hideCloseButton]="false"
        [closeOnEscape]="true"
        [closeOnOutsideClick]="true"
        (onOpen)="resetNewUserForm()">
     
        <modal-content>
            <form [formGroup]="newUserForm">
                <div class="form-group required">
                    <label for="username" class="control-label">Username</label>
                    <input type="text" class="form-control" id="username"
                           placeholder="Enter your username"
                           required name="username"
                           formControlName="username">
                    <div *ngIf="newUserForm.controls['username'].touched">
                        <div *ngIf="newUserForm.controls['username'].hasError('usernameUsed')" class="alert alert-danger">
                            Username in use
                        </div>
                        <div *ngIf="newUserForm.controls['username'].hasError('incorrectUsernameFormat')" class="alert alert-danger">
                            Incorrect format of the username
                        </div>
                        <div *ngIf="newUserForm.controls['username'].hasError('required')" class="alert alert-danger">
                            Username is required
                        </div>
                    </div>
                </div>
    
                <div class="form-group required not-border-left-red" formGroupName="passwords">
                    <label for="password" class="control-label">Password</label>
                    <input type="password" class="form-control" id="password"
                           placeholder="Enter your password"
                           required name="password"
                           formControlName="password">
                    <label for="repeatPassword" class="control-label">Repeat password</label>
                    <input type="password" class="form-control" id="repeatPassword"
                           placeholder="Repeat your password"
                           required name="repeatPassword"
                           formControlName="repeatPassword">
                    <div *ngIf="newUserForm.controls.passwords.controls['password'].touched">
                        <div *ngIf="newUserForm.controls.passwords.controls['password'].hasError('passwordFormatIncorrect')" class="alert alert-danger">
                                Password must be longer than 6 characters, contains at least one number, one lowercase and one uppercase letter.
                        </div>
                    </div>
                    <div *ngIf="newUserForm.controls.passwords.controls['password'].touched && newUserForm.controls.passwords.controls['repeatPassword'].touched">
                        <div *ngIf="newUserForm.controls.passwords.hasError('passwordsNotEqual')" class="alert alert-danger">
                            Passwords are not the same
                        </div>
                    </div>
                </div>
                
                <div class="form-group required">
                    <label for="email" class="control-label">Email</label>
                    <input type="email" class="form-control" id="email"
                           placeholder="Enter your E-mail"
                           required name="email"
                           formControlName="email">
                    <div *ngIf="newUserForm.controls['email'].touched">
                        <div *ngIf="newUserForm.controls['email'].hasError('emailUsed')" class="alert alert-danger">
                            Email account in use
                        </div>
                        <div *ngIf="newUserForm.controls['email'].hasError('incorrectMailFormat')" class="alert alert-danger">
                            Incorrect format of the email account.
                        </div>
                        <div *ngIf="newUserForm.controls['email'].hasError('required')" class="alert alert-danger">
                            Email account is required
                        </div>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="fullName" class="control-label">Full name</label>
                    <input type="text" class="form-control" id="fullName"
                           placeholder="Enter your name"
                           name="fullName"
                           formControlName="fullName">
                </div>
                
                <button type="submit" (click)="newUserSubmit()" class="btn btn-default"
                        [disabled]="!newUserForm.valid">
                        Sign up
                </button>
                <div *ngIf="errorCreatingUser">
                    <div class="alert alert-danger" role="alert">
                        <span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>
                        <span class="sr-only">Error:</span>
                        Something failed while creating your account.
                     </div>
                </div>
            </form>
        </modal-content>
     
        <modal-footer>
            Already have an account? <span class="open-modal" (click)="openLoginUserModal()">Log in</span>
        </modal-footer>
    </modal>
    <modal #loginUserModal
        title="Login User"
        modalClass="modal-sm entry-user-modal"
        [hideCloseButton]="false"
        [closeOnEscape]="true"
        [closeOnOutsideClick]="true"
        (onOpen)="resetLoginUserForm()">
     
        <modal-content>
            <form [formGroup]="loginUserForm">
                <div class="form-group required">
                    <label for="id" class="control-label">Username</label>
                    <input type="text" class="form-control" id="username"
                           placeholder="Username"
                           required name="username"
                           formControlName="username">
                    <div *ngIf="loginUserForm.controls['username'].touched">
                        <div *ngIf="loginUserForm.controls['username'].hasError('incorrectUsernameFormat')" class="alert alert-danger">
                            Incorrect format of the username
                        </div>
                        <div *ngIf="loginUserForm.controls['username'].hasError('required')" class="alert alert-danger">
                            Username is required
                        </div>
                    </div>
                </div>
    
                <div class="form-group required">
                    <label for="password" class="control-label">Password</label>
                    <input type="password" class="form-control" id="password"
                           placeholder="Password"
                           required name="password"
                           formControlName="password">
                    <div *ngIf="loginUserForm.controls['password'].touched">
                        <div *ngIf="loginUserForm.controls['password'].hasError('required')" class="alert alert-danger">
                            Password is required
                        </div>
                    </div>
                </div>
                <button type="submit" (click)="loginUserSubmit()" class="btn btn-default"
                        [disabled]="!loginUserForm.valid">
                        Log in
                </button>
                <div *ngIf="errorLoginUser">
                    <div class="alert alert-danger" role="alert">
                        <span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>
                        <span class="sr-only">Error:</span>
                        Username or password incorrect.
                     </div>
                </div>
            </form>
        </modal-content>
     
        <modal-footer>
            Don't have and account? <span class="open-modal" (click)="openNewUserModal()">Create one</span>
        </modal-footer>
    </modal>
`;