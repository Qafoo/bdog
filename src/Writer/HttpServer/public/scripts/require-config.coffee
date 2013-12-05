require.config(
  baseUrl: "/scripts"

  paths:
    #Main application directory
    'lib': '../lib'

    # Libraries needed by main application
    'jquery': 'vendor/jqueryify/index'
    'faye': '../faye'
    'q': 'vendor/q/q'

  # Define shims for libraries, which are not fully AMD compatible
  shim:
    'jquery':
      exports: "jQuery"

    'faye':
      exports: "Faye"
);
