/**
 * Created by jmorenov on 2/09/16.
 */

import {TimeSeriesComplexityMeasureType} from "./TimeSeriesComplexityMeasureType";
import {TimeSeriesTransformationType} from "./TimeSeriesTransformationType";

export class TimeSeriesComplexityMeasureResult {
    timeSeriesId: string;
    timeSeriesComplexityMeasureType: TimeSeriesComplexityMeasureType;
    timeSeriesTransformationType: TimeSeriesTransformationType;
    complexity: number;
}