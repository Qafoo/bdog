module.exports = (grunt) ->
  grunt.initConfig(
    config:
      paths:
        "build": "dist"
        "src": "src"
        "bin": "bin"
        "public": "Writer/HttpServer/public"
        "node_modules": "node_modules"

    coffee:
      src:
        expand: true
        cwd: "<%= config.paths.src %>/"
        src: ["**/*.coffee", "!<%= config.paths.public %>/scripts/vendor/**/*"]
        dest: "<%= config.paths.build %>/<%= config.paths.src %>/"
        ext: ".js"
      bin:
        expand: true
        cwd: "<%= config.paths.bin %>"
        src: ["**/*.coffee"]
        dest: "<%= config.paths.build %>/<%= config.paths.bin %>/"
        ext: ".js"

    sass:
      src:
        expand: true
        cwd: "<%= config.paths.src %>/"
        src: ["**/*.scss", "**/_*.scss", "!<%= config.paths.public %>/scripts/vendor/**/*"]
        dest: "<%= config.paths.build %>/<%= config.paths.src %>/"
        ext: ".css"

    copy:
      'httpserverwriter-public':
        files: [
          expand: true
          cwd: "src/<%= config.paths.public %>"
          src: [
            "scripts/vendor/**/*"
            "index.html"
          ]
          dest: "<%= config.paths.build %>/<%= config.paths.src %>/<%= config.paths.public %>/"
        ]
      'httpserverwriter-vendor-npm':
        files: [
          expand: true
          cwd: "<%= config.paths.node_modules %>"
          src: [
            "bower-jquery/bower_components/jquery/jquery.js"
            "q/q.js"
            "requirejs/require.js"
            "ansi-to-html/lib/ansi_to_html.js"
          ]
          dest: "<%= config.paths.build %>/<%= config.paths.src %>/<%= config.paths.public %>/scripts/vendor"
        ]
      'httpserverwriter-vendor':
        files: [
          expand: true
          cwd: "<%= config.paths.src %>/<%= config.paths.public %>/scripts/vendor"
          src: [
            "prettyprint.js/prettyprint.js"
          ]
          dest: "<%= config.paths.build %>/<%= config.paths.src %>/<%= config.paths.public %>/scripts/vendor"
        ]

    concat:
      'bdog-bin-shebang':
        options:
          banner: "#!/usr/bin/env node\n"
        src: "<%= config.paths.build %>/<%= config.paths.bin %>/bdog.js"
        dest: "<%= config.paths.build %>/<%= config.paths.bin %>/bdog.js"
      'ansi-to-html-amd-wrapper':
        options:
          banner: 'define(["require", "exports", "module"], function(require, exports, module) {\n',
          footer: '\n});'
        src: "<%= config.paths.build %>/<%= config.paths.src %>/<%= config.paths.public %>/scripts/vendor/ansi-to-html/lib/ansi_to_html.js"
        dest: "<%= config.paths.build %>/<%= config.paths.src %>/<%= config.paths.public %>/scripts/vendor/ansi-to-html/lib/ansi_to_html.js"

    watch:
      options:
        atBegin: true
      build:
        files: [
          "<%= config.paths.src %>/**/*.coffee",
          "<%= config.paths.src %>/<%= config.paths.public %>/**/*",
          "!<%= config.paths.src %>/<%= config.paths.public %>/scripts/vendor/**/*"
        ]
        options:
          spawn: false
        tasks: ["build"]
  );

  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-sass"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-concat"
  grunt.loadNpmTasks "grunt-contrib-watch"

  grunt.registerTask 'build', [
    "coffee",
    "sass",
    "concat:bdog-bin-shebang",
    "copy:httpserverwriter-public",
    "copy:httpserverwriter-vendor",
    "copy:httpserverwriter-vendor-npm",
    "concat:ansi-to-html-amd-wrapper"
  ]

  grunt.registerTask 'default', ["build"]
