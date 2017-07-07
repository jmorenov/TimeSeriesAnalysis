/**
 * Created by jmorenov on 6/09/16.
 */
export class AnalysisResult {
    applyType: Object;
    method: Object;
    to: Object;
    result: Object;
    analysisFinished: boolean;
    runningAnalysis: boolean;
    error: boolean;

    constructor(applyType: Object, method: Object, to: Object) {
        this.applyType = applyType;
        this.method = method;
        this.to = to;
        this.result = undefined;
        this.analysisFinished = false;
        this.runningAnalysis = false;
        this.error = false;
    }

    setResult(result) {
        if (result['error']) {
            this.setError();
        } else {
            this.result = result;
            this.analysisFinished = true;
            this.runningAnalysis = false;
        }
    }

    setError() {
        this.analysisFinished = true;
        this.runningAnalysis = false;
        this.error = true;
    }
}