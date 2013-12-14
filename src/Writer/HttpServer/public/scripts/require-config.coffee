require.config(
  baseUrl: "/scripts"

  paths:
    #Main application directory
    'lib': '../lib'

    # Libraries needed by main application
    'jquery': 'vendor/bower-jquery/bower_components/jquery/jquery'
    'faye': '../faye'
    'q': 'vendor/q/q'
    'ansi-to-html': 'vendor/ansi-to-html/lib/ansi_to_html'
    'prettyPrint': 'vendor/prettyprint.js/prettyprint'

  # Define shims for libraries, which are not fully AMD compatible
  shim:
    'jquery':
      exports: "jQuery"

    'faye':
      exports: "Faye"

    'prettyPrint':
      exports: "prettyPrint"
);
