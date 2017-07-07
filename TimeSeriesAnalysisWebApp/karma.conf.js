module.exports = function(config) {
    config.set({
        basePath: '',
        frameworks: ['jasmine'],

        plugins: [
            'karma-jasmine',
            'karma-phantomjs-launcher',
            'karma-teamcity-reporter'
        ],

        files: [
            'node_modules/babel-polyfill/dist/polyfill.js',
            'node_modules/es6-shim/es6-shim.js',
            'node_modules/reflect-metadata/Reflect.js',

            'node_modules/zone.js/dist/zone.js',
            'node_modules/zone.js/dist/long-stack-trace-zone.js',
            'node_modules/zone.js/dist/async-test.js',
            'node_modules/zone.js/dist/fake-async-test.js',
            'node_modules/zone.js/dist/sync-test.js',
            'node_modules/zone.js/dist/proxy.js',
            'node_modules/zone.js/dist/jasmine-patch.js',

            { pattern: 'node_modules/rxjs/**/*.js', included: false, watched: false },
            { pattern: 'node_modules/rxjs/**/*.js.map', included: false, watched: false },

            { pattern: 'node_modules/@angular/**/*.js', included: false, watched: false },
            { pattern: 'node_modules/@angular/**/*.js.map', included: false, watched: false },

            { pattern: 'node_modules/angular2-highcharts/**/*.js', included: false, watched: false },
            { pattern: 'node_modules/angular2-highcharts/**/*.js.map', included: false, watched: false },

            { pattern: 'node_modules/ngx-modal/**/*.js', included: false, watched: false },
            { pattern: 'node_modules/ngx-modal/**/*.js.map', included: false, watched: false },

            { pattern: 'node_modules/highcharts/**/*.js', included: false, watched: false },
            { pattern: 'node_modules/highcharts/**/*.js.map', included: false, watched: false },

            'node_modules/systemjs/dist/system.src.js',

            { pattern: 'systemjs.config.js', included: false, watched: false },

            'karma-test-shim.js',

            { pattern: 'dist/src/**/*.js', included: false, watched: true },
            { pattern: 'dist/src/**/*.js.map', included: false, watched: true },
            { pattern: 'src/**/*.ts', included: false, watched: true },

            { pattern: 'dist/test/**/*.js', included: false, watched: true },
            { pattern: 'dist/test/**/*.js.map', included: false, watched: true },
            { pattern: 'test/**/*.ts', included: false, watched: true }
        ],

        reporters: ['progress', 'teamcity'],

        port: 9876,
        colors: true,
        logLevel: config.LOG_INFO,
        autoWatch: true,
        browsers: ['PhantomJS'],
        singleRun: false
    });
};