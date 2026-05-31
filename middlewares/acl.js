const db = require("../lib/db");

/**
 * ACL Middleware — cek apakah user memiliki permission yang diperlukan.
 *
 * @param {string|string[]} requiredPermissions
 *   Satu permission string atau array (user cukup punya salah satu).
 *
 * Database tables yang dibutuhkan:
 *   roles, permissions, role_has_permissions, user_has_roles
 */
const checkPermission = (requiredPermissions) => {
  return async (req, res, next) => {
    // Belum login → redirect ke login
    if (!req.session.userId) {
      // Kalau request API (Accept: application/json atau path /api), kirim JSON
      if (req.path.includes('/api') || req.headers.accept?.includes('application/json')) {
        return res.status(401).json({ success: false, message: "Unauthorized: silakan login terlebih dahulu." });
      }
      return res.redirect("/login");
    }

    const permissionsArray = Array.isArray(requiredPermissions)
      ? requiredPermissions
      : [requiredPermissions];

    try {
      const query = `
        SELECT DISTINCT p.name
        FROM permissions p
        JOIN role_has_permissions rhp ON p.id = rhp.permission_id
        JOIN user_has_roles uhr ON rhp.role_id = uhr.role_id
        WHERE uhr.user_id = ? AND p.name IN (?)
      `;

      const [rows] = await db.query(query, [req.session.userId, permissionsArray]);

      if (rows.length > 0) {
        return next();
      }

      // Tidak punya izin
      if (req.path.includes('/api') || req.headers.accept?.includes('application/json')) {
        return res.status(403).json({
          success : false,
          message : "Forbidden: Anda tidak memiliki izin untuk mengakses resource ini.",
        });
      }

      // Web page → render halaman 403
      return res.status(403).render("error", {
        message : "Akses Ditolak",
        error   : {
          status : 403,
          stack  : "Anda tidak memiliki izin untuk mengakses halaman ini.",
        },
      });
    } catch (err) {
      console.error('[ACL] Error:', err);
      next(err);
    }
  };
};

module.exports = { checkPermission };
