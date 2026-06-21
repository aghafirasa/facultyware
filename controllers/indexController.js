const bcrypt = require("bcryptjs");
const db = require("../lib/db");

const index = (req, res) => {
  if (req.session.userId) return res.redirect("/home");
  res.redirect("/login");
};

const home = async (req, res, next) => {
  try {
    // 1. Total Partners
    const [totalRows] = await db.query('SELECT COUNT(*) AS total FROM potential_partners');
    const totalPartners = totalRows[0]?.total || 0;

    // 2. Active Partners
    const [activeRows] = await db.query("SELECT COUNT(*) AS total FROM potential_partners WHERE status = 'active'");
    const activePartners = activeRows[0]?.total || 0;

    // 3. Partners by Type
    const [typeRows] = await db.query(`
      SELECT partnership_type, COUNT(*) AS count 
      FROM potential_partners 
      GROUP BY partnership_type
    `);
    
    const statsByType = {
      Academic: 0,
      Industry: 0,
      Research: 0,
      Internship: 0,
      Other: 0
    };
    typeRows.forEach(row => {
      if (row.partnership_type && statsByType[row.partnership_type] !== undefined) {
        statsByType[row.partnership_type] = row.count;
      }
    });

    // 4. Recent Partners (last 3)
    const [recentPartners] = await db.query('SELECT * FROM potential_partners ORDER BY created_at DESC LIMIT 3');

    res.render("home", { 
      title: "Dashboard", 
      user: req.session.username || 'Admin',
      stats: {
        total: totalPartners,
        active: activePartners,
        types: statsByType
      },
      recentPartners
    });
  } catch (err) {
    console.error('[Dashboard Error]', err);
    res.render("home", { 
      title: "Dashboard", 
      user: req.session.username || 'Admin',
      stats: {
        total: 0,
        active: 0,
        types: { Academic: 0, Industry: 0, Research: 0, Internship: 0, Other: 0 }
      },
      recentPartners: []
    });
  }
};

const loginPage = (req, res) => {
  if (req.session.userId) return res.redirect("/home");
  res.render("login", { title: "Login", error: null });
};

const login = async (req, res, next) => {
  const { username, password } = req.body;

  if (!username || !password) {
    return res.render("login", {
      title: "Login",
      error: "Username dan password wajib diisi.",
    });
  }

  try {
    // Coba login dengan username ATAU email
    const [rows] = await db.query(
      "SELECT * FROM users WHERE username = ? OR email = ? LIMIT 1",
      [username, username]
    );

    if (rows.length === 0) {
      return res.render("login", {
        title: "Login",
        error: "Username atau password salah.",
      });
    }

    const user = rows[0];
    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
      return res.render("login", {
        title: "Login",
        error: "Username atau password salah.",
      });
    }

    // Set session
    req.session.userId   = user.id;
    req.session.username = user.username || user.name;
    req.session.user     = { id: user.id, name: user.name || user.username, role: user.role || 'admin' };

    req.session.save((err) => {
      if (err) return next(err);
      res.redirect("/potential-partners");
    });
  } catch (err) {
    next(err);
  }
};

const logout = (req, res, next) => {
  req.session.destroy((err) => {
    if (err) return next(err);
    res.redirect("/login");
  });
};

module.exports = { index, home, loginPage, login, logout };
