import express from 'express';
import path from 'path';

import routes from './routes/index';

const app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'pug');
app.set('mode', 'hej');
app.use(express.static(path.join(__dirname, 'public')));
app.locals.env = app.settings.env;

app.use('/', routes);

app.listen(3000, () => {
  console.info('Listening');
});


// uncomment after placing your favicon in /public/img
// app.use(favicon(__dirname + '/public/img/favicon.ico'));

// catch 404 and forward to error handler
app.use((req, res, next) => {
  const err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
  app.use((err, req, res) => {
    res.status(err.status || 500);
    res.render('error', {
      message: err.message,
      error: err,
    });
  });
}

// production error handler
// no stacktraces leaked to user
app.use((err, req, res) => {
  res.status(err.status || 500);
  res.render('error', {
    message: err.message,
    error: {},
  });
});
