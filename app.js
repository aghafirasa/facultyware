require('dotenv').config();
var express = require('express');
var path    = require('path');
var cookieParser = require('cookie-parser');
var logger  = require('morgan');
var session = require('express-session');
var MySQLStore = require('express-mysql-session')(session);

var indexRouter              = require('./routes/index');
var usersRouter              = require('./routes/users');
var potentialPartnersRouter  = require('./routes/potentialPartners');

const { notFoundHandler, errorHandler } = require('./middlewares/error');

var app = express();

// View engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

// Session configuration
const sessionStore = new MySQLStore({
  host     : process.env.DB_HOST,
  user     : process.env.DB_USER,
  password : process.env.DB_PASSWORD,
  database : process.env.DB_NAME,
});

app.use(session({
  key              : 'fw_session',
  secret           : process.env.SESSION_SECRET || 'facultyware-secret-2026',
  store            : sessionStore,
  resave           : false,
  saveUninitialized: false,
  cookie           : { maxAge: 1000 * 60 * 60 * 24 }, // 1 hari
}));

// Flash messages middleware — expose ke semua view
app.use((req, res, next) => {
  res.locals.messages = req.session.flash || {};
  next();
});

// Routes
app.use('/', indexRouter);
app.use('/users', usersRouter);
app.use('/potential-partners', potentialPartnersRouter);

// 404 handler
app.use(notFoundHandler);

// Error handler
app.use(errorHandler);

module.exports = app;
