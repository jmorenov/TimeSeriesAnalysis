import { Component, OnInit } from '@angular/core';
import { TimeSeries } from '../../model/TimeSeries';
import { TimeSeriesListService } from '../../services/TimeSeriesListService';
import { ExploreTimeSeriesView } from './ExploreTimeSeriesView.tpl';

@Component({
    selector: 'explore-time-series-component',
    template: ExploreTimeSeriesView
})
export class ExploreTimeSeriesComponent implements OnInit {
    timeSeriesList: TimeSeries[];
    loadingTimeSeries: boolean;
    errorLoading: boolean;

    constructor(private timeSeriesListService: TimeSeriesListService) {
        this.errorLoading = false;

        this.timeSeriesListService.refreshListEvent$.subscribe(refreshTimeSeriesList => this.refreshTimeSeriesListEvent(refreshTimeSeriesList));
    }

    refreshTimeSeriesListEvent(refreshTimeSeriesList) {
        if (refreshTimeSeriesList) {
            this.getTimeSeries();
        }
    }

    ngOnInit() {
        this.loadingTimeSeries = true;
        this.getTimeSeries();
    }

    getTimeSeries(): void {
        this.timeSeriesListService
            .getPublicTimeSeriesList()
            .then((timeSeriesList) => {
                if (timeSeriesList['error']) {
                    this.setErrorLoading();
                } else {
                    this.timeSeriesList = timeSeriesList;
                    this.loadingTimeSeries = false;
                }
            }).catch((error) => {
            this.setErrorLoading();
        });
    }

    setErrorLoading() {
        this.errorLoading = true;
        this.loadingTimeSeries = false;
    }
}