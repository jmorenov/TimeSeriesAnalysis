export const UserControlView = `
    <div *ngIf="isUserStatusChecked">
        <div *ngIf="isUserLogged">
            <div class="user-control user-control__username">
                {{user.username}}
            </div>
            <div class="user-control dropdown">
                <img src="content/images/default-user.png" class="user-control__image-profile" alt="" data-toggle="dropdown">
                <ul class="user-control__dropdown-menu dropdown-menu">
                  <li><a routerLink="/analysisapp/profile">My Profile</a></li>
                  <li class="divider"></li>
                  <li><a (click)="logout()">Logout</a></li>
                </ul>
            </div>
        </div>
        <div *ngIf="!isUserLogged" class="user-control">
            <entry-user-modal></entry-user-modal>
            <button class="btn btn-default" (click)="openLoginUserModal()">Log in</button>
            <button class="btn btn-default" (click)="openNewUserModal()">Sign up</button>
        </div>
    </div>
`;