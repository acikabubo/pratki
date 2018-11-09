from flask_assets import Bundle

bundles = {

    'js': Bundle(
        'js/loader.js',
        'js/cache_timer.js',
        'js/index.js',
        'js/info.js',
        'js/profile.js',
        output='gen/main.js'),

    'css': Bundle(
        'css/loader.css',
        'css/base.css',
        'css/index.css',
        'css/info.css',
        'css/package.css',
        'css/android.css',
        'css/profile.css',
        output='gen/main.css'),

    'img': Bundle(
        'img/favicon.ico')

}
