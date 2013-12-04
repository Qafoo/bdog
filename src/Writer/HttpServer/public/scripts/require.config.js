require.config({
    baseUrl: "/scripts",

    paths: {
        // Coffeescript loader
        'cs': 'vendor/require-cs/cs',
        'coffee-script': 'vendor/coffee-script/index',

        // Main application directory
        'lib': '../lib',

        // Libraries needed by main application
        'jquery': 'vendor/jquery/jquery.min',
        'faye': '../faye',
        'q': 'vendor/q/q'
    },

    shim: {
        'jquery': {
            exports: "jQuery"
        },
        'faye': {
            exports: "Faye"
        }
    }
});
