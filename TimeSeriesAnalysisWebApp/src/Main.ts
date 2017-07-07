/**
 * Created by jmorenov on 29/06/16.
 */
import './Dependencies';
import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';
import { MainModule } from './MainModule';
import { enableProdMode } from '@angular/core';

enableProdMode();
platformBrowserDynamic().bootstrapModule(MainModule);