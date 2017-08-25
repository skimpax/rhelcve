var gulp = require('gulp');
var bower = require('gulp-bower');
var gulpif = require('gulp-if');
var uglify = require('gulp-uglify');
var uglifycss = require('gulp-uglifycss');
var less = require('gulp-less');
var concat = require('gulp-concat');
var sourcemaps = require('gulp-sourcemaps');
var env = process.env.GULP_ENV;

var config = {
    bowerDir: './bower_components' 
}

// BOWER TASK: trigger bower to resolve assets dependancies and store result in bower_components
gulp.task('bower', function() { 
    return bower()
        .pipe(gulp.dest(config.bowerDir));
});

// TAGS TASK: Just pipe riot.js tags from project folder to public web folder
gulp.task('tags', function() {
    return gulp.src('app/Resources/public/tags/**/*.*')
        .pipe(gulp.dest('web/assets/tags'));
});;

// JAVASCRIPT TASK: write one minified js file out of jquery.js, bootstrap.js and all of my custom js files
gulp.task('js', function () {
    return gulp.src([
        'bower_components/jquery/dist/jquery.min.js',
        'bower_components/jquery.json-view/dist/jquery.json-view.min.js',
        'bower_components/bootstrap/dist/js/bootstrap.min.js',
        'bower_components/bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js',
        'bower_components/bootstrap-toggle/js/bootstrap-toggle.min.js',
        'bower_components/datatables.net/js/jquery.dataTables.min.js',
        'bower_components/datatables.net-bs/js/dataTables.bootstrap.min.js',
        'bower_components/riot/riot+compiler.min.js',
        'bower_components/riot-route/dist/route.min.js',
        'app/Resources/public/js/**/*.js'
        ])
        .pipe(concat('javascripts.js'))
        .pipe(gulpif(env === 'prod', uglify()))
        .pipe(sourcemaps.write('./'))
        .pipe(gulp.dest('web/assets/js'));
});
 
// CSS TASK: write one minified css file out of bootstrap.less and all of my custom less files
gulp.task('css', function () {
    return gulp.src([
        'bower_components/jquery.json-view/dist/jquery.json-view.min.css',
        'bower_components/bootstrap/dist/css/bootstrap.min.css',
        'bower_components/bootstrap-datepicker/dist/css/bootstrap-datepicker3.min.css',
        'bower_components/bootstrap-toggle/css/bootstrap-toggle.min.css',
        'bower_components/datatables.net-bs/css/dataTables.bootstrap.min.css',
        'bower_components/font-awesome/css/font-awesome.min.css',
        'app/Resources/public/less/**/*.less'
        ])
        .pipe(gulpif(/[.]less/, less()))
        .pipe(concat('styles.css'))
        .pipe(gulpif(env === 'prod', uglifycss()))
        .pipe(sourcemaps.write('./'))
        .pipe(gulp.dest('web/assets/css'));
});

// FONT TASK: Just pipe fonts from project folder to public web folder
gulp.task('fonts', function() {
    return gulp.src([
        'bower_components/bootstrap/dist/fonts/glyphicons-halflings-regular.*',
        'bower_components/font-awesome/fonts/*.*'
        ])
        .pipe(gulp.dest('web/assets/fonts'));
});

// IMAGE TASK: Just pipe images from project folder to public web folder
gulp.task('img', function() {
    return gulp.src('app/Resources/public/images/**/*.*')
        .pipe(gulp.dest('web/assets/images'));
});

// LOCALES TASK: Just pipe locales from project folder to public web folder
gulp.task('locales', function() {
    return gulp.src('bower_components/bootstrap-datepicker/dist/locales/bootstrap-datepicker.fr.min.js')
        .pipe(gulp.dest('web/assets/locales'));
});
 

//define executable tasks when running "gulp" command
gulp.task('default', ['bower', 'tags', 'js', 'css', 'fonts', 'img', 'locales']);
