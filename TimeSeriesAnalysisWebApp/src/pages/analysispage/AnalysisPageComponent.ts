import {Component, OnInit, ViewChild} from '@angular/core';
import { AnalysisPageView } from './AnalysisPageView.tpl';
import {UserAuthenticationService} from "../../services/UserAuthentificationService";
import {ExploreTimeSeriesComponent} from "../../components/exploretimeseries/ExploreTimeSeriesComponent";

@Component({
    template: AnalysisPageView
})
export class AnalysisPageComponent implements OnInit {
    @ViewChild(ExploreTimeSeriesComponent) exploreTimeSeriesComponent: ExploreTimeSeriesComponent;

    constructor(private userAuthenticationService: UserAuthenticationService) {
    }

    ngOnInit() {
        this.userAuthenticationService.isLogged().then((isLogged) => {
            if (isLogged) {
                this.userAuthenticationService.setLogged();
            } else {
                this.userAuthenticationService.logout();
            }
        });
    }
}