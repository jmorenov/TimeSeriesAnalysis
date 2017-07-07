import { NgModule }      from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { MainPageComponent }  from './pages/mainpage/MainPageComponent';
import { Routing, AppRoutingProviders } from './route/Route';
import { HttpModule }    from '@angular/http';
import { TimeSeriesListService } from './services/TimeSeriesListService';
import { TimeSeriesDataService } from './services/TimeSeriesDataService';
import { TimeSeriesAnalysisService } from './services/TimeSeriesAnalysisService';
import { TimeSeriesUploaderService } from './services/TimeSeriesUploaderService';
import { UserService } from './services/UserService';
import { HomePageComponent } from './pages/homepage/HomePageComponent';
import { AnalysisPageComponent } from './pages/analysispage/AnalysisPageComponent';
import { TimeSeriesPageComponent } from './pages/timeseriespage/TimeSeriesPageComponent';
import { ReactiveFormsModule } from '@angular/forms';
import { LocationStrategy, HashLocationStrategy} from '@angular/common';
import { FormsModule } from '@angular/forms';
import { PageScroll } from './directives/ng2-page-scroll/ng2-page-scroll.directive';
import { ChartModule } from 'angular2-highcharts';
import { UploadTimeSeriesModal } from './modals/uploadtimeseries/UploadTimeSeriesModal';
import { LoadingComponent } from './components/loading/LoadingComponent';
import { HeaderComponent } from './components/header/HeaderComponent';
import { NavBarComponent } from './components/navbar/NavBarComponent';
import { FooterComponent } from './components/footer/FooterComponent';
import { AnalysisResultModal } from './modals/analysisresult/AnalysisResultModal';
import { ExploreTimeSeriesComponent} from './components/exploretimeseries/ExploreTimeSeriesComponent';
import { UploadTimeSeriesComponent} from './components/uploadtimeseries/UploadTimeSeriesComponent';
import { ModalModule } from 'ngx-modal';
import { UserAuthenticationService } from './services/UserAuthentificationService';
import { EntryUserModal } from './modals/entryuser/EntryUserModal';
import { UserValidatorService } from './services/UserValidatorService';
import { UserControlComponent} from './components/usercontrol/UserControlComponent';
import { TimeSeriesValidatorService} from './services/TimeSeriesValidatorService';
import { ProfilePageComponent } from './pages/profilepage/ProfilePageComponent';
import { EditUserModal } from './modals/edituser/EditUserModal';

@NgModule({
    imports: [
        BrowserModule,
        Routing,
        HttpModule,
        ReactiveFormsModule,
        FormsModule,
        ChartModule.forRoot(require('highcharts')),
        ModalModule
    ],
    declarations: [
        MainPageComponent,
        HomePageComponent,
        AnalysisPageComponent,
        TimeSeriesPageComponent,
        PageScroll,
        UploadTimeSeriesModal,
        LoadingComponent,
        LoadingComponent,
        HeaderComponent,
        NavBarComponent,
        FooterComponent,
        AnalysisResultModal,
        ExploreTimeSeriesComponent,
        UploadTimeSeriesComponent,
        EntryUserModal,
        UserControlComponent,
        ProfilePageComponent,
        EditUserModal
    ],
    providers: [
        AppRoutingProviders,
        TimeSeriesListService,
        TimeSeriesDataService,
        TimeSeriesAnalysisService,
        TimeSeriesUploaderService,
        UserService,
        UserAuthenticationService,
        UserValidatorService,
        TimeSeriesValidatorService,
        {provide: Window, useValue: window},
        {provide: LocationStrategy, useClass: HashLocationStrategy}
    ],
    bootstrap: [ MainPageComponent ]
})
export class MainModule { }