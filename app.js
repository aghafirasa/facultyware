require('dotenv').config(); 

const express = require('express');
const session = require('express-session');
const app = express();
const apiRouter = require('./routes/api');

app.set('view engine', 'ejs');
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(express.static('public'));

app.use(session({
  secret: process.env.SESSION_SECRET || 'fallback-rahasia', 
  resave: false,
  saveUninitialized: true,
  cookie: { secure: false }
}));

app.get('/', (req, res) => res.redirect('/auth/login'));

app.use('/auth', require('./routes/auth'));
app.use('/potential-partners', require('./routes/potentialPartner'));
app.use('/follow-up', require('./routes/followUp'));
app.use('/mou', require('./routes/mou'));
app.use('/api', require('./routes/api'));
app.use('/export', require('./routes/export'));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Server berjalan aman di http://localhost:${PORT}`);
});