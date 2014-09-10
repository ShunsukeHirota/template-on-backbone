module.exports = function (grunt) {
	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),
		meta: {
			version: '0.1.0',
			banner: '/*!  - v<%= meta.version %> - ' +
				'<%= grunt.template.today("yyyy-mm-dd") %>\n' +
				'* Copyright (c) <%= grunt.template.today("yyyy") %> ' +
				'Licensed MIT */'
		},
		path: {
			js: '../htdocs/assets/javascripts/',
			src: 'coffee/',
			libroot: '../htdocs/assets/javascripts/lib/',
			sass: 'sass/',
			css: '../htdocs/assets/stylesheets/',
			image: '../htdocs/assets/images/'
		},
		environment: 'development',

		compass: {
			options: {
				sassDir: '<%= path.sass %>',
				imagesDir:  '<%= path.image %>'
			},
			sample: {
				src: '<%= path.sass %>sample/*.sass',
				dest: '<%= path.css %>sample.css',
				options: {
					sassDir: '<%= path.sass %>sample/',
					cssDir: '<%= path.css %>',
					outputStyle: 'expanded',
					noLineComments: false,
					debugInfo: false,
					relativeAssets: true
				}
			}
		},
		compassMultiple: {
			options: {
				relativeAssets: true,
				config: 'config.rb',
				sassDir: '<%= path.sass %>'
			},
			common: {}
		},
		base: {
			pc: {
				files: [
					'<%= path.src %>app.coffee',
					'<%= path.src %>common/config.coffee',
					'<%= path.src %>util/utility.coffee',
					'<%= path.src %>common/common.coffee',
					'<%= path.src %>view/base.coffee'
				]
			},
			sp: {
				files: [
					'<%= path.src %>app.coffee',
					'<%= path.src %>common/config.coffee',
					'<%= path.src %>common/config-sp.coffee',
					'<%= path.src %>util/utility.coffee',
					'<%= path.src %>common/common.coffee',
					'<%= path.src %>view/base.coffee'
				]
			}
		},
		watch: {
			js: {
				files: '<%= path.src %>/**/*.js',
				tasks: ['js']
			},
			/* multiple */
			multiple: {
				files: '<%= path.sass %>/**/*.scss',
				tasks: ['compassMultiple']
			},
			/* compass */
			compass: {
				files: ['<%= path.sass %>/**/*.scss'],
				tasks: ['compass:default']
			},
			compassSample: {
				files: ['<%= path.sass %>/sample/*.scss'],
				tasks: ['compass:sample']
			},
			/* coffee */
			coffee: {
				files: ['<%= path.src %>/**/*.scss'],
				tasks: ['coffee']
			}
		},
		coffee: {
			index: {
				options: {
					bare: true,
					sourceMap: true
				},
				files: {
					'<%= path.js %>/index-pc.js': ['<%= base.pc.files %>'].concat([
						'<%= path.src %>/main/indexmain.coffee'
					]),
					'<%= path.js %>/index-sp.js': ['<%= base.sp.files %>'].concat([
						'<%= path.src %>/main/indexmain.coffee'
					])
				}
			}
		},
		concat: {
			dist: {
				src: [
					
				],
				dest: '<%= path.js %>index.js'
			},
			samplePC: {
				src: [
					'<%= path.src %>main/indexmain.js'
				],
				dest: '<%= path.js %>pc/sample.js'
			},
			common: {
				src: [
					'<%= path.src %>app.js',
					'<%= path.src %>config/config.js',
					'<%= path.src %>common/utility.js',
					'<%= path.src %>common/common.js',
					'<%= path.src %>view/aloe.js'
				],
				dest: '<%= path.js %>common.js'
			},
			libs: {
				src: [
					//'<%= path.libroot %>greensock/TweenMax.min.js',
					'<%= path.libroot %>backbone/underscore.js',
					'<%= path.libroot %>backbone/backbone.js',
					'<%= path.libroot %>jquery.icheck.min.js',
					'<%= path.libroot %>jquery.backgroundsize.js'
				],
				dest: '<%= path.libroot %>libs.js'
			}
		},
		uglify: {
			dist: {
				src: '<%= concat.dist.dest %>',
				dest: '<%= path.js %>index.min.js'
			},
			samplePC: {
				src: '<%= concat.samplePC.dest %>',
				dest: '<%= path.js %>pc/enquete.min.js'
			},
			libs: {
				src: '<%= concat.libs.dest %>',
				dest: '<%= path.libroot %>libs.min.js'
			}
		},
		//画像最適化
		imagemin: {
			dynamic: {
				files: [{
					expand: true,
					cwd: '<%= path.image %>',
					src: ['**/*.{png,jpg,gif}'],
					dest: '<%= path.image %>'
				}]
			},
			sample: {
				files: [{
					expand: true,
					cwd: '<%= path.image %>pc/sample',
					src: ['**/*.{png,jpg,gif}'],
					dest: '<%= path.image %>pc/sample'
				}]
			}
		},
		growl: {
			notify: true
		}
	});
	
	var cwd = process.cwd();
	process.chdir('../../');
	grunt.loadNpmTasks('grunt-compass-multiple');
	grunt.loadNpmTasks('grunt-contrib-clean');
	grunt.loadNpmTasks('grunt-contrib-watch');
	grunt.loadNpmTasks('grunt-contrib-concat');
	grunt.loadNpmTasks('grunt-contrib-uglify');
	grunt.loadNpmTasks('grunt-contrib-compass');
	grunt.loadNpmTasks('grunt-contrib-imagemin');
	grunt.loadNpmTasks('grunt-contrib-coffee');
	process.chdir(cwd);
	//grunt.registerTask('css', ['watch:index']);
};