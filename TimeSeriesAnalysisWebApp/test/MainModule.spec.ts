///<reference path="../typings/globals/jasmine/index.d.ts"/>
import { TestBed } from '@angular/core/testing';
import { MainModule } from '../src/MainModule';

describe('MainModule', () => {
    beforeEach(() => {
        TestBed.configureTestingModule(MainModule);
    });

    it('should can compile components', (done) => {
        TestBed.compileComponents().then(function () {
            done();
        }).catch(function (error) {
            expect(error).toBeNull();
            done();
        });
    });
});