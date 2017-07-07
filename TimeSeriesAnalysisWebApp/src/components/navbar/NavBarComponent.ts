/**
 * Created by jmorenov on 28/08/16.
 */
import {Component, ElementRef, Renderer, ViewChild} from '@angular/core';
import { NavBarView } from './NavBarView.tpl';

@Component({
    selector: 'nav-bar',
    template: NavBarView,
    host: {
        '(window:scroll)': 'onScroll()'
    }
})
export class NavBarComponent {
    @ViewChild('navbarmenu') navbarMenu: ElementRef;

    public navbarOnTop: boolean;

    constructor(private _el: ElementRef, private _renderer: Renderer){
    }

    onScroll(){
        if (document.body.scrollTop > this._el.nativeElement.offsetTop) {
            //this._renderer.setElementStyle(this._el.nativeElement, 'position', 'fixed');
            this.navbarOnTop = true;
        } else {
            this.navbarOnTop = false;
        }

        if (this.navbarMenu) {
            this._renderer.setElementClass(this.navbarMenu.nativeElement, 'in', false);
        }
    }
}

