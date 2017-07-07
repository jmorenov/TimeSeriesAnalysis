/**
 * Created by Jmoreno on 01/09/2016.
 */
import { TimeSeriesData } from './TimeSeriesData';
import {User} from "./User";

export class TimeSeries {
    id: number;
    public: string;
    user: User;
    data: TimeSeriesData;
    description: string;
    referenceUrl: string;
    numberOfValues: number;
    numberOfVars: number;
    timezone: string;
    startDate: Date;
    endDate: Date;
    frequency: number;
    mean: number;
    max: number;
    min: number;
    maxDate: Date;
    minDate: Date;
}