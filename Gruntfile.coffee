module.exports = (grunt) ->
  grunt.initConfig(
    exec:
      'npm-install':
        command: "npm install"
        stderr: true
        stdout: true

      'httpserver-bower-install':
        'command': 'bower install'
        'cwd': 'src/Writer/HttpServer'
        'stderr': true
        'stdout': true

    coffee:
      src:
        expand: true
        cwd: "src/"
        src: ["**/*.coffee", "!Writer/HttpServer/public/scripts/vendor/**/*"]
        dest: "build/src/"
        ext: ".js"
      bin:
        expand: true
        cwd: "bin/"
        src: ["**/*.coffee"]
        dest: "build/bin/"
        ext: ".js"

    copy:
      'httpserverwriter-public':
        files: [
          expand: true
          cwd: "src/Writer/HttpServer/public/"
          src: [
            "scripts/vendor/**/*"
            "index.html"
          ]
          dest: "build/src/Writer/HttpServer/public/"
        ]
  );

  grunt.loadNpmTasks "grunt-exec"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-copy"


  grunt.registerTask 'setup', ["exec:npm-install", "exec:httpserver-bower-install"]

  grunt.registerTask 'build', ["coffee", "copy:httpserverwriter-public"]

  grunt.registerTask 'default', ["setup", "build"]
