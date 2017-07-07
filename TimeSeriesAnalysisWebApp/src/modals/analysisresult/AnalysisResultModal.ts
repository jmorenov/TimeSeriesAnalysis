/**
 * Created by jmorenov on 8/09/16.
 */
import { Component, Input, OnInit } from '@angular/core';
import { AnalysisResult } from "../../model/AnalysisResult";
import { AnalysisResultView } from './AnalysisResultView.tpl';

@Component({
    selector: 'analysis-result-modal',
    template: AnalysisResultView
})

export class AnalysisResultModal implements OnInit {
    @Input() analysisResult : AnalysisResult;
    randomId: number;
    options = undefined;

    constructor(private window: Window) {
        this.randomId = Math.floor((Math.random() * 10000000) + 1);
    }

    ngOnInit() {

    }

    viewResult() {
        if ((this.analysisResult.applyType['id'] === 'prediction'
            || this.analysisResult.applyType['id'] === 'transformation')) {
            this.initChart();
        }
    }

    initChart() {
        if (!!this.analysisResult.result['data']['values']['forecastResult']) {
            var data = this.analysisResult.result['data']['values']['forecastResult'];
        } else {
            var data = this.analysisResult.result['data']['values']['transformation'];
        }

        this.analysisResult.result['data']['values'] = [];
        for (var i=0; i<data.length; i++) {
            this.analysisResult.result['data']['values'][i] = data[i][0] === undefined ? +data[i] : +data[i][0];
        }

        this.options = {
            series: [{
                data: this.analysisResult.result['data']['values'],
            }],
            chart: {
                width: this.window.innerWidth - 50
            },
            title: {
                text: ''
            },
        };
    }
}