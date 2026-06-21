-- ============================================================
-- Potential Partner Setup Script
-- Jalankan di database: facultyware
-- ============================================================

USE `facultyware`;

-- -----------------------------------------------------
-- Add username column to users table (if not exists)
-- -----------------------------------------------------
ALTER TABLE `users`
  ADD COLUMN `username` VARCHAR(100) NULL DEFAULT NULL AFTER `name`;

ALTER TABLE `users`
  ADD UNIQUE INDEX `users_username_unique` (`username`);

-- -----------------------------------------------------
-- Table: potential_partners
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `potential_partners` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_name` VARCHAR(255) NOT NULL,
  `contact_person` VARCHAR(255) NULL DEFAULT NULL,
  `email` VARCHAR(255) NULL DEFAULT NULL,
  `phone` VARCHAR(50) NULL DEFAULT NULL,
  `address` TEXT NULL DEFAULT NULL,
  `partnership_type` ENUM('Academic','Industry','Research','Internship','Other') NULL DEFAULT NULL,
  `description` TEXT NULL DEFAULT NULL,
  `status` ENUM('active','inactive') NOT NULL DEFAULT 'active',
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table: roles
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `roles` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `roles_name_unique` (`name`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table: permissions
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `permissions` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `permissions_name_unique` (`name`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table: role_has_permissions
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `role_has_permissions` (
  `role_id` BIGINT UNSIGNED NOT NULL,
  `permission_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`role_id`, `permission_id`),
  CONSTRAINT `rhp_role_fk`
    FOREIGN KEY (`role_id`) REFERENCES `roles`(`id`) ON DELETE CASCADE,
  CONSTRAINT `rhp_permission_fk`
    FOREIGN KEY (`permission_id`) REFERENCES `permissions`(`id`) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table: user_has_roles
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `user_has_roles` (
  `user_id` BIGINT UNSIGNED NOT NULL,
  `role_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`user_id`, `role_id`),
  CONSTRAINT `uhr_user_fk`
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  CONSTRAINT `uhr_role_fk`
    FOREIGN KEY (`role_id`) REFERENCES `roles`(`id`) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Seed: Roles
-- -----------------------------------------------------
INSERT IGNORE INTO `roles` (`id`, `name`, `created_at`) VALUES
(1, 'admin', NOW()),
(2, 'staff', NOW());

-- -----------------------------------------------------
-- Seed: Permissions untuk Potential Partner
-- -----------------------------------------------------
INSERT IGNORE INTO `permissions` (`id`, `name`, `created_at`) VALUES
(1, 'potential-partner.view',   NOW()),
(2, 'potential-partner.create', NOW()),
(3, 'potential-partner.edit',   NOW()),
(4, 'potential-partner.delete', NOW()),
(5, 'potential-partner.export', NOW()),
(6, 'potential-partner.api',    NOW());

-- -----------------------------------------------------
-- Seed: Admin role dapat semua permission
-- -----------------------------------------------------
INSERT IGNORE INTO `role_has_permissions` (`role_id`, `permission_id`) VALUES
(1, 1),(1, 2),(1, 3),(1, 4),(1, 5),(1, 6);

-- Staff hanya bisa view & api
INSERT IGNORE INTO `role_has_permissions` (`role_id`, `permission_id`) VALUES
(2, 1),(2, 6);

-- -----------------------------------------------------
-- Seed: Admin user
-- username: admin | password: admin123
-- (bcrypt hash dari "admin123")
-- -----------------------------------------------------
INSERT IGNORE INTO `users` (`id`, `name`, `username`, `email`, `password`, `created_at`) VALUES
(1,
 'Administrator',
 'admin',
 'admin@facultyware.ac.id',
 '$2a$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
 NOW());

-- Assign admin role ke user id=1
INSERT IGNORE INTO `user_has_roles` (`user_id`, `role_id`) VALUES (1, 1);

-- -----------------------------------------------------
-- Seed: Sample Data Potential Partners
-- -----------------------------------------------------
INSERT IGNORE INTO `potential_partners` (`id`, `company_name`, `contact_person`, `email`, `phone`, `address`, `partnership_type`, `description`, `status`, `created_at`) VALUES
(1, 'PT Teknologi Nusantara', 'Budi Santoso', 'budi@teknus.co.id', '08123456789', 'Jl. Sudirman No. 100, Jakarta Pusat', 'Industry', 'Perusahaan teknologi bidang pengembangan perangkat lunak enterprise.', 'active', NOW()),
(2, 'Universitas Merdeka Indonesia', 'Dr. Sari Dewi', 'sari@unimerdeka.ac.id', '02188765432', 'Jl. Pahlawan No. 20, Surabaya', 'Academic', 'Kerjasama riset bersama dan program pertukaran mahasiswa antar institusi.', 'active', NOW()),
(3, 'BRIN Pusat Riset AI', 'Ir. Ahmad Fauzi M.T.', 'ahmad.fauzi@brin.go.id', '02134567890', 'Jl. Gatot Subroto Kav. 33, Jakarta Selatan', 'Research', 'Kolaborasi riset nasional bidang kecerdasan buatan dan data sains.', 'active', NOW()),
(4, 'CV Makmur Jaya', 'Retno Wulandari', 'retno@makmurjaya.id', '08567891234', 'Jl. Raya Bogor KM 25, Depok', 'Internship', 'Program magang mahasiswa di bidang manufaktur dan logistik.', 'inactive', NOW());
