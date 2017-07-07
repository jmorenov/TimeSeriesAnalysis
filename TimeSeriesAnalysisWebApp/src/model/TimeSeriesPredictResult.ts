import {TimeSeriesData} from "./TimeSeriesData";
import {TimeSeriesPredictMethod} from "./TimeSeriesPredictMethod";
import {TimeSeriesTransformationType} from "./TimeSeriesTransformationType";

export class TimeSeriesPredictResult {
    timeSeriesId: string;
    data: TimeSeriesData;
    timeSeriesPredictMethod: TimeSeriesPredictMethod;
    timeSeriesTransformationType: TimeSeriesTransformationType;
}