///<reference path="../../../typings/globals/jasmine/index.d.ts"/>
import { TestBed, ComponentFixture } from '@angular/core/testing';
import { MainPageComponent } from '../../../src/pages/mainpage/MainPageComponent';
import { MainPageView } from '../../../src/pages/mainpage/MainPageView.tpl';
import { RouterTestingModule } from '@angular/router/testing';

describe('pages.mainpage.MainPageComponent', () => {
    let fixture: ComponentFixture<MainPageComponent>;

    beforeEach(() => {
        TestBed.configureTestingModule({
            declarations: [MainPageComponent],
            imports: [
                RouterTestingModule.withRoutes([])
            ]
        });
        fixture = TestBed.createComponent(MainPageComponent);
        fixture.detectChanges();
    });

    it('should be defined the view', () => {
        const debugEl = fixture.debugElement;

        expect(debugEl.nativeElement.innerHTML).toEqual(MainPageView);
    });
});