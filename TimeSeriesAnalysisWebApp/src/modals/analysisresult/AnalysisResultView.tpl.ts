export const AnalysisResultView: string = `
<button *ngIf="analysisResult.analysisFinished && !analysisResult.error"
        data-toggle="modal"
        [attr.data-target]="'#analysisResultModal'+randomId"
        (click)="viewResult()">
    View
</button>

<div *ngIf="analysisResult.analysisFinished && !analysisResult.error" class="modal fade" [attr.id]="'analysisResultModal'+randomId" role="dialog">
    <div class="modal-dialog analysis-result-modal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">{{analysisResult.applyType.id}} result</h4>
            </div>
            <div class="modal-body" *ngIf="analysisResult.analysisFinished">
                <div *ngIf="analysisResult.applyType.id === 'transformation'">
                    <chart [options]="options"></chart>
                    <p><span class="parameter-name">Transformation method: </span>{{analysisResult.method.id}}</p>
                </div>
                <div *ngIf="analysisResult.applyType.id === 'prediction'">
                    <chart [options]="options"></chart>
                    <p><span class="parameter-name">Prediction method: </span>{{analysisResult.method.id}}</p>
                    <p><span class="parameter-name">Apply to: </span>{{analysisResult.to.id}}</p>
                </div>
                <div *ngIf="analysisResult.applyType.id === 'complexitymeasure'">
                    <p><span class="parameter-name">Complexity measure method: </span>{{analysisResult.method.id}}</p>
                    <p><span class="parameter-name">Apply to: </span>{{analysisResult.to.id}}</p>
                    <p><span class="parameter-name">Complexity: </span>{{analysisResult.result['complexity']}}</p>
                </div>
                <div *ngIf="analysisResult.applyType.id === 'classification'">
                    <p><span class="parameter-name">Apply to: </span>{{analysisResult.to.id}}</p>
                    <p><span class="parameter-name">Class: </span>{{analysisResult.result['classification']}}</p>
                    <p><span class="parameter-name">Forecasting Method: </span>{{analysisResult.result['forecastingMethod']}}</p>
                </div>
            </div>
        </div>
    </div>
</div>
`