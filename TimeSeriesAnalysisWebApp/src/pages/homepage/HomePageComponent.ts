import {Component, ViewChild} from '@angular/core';
import { HomePageView } from './HomePageView.tpl';
import { Modal } from 'ngx-modal';

@Component({
    template: HomePageView
})
export class HomePageComponent {
    @ViewChild('rProjectModal') rProjectModal: Modal;
    @ViewChild('complexityMeasuresModal') complexityMeasuresModal: Modal;
    @ViewChild('timeSeriesDatabaseModal') timeSeriesDatabaseModal: Modal;

    constructor() {
    }

    openRProjectModal() {
        this.rProjectModal.open();
    }

    openComplexityMeasureModal() {
        this.complexityMeasuresModal.open();
    }

    openTimeSeriesDatabaseModal() {
        this.timeSeriesDatabaseModal.open();
    }
}