/**
 * Created by jmorenov on 1/09/16.
 */

import {TimeSeriesTransformationType} from "./TimeSeriesTransformationType";

export class TimeSeriesClassification {
    timeSeriesId: string;
    timeSeriesTransformationType: TimeSeriesTransformationType;
    classification: string;
    method: number;
}