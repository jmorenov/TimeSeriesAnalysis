Error.stackTraceLimit = 0;
jasmine.DEFAULT_TIMEOUT_INTERVAL = 1000;

__karma__.loaded = function () {
};

function isJsFile(path) {
    return path.slice(-3) == '.js';
}

function isSpecFile(path) {
    return path.slice(-8) == '.spec.js';
}

function isBuiltFile(path) {
    var builtPath = '/base/dist/';
    return isJsFile(path) && (path.substr(0, builtPath.length) == builtPath);
}

var allSpecFiles = Object.keys(window.__karma__.files)
    .filter(isSpecFile)
    .filter(isBuiltFile);

System.config({
    baseURL: 'base',

    map: {
        '@angular/core/testing': 'node_modules/@angular/core/bundles/core-testing.umd.js',
        '@angular/common/testing': 'node_modules/@angular/common/bundles/common-testing.umd.js',
        '@angular/compiler/testing': 'node_modules/@angular/compiler/bundles/compiler-testing.umd.js',
        '@angular/router/testing': 'node_modules/@angular/router/bundles/router-testing.umd.js',
        '@angular/platform-browser/testing': 'node_modules/@angular/platform-browser/bundles/platform-browser-testing.umd.js',
        '@angular/platform-browser-dynamic/testing': 'node_modules/@angular/platform-browser-dynamic/bundles/platform-browser-dynamic-testing.umd.js'
    }
});

System.import('systemjs.config.js')
    .then(initTestBed)
    .then(initTesting);

function initTestBed() {
    return Promise.all([
        System.import('@angular/core/testing'),
        System.import('@angular/platform-browser-dynamic/testing')
    ]).then(function (providers) {
        var coreTesting = providers[0];
        var browserTesting = providers[1];

        coreTesting.TestBed.initTestEnvironment(
            browserTesting.BrowserDynamicTestingModule,
            browserTesting.platformBrowserDynamicTesting());
    });
}

function initTesting() {
    return Promise.all(
        allSpecFiles.map(function (moduleName) {
            return System.import(moduleName);
        })
    ).then(__karma__.start, errorFn);
}

function errorFn(error) {
    console.error(error.message);
    __karma__.error(error);
}