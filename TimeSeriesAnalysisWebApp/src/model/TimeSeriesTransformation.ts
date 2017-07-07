import {TimeSeriesData} from "./TimeSeriesData";
import {TimeSeriesTransformationType} from "./TimeSeriesTransformationType";

export class TimeSeriesTransformation {
    timeSeriesId: string;
    data: TimeSeriesData;
    timeSeriesTransformationType: TimeSeriesTransformationType;
}