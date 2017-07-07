export const ProfilePageView: string = `
    <entry-user-modal></entry-user-modal>
    <edit-user-modal></edit-user-modal>
    <div class="analysis-application-parent-container analysis-application-parent-container-time-series">
        <a class="imgcircle logo-header" routerLink="/analysisapp" routerLinkActive="active" href="#"> <img class="img_scroll" src="content/images/circle.png" alt=""></a>
        <user-control-component></user-control-component>
        <div *ngIf="loadingUser" class="analysis-application-container">
            <loading [isLoading]="loadingUser"></loading>
        </div>
        <div *ngIf="errorLoadingUser" class="analysis-application-container">
            <div class="alert alert-danger">
                <strong>Error!</strong> Something failed while loading the user page.
            </div>
        </div>
        <div *ngIf="unauthorizedUser" class="analysis-application-container">
            <div class="alert alert-danger">
                <strong>Error!</strong> User without permissions.
            </div>
        </div>
        <div *ngIf="!loadingUser && !errorLoadingUser && !unauthorizedUser"
         class="analysis-application-container analysis-application-container-time-series">
            <div class="profile-header">
                <img src="content/images/user-profile-image.png" class="profile-user-image" alt="">
                <div class="profile-field"><h2>{{user.username}}</h2></div>
                <div class="profile-field">{{user.email}}</div>
                <div class="profile-field">{{user.name}}</div>
            </div>
            <div class="edit-profile" (click)="editUserModal.open()">
                <i class="fa fa-wrench fa-2x" aria-hidden="true"></i>
                Edit profile
            </div>
            <h3 class="profile-timeseries-title">My time series</h3>
            <div *ngIf="!loadingTimeSeries && !errorLoadingTimeSeries">
                <loading [isLoading]="loadingTimeSeries"></loading>
                <table class="table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Values</th>
                            <th>Variables</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody *ngIf="timeSeriesList && timeSeriesList.length">
                        <tr *ngFor="let timeSeries of timeSeriesList"
                            class="select-time-series"
                            routerLink="/analysisapp/timeseries/{{timeSeries.id}}"
                            routerLinkActive="active">
                            <td>{{timeSeries.id}}</td>
                            <td>{{timeSeries.numberOfValues}}</td>
                            <td>{{timeSeries.numberOfVars}}</td>
                            <td *ngIf="timeSeries.public === '1'">Public</td>
                            <td *ngIf="timeSeries.public === '0'">Private</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div *ngIf="!loadingTimeSeries && (!timeSeriesList || !timeSeriesList.length)" class="alert alert-info">
                <strong>No time series founds.</strong>
            </div>
            <div *ngIf="errorLoading" class="alert alert-danger">
                <strong>Error!</strong> Something failed while loading the list of time series.
            </div>
         </div>
    </div>
`;