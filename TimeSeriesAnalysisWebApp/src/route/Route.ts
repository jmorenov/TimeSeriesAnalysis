/**
 * Created by jmorenov on 23/08/16.
 */
import { Routes, RouterModule } from '@angular/router';
import { HomePageComponent } from '../pages/homepage/HomePageComponent';
import { AnalysisPageComponent } from '../pages/analysispage/AnalysisPageComponent';
import { TimeSeriesPageComponent } from '../pages/timeseriespage/TimeSeriesPageComponent';
import { ProfilePageComponent } from "../pages/profilepage/ProfilePageComponent";

const appRoutes: Routes = [
    { path: '', component: HomePageComponent },
    { path: 'analysisapp', component: AnalysisPageComponent },
    { path: 'analysisapp/timeseries/:id', component: TimeSeriesPageComponent },
    { path: 'analysisapp/profile', component: ProfilePageComponent },
    { path: '**', component: HomePageComponent }
];

export const AppRoutingProviders: any[] = [

];

export const Routing = RouterModule.forRoot(appRoutes);