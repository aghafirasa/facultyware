require('dotenv').config();
const express = require('express');
const path = require('path');
const cookieParser = require('cookie-parser');
const logger = require('morgan');
const session = require('express-session');
const MySQLStore = require('express-mysql-session')(session);

const indexRouter = require('./routes/index');
const usersRouter = require('./routes/users');
const potentialPartnersRouter = require('./routes/potentialPartners'); // Agha
const potentialPartnerRouterFriend = require('./routes/potentialPartner'); // Hubbil
const authRouter = require('./routes/auth');
const followUpRouter = require('./routes/followUp');
const mouRouter = require('./routes/mou');
const apiRouter = require('./routes/api');
const exportRouter = require('./routes/export');

const { notFoundHandler, errorHandler } = require('./middlewares/error');

const app = express();

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
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

app.use(session({
  key: 'fw_session',
  secret: process.env.SESSION_SECRET || 'facultyware-secret-2026',
  store: sessionStore,
  resave: false,
  saveUninitialized: false,
  cookie: { maxAge: 1000 * 60 * 60 * 24 }, // 1 day
}));

// Flash messages middleware - expose to all views
app.use((req, res, next) => {
  res.locals.messages = req.session.flash || {};
  // Standardize req.session.user for views that check it
  if (req.session.userId && !req.session.user) {
    req.session.user = { id: req.session.userId, name: req.session.username, role: 'admin' };
  }
  res.locals.user = req.session.user || null;
  next();
});

// Routes
app.use('/', indexRouter);
app.use('/users', usersRouter);
app.use('/potential-partners', potentialPartnersRouter); // Agha's CRUD + PDF/Excel Export
app.use('/potential-partner', potentialPartnerRouterFriend); // Hubbil's partner CRUD
app.use('/auth', authRouter);
app.use('/follow-up', followUpRouter);
app.use('/mou', mouRouter);
app.use('/api', apiRouter);
app.use('/export', exportRouter);

// 404 handler
app.use(notFoundHandler);

// Error handler
app.use(errorHandler);

module.exports = app;
