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
  );

  grunt.loadNpmTasks "grunt-exec"

  grunt.registerTask 'setup', ["exec:npm-install", "exec:httpserver-bower-install"]
  grunt.registerTask 'dependencies', ["setup"]
  grunt.registerTask 'default', ["setup"]
