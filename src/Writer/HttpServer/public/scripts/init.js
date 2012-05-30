require(
    {
        paths: {
            'lib': '../lib',
            'faye': '../faye',
            'jquery': 'jquery-1.7.2.min',
            'q': 'q.min.js'
        }
    },
    [
        'faye',
        'jquery',
        'cs!lib/main'
    ]
);
