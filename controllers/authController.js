const db = require('../config/db');
const bcrypt = require('bcryptjs');

const showLogin = (req, res) => {
  res.render('auth/login', { error: null });
};

const login = (req, res) => {
  const { email, password } = req.body;
  db.query('SELECT * FROM users WHERE email = ?', [email], async (err, results) => {
    if (err) {
      console.error("Login DB Error:", err);
      return res.status(500).send("Terjadi kesalahan internal pada server database.");
    }
    
    if (results.length === 0) {
      return res.render('auth/login', { error: 'Email tidak ditemukan' });
    }
    
    const user = results[0];
    const match = await bcrypt.compare(password, user.password);
    if (!match) return res.render('auth/login', { error: 'Password salah' });
    
    req.session.user = { id: user.id, name: user.name, role: user.role };
    res.redirect('/potential-partners');
  });
};

const logout = (req, res) => {
  req.session.destroy(() => res.redirect('/auth/login'));
};

module.exports = { showLogin, login, logout };