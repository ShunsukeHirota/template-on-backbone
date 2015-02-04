var gulp = require('gulp');
var del = require('del');
var $ = require('gulp-load-plugins')({
	pattern: ['gulp-*', 'gulp.*'],
	replaceString: /\bgulp[\-.]/
});

var path = {
	bower: '../bower_components/',
	js: '../htdocs/assets/javascripts/',
	coffee: 'coffee/',
	libroot: '../htdocs/assets/javascripts/lib/',
	scss: 'sass/',
	css: '../htdocs/assets/stylesheets/',
	image: '../htdocs/assets/images/',
	root: '../htdocs/'
};

var coffeeBase = {
	pc: {
		files: [
			path.coffee + 'app.coffee',
			path.coffee + 'common/config.coffee',
			path.coffee + 'util/utility.coffee',
			path.coffee + 'common/common.coffee'
		]
	}
}

/**----------------------------------------
 * Scss
 ----------------------------------------*/
gulp.task('cssIndex', function () {
	gulp.src(path.scss + 'index/*.scss')
		.pipe($.plumber({errorHandler: $.notify.onError("<%= error.message %>")}))
		.pipe($.compass({
			config_file: "config.rb",
			css: path.css,
			sass: path.scss
		}))
		.pipe($.pleeease({
			fallbacks: {
				autoprefixer: ['last 2 version', 'safari 5', 'ie 8', 'ie 9', 'opera 12.1', 'ios 6', 'android 4']
			},
			optimizers: {
				minifier: false //　圧縮の有無
			}
		}))
		.pipe(gulp.dest(path.css + 'index/'));
});


gulp.task('libs', function () {
	gulp.src([path.bower + 'jquery/dist/jquery.min.js',
		path.libroot + 'jquery.easing.1.3.min.js',
		path.libroot + 'greensock/TweenMax.min.js',
		path.libroot + 'backbone/underscore.js',
		path.libroot + 'backbone/backbone.min.js',
		path.libroot + 'jquery.backgroundsize.js'])
		.pipe($.plumber({errorHandler: $.notify.onError('<%= error.message %>')}))
		.pipe($.concat('libs.js'))
		.pipe(gulp.dest(path.libroot));
});

/**----------------------------------------
 * Coffee
 ----------------------------------------*/
gulp.task('coffeeIndex', function () {
	gulp.src(coffeeBase.pc.files.concat([
			path.coffee + 'view/report.coffee',
			path.coffee + 'main/indexmain.coffee'
		]))
		.pipe($.coffee({
			bare: true
		}))
		.pipe($.concat('index.js'))
		//.pipe($.uglify('index.js'))
		.pipe($.plumber({errorHandler: $.notify.onError("<%= error.message %>")}))
		.pipe(gulp.dest(path.js))
});

/**----------------------------------------
 * Watch
 ----------------------------------------*/
// 各ファイルの監視
gulp.task('watch', function () {
	gulp.watch([path.scss + 'index/*.scss'], ['cssIndex']);
	gulp.watch([path.coffee + '*/*.coffee'], ['coffeeIndex']);
});

/**
 * watch scss
 */
//scssのみ監視
gulp.task('watch_scss', function () {
	gulp.watch([path.scss + 'index/*.scss'], ['cssIndex']);
});

/**
 * watch coffee
 */
//coffeeのみ監視
gulp.task('watch_coffee', function () {
	gulp.watch([path.coffee + 'index/*.coffee'], ['coffeeIndex']);
});


//Webサーバー
/* gulp.task('webserver', function() {
  gulp.src(path.root) //Webサーバーで表示するサイトのルートディレクトリを指定
    .pipe($.webserver({
      livereload: true, //ライブリロードを有効に
      port: 8080
      //directoryListing: true //ディレクトリ一覧を表示するか。オプションもあり
    }));
});
*/
gulp.task('html', function () {
	gulp.src('./dist/**/*.html').pipe($.connect.reload());
});

// dist　（納品用） ///////////////////////////////////////////
// distフォルダ内（変更点のないファイル（favicon.etc）以外)を一旦全て削除が終了してから、その下の各ストリームを順番に開始
//　最後にspritesフォルダの削除
gulp.task('clean', del.bind(null, ['./dist/**']));
gulp.task('build', ['clean'], function () {
});
gulp.task('spritesClean', ['build'], function (cb) {
	setTimeout(function () {
		del(['./dist/f/common/images/sprites'], cb);
	}, 1000);// spritesの量に応じて増減させてください
});


//　defaultで行うストリーム
gulp.task('default', ['common_scss', 'f_scss', 'ssl_scss', 'common_js', 'f_js', 'ssl_js', 'watch']);

//　dist （納品用ビルド） で行うストリーム
gulp.task('dist', ['spritesClean']);
