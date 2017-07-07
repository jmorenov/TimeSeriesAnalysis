/**
 * Created by Jmoreno on 30/08/2016.
 */
import { Component, trigger, state, style, animate, transition} from '@angular/core';
import { HeaderView } from './HeaderView.tpl';

@Component({
    selector: 'header-component',
    template: HeaderView,
    animations: [
        trigger('flyInOut', [
            state('in', style({transform: 'translateX(0)'})),
            transition('void => *', [
                style({transform: 'translateX(-100%)'}),
                animate(300)
            ]),
            transition('* => void', [
                animate(300, style({transform: 'translateX(100%)'}))
            ])
        ])
    ]
})
export class HeaderComponent {
}

