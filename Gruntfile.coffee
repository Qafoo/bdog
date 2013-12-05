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
      'httpserverwriter-vendor':
        files: [
          expand: true
          cwd: "<%= config.paths.node_modules %>"
          src: [
            "jqueryify/index.js"
            "q/q.js"
            "requirejs/require.js"
          ]
          dest: "<%= config.paths.build %>/<%= config.paths.src %>/<%= config.paths.public %>/scripts/vendor"
        ]

    concat:
      'bdog-bin-shebang':
        options:
          banner: "#!/usr/bin/env node\n"
        src: "<%= config.paths.build %>/<%= config.paths.bin %>/bdog.js"
        dest: "<%= config.paths.build %>/<%= config.paths.bin %>/bdog.js"

    watch:
      build:
        files: [
          "<%= config.paths.src %>/**/*.coffee",
          "<%= config.paths.src %>/<%= config.paths.public %>**/*",
          "!<%= config.paths.src %>/<%= config.paths.public %>/scripts/vendor/**/*"
        ]
        options:
          spawn: false
        tasks: ["build"]
  );

  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-concat"
  grunt.loadNpmTasks "grunt-contrib-watch"

  grunt.registerTask 'build', ["coffee", "concat:bdog-bin-shebang", "copy:httpserverwriter-public", "copy:httpserverwriter-vendor"]

  grunt.registerTask 'default', ["build"]
