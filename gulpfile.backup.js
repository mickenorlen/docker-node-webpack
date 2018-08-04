var gulp       = require('gulp');
var nodemon    = require('gulp-nodemon');
var sass       = require('gulp-sass');
var livereload = require('gulp-livereload');
var pug = require('gulp-pug');
// var gulp_watch_pug = require('gulp-watch-pug');
// var watch = require('gulp-watch');


// gulp.task('pug', function() {
//   return gulp.src('templates/*.pug')
//       .pipe(pug()) // pipe to pug plugin
//       .pipe(gulp.dest('.public/));
// });

// gulp.task('pug', function() {
//   gulp
//     .src('pug/**/*.pug')
//     .pipe(watch('pug/**/*.pug'))
//     .pipe(gulp_watch_pug('pug/**/*.pug', { delay: 100 }))
//     .pipe(pug())
//     .pipe(gulp.dest('./public/index.html'));
// })

gulp.task('develop', function () {
  nodemon({script: './bin/www', ext: 'js pug json', legacyWatch: true });
});

gulp.task('sass', function() {
  gulp
    .src('./public/scss/**/*.scss')
    .pipe(sass())
    .pipe(gulp.dest('./public/stylesheets'))
    .pipe(livereload())
    .on('error', function (err) {
      console.log(err.message);
    })
  ;
});

gulp.watch('./public/scss/**/*.scss', ['sass']);

gulp.task('default', ['develop', 'sass']);
// gulp.task('default', ['develop', 'sass', 'views']);

