(function (global) {
    System.config({
        map: {
            'src': 'dist/src',
            '@angular/core': 'node_modules/@angular/core/bundles/core.umd.js',
            '@angular/common': 'node_modules/@angular/common/bundles/common.umd.js',
            '@angular/compiler': 'node_modules/@angular/compiler/bundles/compiler.umd.js',
            '@angular/platform-browser': 'node_modules/@angular/platform-browser/bundles/platform-browser.umd.js',
            '@angular/platform-browser-dynamic': 'node_modules/@angular/platform-browser-dynamic/bundles/platform-browser-dynamic.umd.js',
            '@angular/http': 'node_modules/@angular/http/bundles/http.umd.js',
            '@angular/forms': 'node_modules/@angular/forms/bundles/forms.umd.js',
            '@angular/router': 'node_modules/@angular/router/bundles/router.umd.js',
            '@angular/upgrade': 'node_modules/@angular/upgrade/bundles/upgrade.umd.js',
            'rxjs': 'node_modules/rxjs',
            'angular2-highcharts': 'node_modules/angular2-highcharts',
            'highcharts': 'node_modules/highcharts',
            'jquery': 'node_modules/jquery/dist/jquery.min.js',
            'bootstrap-sass': 'node_modules/bootstrap-sass/assets/javascripts/bootstrap.min.js',
            'reflect-metadata': 'node_modules/reflect-metadata',
            'zone.js/dist/zone': 'node_modules/zone.js/dist/zone.min.js',
            'ngx-modal': 'node_modules/ngx-modal'
        },
        packages: {
            src: { main: 'Main.js', defaultExtension: 'js'},
            rxjs: {defaultExtension: 'js'},
            'highcharts': {main: './highcharts.js', defaultExtension: 'js'},
            'angular2-highcharts': {main: 'index', defaultExtension: 'js'},
            'reflect-metadata': {main: 'Reflect', defaultExtension: 'js'},
            'ngx-modal': {main: 'index.js', defaultExtension: 'js'}
        }
    })
})(this);