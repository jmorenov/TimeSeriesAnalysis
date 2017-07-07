/**
 * Created by jmorenov on 10/08/16.
 */
import { Component, Input } from '@angular/core';
import { LoadingView } from './LoadingView.tpl';

@Component({
    selector: 'loading',
    template: LoadingView
})
export class LoadingComponent {
    @Input() isLoading : boolean;
}

