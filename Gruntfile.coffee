'use strict'

module.exports = (grunt)->
  require('jit-grunt')(grunt,
    express: 'grunt-express-server'
    mochaTest: 'grunt-mocha-test'
  )

  appConfig =
    app: 'app'

  grunt.initConfig
    #clean:
    #  server: '.tmp'

    coffee:
      compile:
        expand: true
        cwd: 'app'
        src: '**/*.coffee'
        dest: '.tmp'
        ext: '.js'
        options:
          bare: true
          preserve_dirs: true

    # Make sure code styles are up to par and there are no obvious mistakes
    coffeelint:
      options:
        jshintrc: '.coffeelintrc'
      all:
        src: [
          'Gruntfile.coffee'
          "#{appConfig.app}/**/*.coffee"
        ]
      test:
        options:
          jshintrc: 'test/.coffeelintrc'
        src: [
          'test/**/*.coffee'
        ]

    express:
      dev:
        options:
          opts: ['node_modules/coffee-script/bin/coffee']
          script: 'app/app.coffee'

    mochaTest:
      test:
        options:
          reporter: 'mocha-spec-cov-alt'
          require: [
            'coffee-script/register'
            'coverage/blanket'
          ]
        src: [ 'spec/**/*.coffee' ]
      coverage:
        options:
          reporter: 'html-cov'
          quiet: true
          captureFile: 'coverage.html'
          require: 'coffee-script/register'
        src: [ 'spec/**/*.coffee' ]

    watch:
      coffee:
        files: [ 'Gruntfile.coffee', 'app/**/*.coffee' ]
        tasks: [ 'newer:coffeelint:all' ]
      express:
        files: [ 'app/**/*.coffee', 'app/**/*.json' ]
        tasks: 'express:dev'
        options:
          spawn: false


  grunt.registerTask 'serve', [
    #'clean:server'
    'newer:coffeelint'
    'express:dev'
    'watch'
  ]

  grunt.registerTask 'test', [
    'newer:coffeelint'
    'mochaTest'
  ]

  grunt.registerTask 'default', [
    'test'
  ]
