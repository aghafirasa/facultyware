-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jun 23, 2026 at 11:42 AM
-- Server version: 8.0.30
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `facultyware`
--

-- --------------------------------------------------------

--
-- Table structure for table `assets`
--

CREATE TABLE `assets` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('equipment','room') COLLATE utf8mb4_unicode_ci NOT NULL,
  `acquisition_type` enum('procurement','grant') COLLATE utf8mb4_unicode_ci NOT NULL,
  `acquisition_date` date NOT NULL,
  `acquisition_cost` decimal(14,2) DEFAULT NULL,
  `asset_grant_id` bigint UNSIGNED DEFAULT NULL,
  `condition` enum('good','minor_damage','major_damage') COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('available','in_use','maintenance','retired') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `asset_audits`
--

CREATE TABLE `asset_audits` (
  `id` bigint UNSIGNED NOT NULL,
  `audit_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `audit_date` date NOT NULL,
  `conducted_by` bigint UNSIGNED NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `employee_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `asset_audit_details`
--

CREATE TABLE `asset_audit_details` (
  `id` bigint UNSIGNED NOT NULL,
  `asset_audit_id` bigint UNSIGNED NOT NULL,
  `asset_id` bigint UNSIGNED NOT NULL,
  `condition` enum('good','minor_damage','major_damage','missing') COLLATE utf8mb4_unicode_ci NOT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `asset_grants`
--

CREATE TABLE `asset_grants` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `source` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `grant_date` date NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `asset_insurances`
--

CREATE TABLE `asset_insurances` (
  `id` bigint UNSIGNED NOT NULL,
  `asset_id` bigint UNSIGNED NOT NULL,
  `policy_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `provider` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `coverage_amount` decimal(14,2) NOT NULL,
  `premium` decimal(14,2) DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `status` enum('active','expired','claimed') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `asset_insurance_claims`
--

CREATE TABLE `asset_insurance_claims` (
  `id` bigint UNSIGNED NOT NULL,
  `asset_insurance_id` bigint UNSIGNED NOT NULL,
  `claim_date` date NOT NULL,
  `claim_amount` decimal(14,2) NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `status` enum('submitted','approved','rejected','paid') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `asset_trackings`
--

CREATE TABLE `asset_trackings` (
  `id` bigint UNSIGNED NOT NULL,
  `asset_id` bigint UNSIGNED NOT NULL,
  `location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitude` decimal(10,6) DEFAULT NULL,
  `longitude` decimal(10,6) DEFAULT NULL,
  `tracked_at` timestamp NOT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `asset_tracking_logs`
--

CREATE TABLE `asset_tracking_logs` (
  `id` bigint UNSIGNED NOT NULL,
  `asset_id` bigint UNSIGNED NOT NULL,
  `from_location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `to_location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `moved_at` timestamp NOT NULL,
  `moved_by` bigint UNSIGNED DEFAULT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `assignments`
--

CREATE TABLE `assignments` (
  `id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `assigned_by` bigint UNSIGNED NOT NULL,
  `assigned_to` bigint UNSIGNED NOT NULL,
  `parent_id` bigint UNSIGNED DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `status` enum('assigned','in_progress','completed','delegated','cancelled') COLLATE utf8mb4_unicode_ci NOT NULL,
  `priority` enum('low','medium','high') COLLATE utf8mb4_unicode_ci NOT NULL,
  `assigned_by_id` bigint UNSIGNED NOT NULL,
  `assigned_to_id` bigint UNSIGNED NOT NULL,
  `parent_id_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `assignment_progress`
--

CREATE TABLE `assignment_progress` (
  `id` bigint UNSIGNED NOT NULL,
  `assignment_id` bigint UNSIGNED NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `progress_date` date NOT NULL,
  `status` enum('in_progress','completed') COLLATE utf8mb4_unicode_ci NOT NULL,
  `attachment` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` bigint UNSIGNED NOT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `attendances`
--

CREATE TABLE `attendances` (
  `id` bigint UNSIGNED NOT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `date` date NOT NULL,
  `check_in` datetime DEFAULT NULL,
  `check_out` datetime DEFAULT NULL,
  `status` enum('present','absent','leave','overtime','holiday') COLLATE utf8mb4_unicode_ci NOT NULL,
  `notes` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `buildings`
--

CREATE TABLE `buildings` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `committees`
--

CREATE TABLE `committees` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `objective` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `expected_outcome` text COLLATE utf8mb4_unicode_ci,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `created_by` bigint UNSIGNED NOT NULL,
  `status` enum('draft','active','completed','cancelled') COLLATE utf8mb4_unicode_ci NOT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `committee_budgets`
--

CREATE TABLE `committee_budgets` (
  `id` bigint UNSIGNED NOT NULL,
  `committee_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `total_amount` decimal(14,2) NOT NULL,
  `used_amount` decimal(14,2) NOT NULL DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `committee_budget_items`
--

CREATE TABLE `committee_budget_items` (
  `id` bigint UNSIGNED NOT NULL,
  `committee_budget_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` int NOT NULL,
  `unit_price` decimal(14,2) NOT NULL,
  `total_price` decimal(14,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `committee_expenses`
--

CREATE TABLE `committee_expenses` (
  `id` bigint UNSIGNED NOT NULL,
  `committee_budget_item_id` bigint UNSIGNED NOT NULL,
  `amount` decimal(14,2) NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `receipt_file` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `expense_date` date NOT NULL,
  `status` enum('submitted','approved','rejected') COLLATE utf8mb4_unicode_ci NOT NULL,
  `approved_by` bigint UNSIGNED DEFAULT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `committee_external_members`
--

CREATE TABLE `committee_external_members` (
  `id` bigint UNSIGNED NOT NULL,
  `committee_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `institution` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `committee_members`
--

CREATE TABLE `committee_members` (
  `id` bigint UNSIGNED NOT NULL,
  `committee_id` bigint UNSIGNED NOT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `role` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_leader` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `committee_tasks`
--

CREATE TABLE `committee_tasks` (
  `id` bigint UNSIGNED NOT NULL,
  `committee_id` bigint UNSIGNED NOT NULL,
  `assigned_to` bigint UNSIGNED DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `start_date` date DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `priority` enum('low','medium','high') COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('todo','in_progress','done','blocked') COLLATE utf8mb4_unicode_ci NOT NULL,
  `committee_member_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `committee_task_progress`
--

CREATE TABLE `committee_task_progress` (
  `id` bigint UNSIGNED NOT NULL,
  `committee_task_id` bigint UNSIGNED NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `progress_date` date NOT NULL,
  `status` enum('in_progress','done') COLLATE utf8mb4_unicode_ci NOT NULL,
  `attachment` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `community_services`
--

CREATE TABLE `community_services` (
  `id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `location` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `funding_source` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('proposed','ongoing','completed') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `community_service_members`
--

CREATE TABLE `community_service_members` (
  `id` bigint UNSIGNED NOT NULL,
  `community_service_id` bigint UNSIGNED NOT NULL,
  `lecturer_id` bigint UNSIGNED NOT NULL,
  `role` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `conference_proceedings`
--

CREATE TABLE `conference_proceedings` (
  `id` bigint UNSIGNED NOT NULL,
  `publication_id` bigint UNSIGNED NOT NULL,
  `conference_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `conference_location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `conference_date` date DEFAULT NULL,
  `publisher` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `isbn` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pages` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `indexing` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `documents`
--

CREATE TABLE `documents` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  `document_type_id` bigint UNSIGNED DEFAULT NULL,
  `doc_no` varchar(45) DEFAULT NULL,
  `unit_owner` bigint UNSIGNED DEFAULT NULL,
  `published` tinyint DEFAULT NULL,
  `scope` varchar(45) DEFAULT NULL,
  `created_by` bigint UNSIGNED DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `document_revisions`
--

CREATE TABLE `document_revisions` (
  `id` int NOT NULL,
  `document_id` bigint UNSIGNED NOT NULL,
  `rev_no` int DEFAULT NULL,
  `doc_date` int DEFAULT NULL,
  `doc_month` int DEFAULT NULL,
  `doc_year` int DEFAULT NULL,
  `active` tinyint DEFAULT NULL,
  `uploaded_file` varchar(45) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `document_types`
--

CREATE TABLE `document_types` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `education_histories`
--

CREATE TABLE `education_histories` (
  `id` bigint UNSIGNED NOT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `degree` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `institution` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `major` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `start_year` year NOT NULL,
  `end_year` year DEFAULT NULL,
  `gpa` decimal(3,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

CREATE TABLE `employees` (
  `id` bigint UNSIGNED NOT NULL,
  `employee_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `national_id_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tax_id_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `birth_place` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `birth_date` date NOT NULL,
  `gender` enum('male','female') COLLATE utf8mb4_unicode_ci NOT NULL,
  `religion` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `marital_status` enum('single','married','divorced') COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `organization_unit_id` bigint UNSIGNED NOT NULL,
  `hire_date` date NOT NULL,
  `employment_status_id` bigint UNSIGNED NOT NULL,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `employee_grades`
--

CREATE TABLE `employee_grades` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `employment_statuses`
--

CREATE TABLE `employment_statuses` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `equipments`
--

CREATE TABLE `equipments` (
  `id` bigint UNSIGNED NOT NULL,
  `asset_id` bigint UNSIGNED NOT NULL,
  `brand` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `model` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `serial_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `specification` text COLLATE utf8mb4_unicode_ci,
  `purchase_link` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `photo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depreciation_value` decimal(14,2) DEFAULT NULL,
  `useful_life` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `equipment_loans`
--

CREATE TABLE `equipment_loans` (
  `id` bigint UNSIGNED NOT NULL,
  `equipment_id` bigint UNSIGNED NOT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `status` enum('requested','approved','rejected','returned') COLLATE utf8mb4_unicode_ci NOT NULL,
  `approved_by` bigint UNSIGNED DEFAULT NULL,
  `approved_by_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `equipment_maintenance_requests`
--

CREATE TABLE `equipment_maintenance_requests` (
  `id` bigint UNSIGNED NOT NULL,
  `equipment_id` bigint UNSIGNED NOT NULL,
  `reported_by` bigint UNSIGNED NOT NULL,
  `issue_description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('reported','in_progress','resolved') COLLATE utf8mb4_unicode_ci NOT NULL,
  `reported_at` timestamp NOT NULL,
  `resolved_at` timestamp NULL DEFAULT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `equipment_maintenance_request_log`
--

CREATE TABLE `equipment_maintenance_request_log` (
  `id` bigint NOT NULL,
  `equipment_maintenance_request_id` bigint UNSIGNED DEFAULT NULL,
  `log` varchar(45) DEFAULT NULL,
  `logged_by` bigint UNSIGNED DEFAULT NULL,
  `logged_at` datetime DEFAULT NULL,
  `log_file` varchar(255) DEFAULT NULL,
  `verified_by` bigint UNSIGNED DEFAULT NULL,
  `verified_at` datetime DEFAULT NULL,
  `verification_file` varchar(255) DEFAULT NULL,
  `description` text,
  `status` int DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `equipment_procurements`
--

CREATE TABLE `equipment_procurements` (
  `id` bigint UNSIGNED NOT NULL,
  `request_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('draft','submitted','approved','rejected','completed') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` bigint UNSIGNED NOT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `equipment_proc_items`
--

CREATE TABLE `equipment_proc_items` (
  `id` bigint UNSIGNED NOT NULL,
  `equipment_proc_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `specification` text COLLATE utf8mb4_unicode_ci,
  `quantity` int NOT NULL,
  `estimated_price` decimal(14,2) DEFAULT NULL,
  `asset_equipment_procurement_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `equipment_requests`
--

CREATE TABLE `equipment_requests` (
  `id` bigint UNSIGNED NOT NULL,
  `request_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `specification` text COLLATE utf8mb4_unicode_ci,
  `purchase_link` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `photo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` int NOT NULL,
  `status` enum('pending','approved','rejected') COLLATE utf8mb4_unicode_ci NOT NULL,
  `submitted_at` timestamp NOT NULL,
  `approved_by` bigint UNSIGNED DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `objectives` text COLLATE utf8mb4_unicode_ci,
  `event_type` enum('seminar','workshop','training','conference','webinar','other') COLLATE utf8mb4_unicode_ci NOT NULL,
  `delivery_mode` enum('offline','online','hybrid') COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `venue` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `online_platform` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `online_link` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quota` int DEFAULT NULL,
  `registration_deadline` datetime DEFAULT NULL,
  `cover_image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `banner_image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('draft','published','closed','cancelled') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` bigint UNSIGNED NOT NULL,
  `published_by` bigint UNSIGNED DEFAULT NULL,
  `published_at` timestamp NULL DEFAULT NULL,
  `created_by_id` bigint UNSIGNED NOT NULL,
  `published_by_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `event_attendances`
--

CREATE TABLE `event_attendances` (
  `id` bigint UNSIGNED NOT NULL,
  `event_registration_id` bigint UNSIGNED NOT NULL,
  `checked_in_at` timestamp NULL DEFAULT NULL,
  `checked_out_at` timestamp NULL DEFAULT NULL,
  `checked_by` bigint UNSIGNED DEFAULT NULL,
  `attendance_method` enum('manual','qr_scan','system') COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('present','absent','partial') COLLATE utf8mb4_unicode_ci NOT NULL,
  `checked_by_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `event_committee_members`
--

CREATE TABLE `event_committee_members` (
  `id` bigint UNSIGNED NOT NULL,
  `event_id` bigint UNSIGNED NOT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `role` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_leader` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `event_documents`
--

CREATE TABLE `event_documents` (
  `id` bigint UNSIGNED NOT NULL,
  `event_id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `document_type` enum('report','photo','proposal','minutes','attendance','other') COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `uploaded_by` bigint UNSIGNED NOT NULL,
  `uploaded_at` timestamp NOT NULL,
  `uploaded_by_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `event_registrations`
--

CREATE TABLE `event_registrations` (
  `id` bigint UNSIGNED NOT NULL,
  `event_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `registration_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `registered_at` timestamp NOT NULL,
  `attendance_status` enum('registered','attended','no_show','cancelled') COLLATE utf8mb4_unicode_ci NOT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `ticket_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `qr_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `issued_at` timestamp NOT NULL,
  `certificate_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `generated_by` bigint UNSIGNED DEFAULT NULL,
  `generated_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `event_reminders`
--

CREATE TABLE `event_reminders` (
  `id` bigint UNSIGNED NOT NULL,
  `event_id` bigint UNSIGNED NOT NULL,
  `sent_by` bigint UNSIGNED NOT NULL,
  `channel` enum('email','whatsapp','sms','system') COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `sent_at` timestamp NOT NULL,
  `sent_by_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `follow_up`
--

CREATE TABLE `follow_up` (
  `id` int NOT NULL,
  `potential_partner_id` bigint UNSIGNED DEFAULT NULL,
  `catatan` text,
  `tanggal` date DEFAULT NULL,
  `created_by` bigint UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `follow_up`
--

INSERT INTO `follow_up` (`id`, `potential_partner_id`, `catatan`, `tanggal`, `created_by`, `created_at`) VALUES
(1, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-21 07:19:37'),
(2, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-21 07:19:37'),
(3, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-21 07:19:43'),
(4, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-21 07:20:48'),
(5, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-21 07:20:55'),
(6, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-21 07:23:17'),
(7, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-21 07:23:21'),
(8, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-21 07:23:22'),
(9, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-21 07:23:44'),
(10, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-21 07:23:49'),
(11, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-21 07:24:22'),
(12, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-21 07:33:21'),
(13, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-21 07:33:58'),
(14, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-21 07:35:20'),
(15, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-21 07:35:26'),
(16, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-21 07:35:33'),
(17, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-22 10:37:40'),
(18, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-22 10:38:28'),
(19, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-22 10:39:13'),
(20, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-22 10:42:47'),
(21, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-22 10:43:27'),
(22, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-22 10:44:07'),
(23, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-22 10:44:32'),
(24, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-22 10:44:43'),
(25, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-22 10:44:55'),
(26, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-22 11:57:53'),
(27, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-22 11:58:06'),
(28, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-22 12:02:20'),
(29, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-22 12:02:28'),
(30, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-22 12:02:36'),
(31, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-23 10:00:44'),
(32, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-23 10:00:52'),
(33, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-23 10:08:54'),
(34, 1, 'Follow up diskusi draft MoU', '2026-06-25', 1, '2026-06-23 10:09:00');

-- --------------------------------------------------------

--
-- Table structure for table `functional_positions`
--

CREATE TABLE `functional_positions` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `holidays`
--

CREATE TABLE `holidays` (
  `id` bigint UNSIGNED NOT NULL,
  `date` date NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `implementation_arrangements`
--

CREATE TABLE `implementation_arrangements` (
  `id` bigint UNSIGNED NOT NULL,
  `partnership_id` bigint UNSIGNED NOT NULL,
  `partnership_impl_id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `document_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `document_file` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `partnership_implementation_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `inventories`
--

CREATE TABLE `inventories` (
  `id` bigint UNSIGNED NOT NULL,
  `item_id` bigint UNSIGNED NOT NULL,
  `quantity` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `inventory_procurements`
--

CREATE TABLE `inventory_procurements` (
  `id` bigint UNSIGNED NOT NULL,
  `request_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('draft','submitted','approved','rejected') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` bigint UNSIGNED NOT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `inventory_procurement_items`
--

CREATE TABLE `inventory_procurement_items` (
  `id` bigint UNSIGNED NOT NULL,
  `inventory_procurement_id` bigint UNSIGNED NOT NULL,
  `item_id` bigint UNSIGNED DEFAULT NULL,
  `item_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `inventory_purchases`
--

CREATE TABLE `inventory_purchases` (
  `id` bigint UNSIGNED NOT NULL,
  `purchase_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `inventory_procurement_id` bigint UNSIGNED DEFAULT NULL,
  `purchase_date` date NOT NULL,
  `supplier` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('draft','completed') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `inventory_purchase_items`
--

CREATE TABLE `inventory_purchase_items` (
  `id` bigint UNSIGNED NOT NULL,
  `inventory_purchase_id` bigint UNSIGNED NOT NULL,
  `item_id` bigint UNSIGNED NOT NULL,
  `quantity` int NOT NULL,
  `price` decimal(12,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `inventory_requests`
--

CREATE TABLE `inventory_requests` (
  `id` bigint UNSIGNED NOT NULL,
  `request_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `request_date` date NOT NULL,
  `status` enum('pending','approved','rejected','fulfilled') COLLATE utf8mb4_unicode_ci NOT NULL,
  `approved_by` bigint UNSIGNED DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `approved_by_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `inventory_request_approvals`
--

CREATE TABLE `inventory_request_approvals` (
  `id` bigint UNSIGNED NOT NULL,
  `inventory_request_id` bigint UNSIGNED NOT NULL,
  `approver_id` bigint UNSIGNED NOT NULL,
  `status` enum('approved','rejected') COLLATE utf8mb4_unicode_ci NOT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `action_date` timestamp NOT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `inventory_request_details`
--

CREATE TABLE `inventory_request_details` (
  `id` bigint UNSIGNED NOT NULL,
  `inventory_request_id` bigint UNSIGNED NOT NULL,
  `item_id` bigint UNSIGNED DEFAULT NULL,
  `item_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `specification` text COLLATE utf8mb4_unicode_ci,
  `quantity` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `inventory_transactions`
--

CREATE TABLE `inventory_transactions` (
  `id` bigint UNSIGNED NOT NULL,
  `item_id` bigint UNSIGNED NOT NULL,
  `type` enum('in','out','adjustment') COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` int NOT NULL,
  `transaction_date` date NOT NULL,
  `reference` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `unit` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `minimal_quantity` int NOT NULL DEFAULT '0',
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint UNSIGNED NOT NULL,
  `reserved_at` int UNSIGNED DEFAULT NULL,
  `available_at` int UNSIGNED NOT NULL,
  `created_at` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_responsibilities`
--

CREATE TABLE `job_responsibilities` (
  `id` bigint UNSIGNED NOT NULL,
  `structural_position_id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('main','function') COLLATE utf8mb4_unicode_ci NOT NULL,
  `order` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `journal_publications`
--

CREATE TABLE `journal_publications` (
  `id` bigint UNSIGNED NOT NULL,
  `publication_id` bigint UNSIGNED NOT NULL,
  `journal_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `issn` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `publisher` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `volume` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `issue` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pages` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `indexing` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quartile` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `leave_approvals`
--

CREATE TABLE `leave_approvals` (
  `id` bigint UNSIGNED NOT NULL,
  `leave_request_id` bigint UNSIGNED NOT NULL,
  `approver_id` bigint UNSIGNED NOT NULL,
  `level` int NOT NULL,
  `status` enum('pending','approved','rejected') COLLATE utf8mb4_unicode_ci NOT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `action_date` timestamp NULL DEFAULT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `leave_balances`
--

CREATE TABLE `leave_balances` (
  `id` bigint UNSIGNED NOT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `leave_type_id` bigint UNSIGNED NOT NULL,
  `year` year NOT NULL,
  `quota` int NOT NULL,
  `used` int NOT NULL DEFAULT '0',
  `remaining` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `leave_requests`
--

CREATE TABLE `leave_requests` (
  `id` bigint UNSIGNED NOT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `leave_type_id` bigint UNSIGNED NOT NULL,
  `approver_id` bigint UNSIGNED DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `total_days` int NOT NULL,
  `reason` text COLLATE utf8mb4_unicode_ci,
  `attachment` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_leave` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_leave` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('pending','approved','rejected','cancelled') COLLATE utf8mb4_unicode_ci NOT NULL,
  `submitted_at` timestamp NOT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `approver_id_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `leave_types`
--

CREATE TABLE `leave_types` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `default_quota` int NOT NULL,
  `requires_attachment` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lecturers`
--

CREATE TABLE `lecturers` (
  `id` bigint UNSIGNED NOT NULL,
  `academic_rank` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `functional_position` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `expertise` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lecturer_functional_positions`
--

CREATE TABLE `lecturer_functional_positions` (
  `id` bigint UNSIGNED NOT NULL,
  `lecturer_id` bigint UNSIGNED NOT NULL,
  `functional_position_id` bigint UNSIGNED NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `decree_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `decree_date` date DEFAULT NULL,
  `sk_file` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `meetings`
--

CREATE TABLE `meetings` (
  `id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `organizer_id` bigint UNSIGNED NOT NULL,
  `leader_id` bigint UNSIGNED NOT NULL,
  `meeting_type` enum('offline','online','hybrid') COLLATE utf8mb4_unicode_ci NOT NULL,
  `meeting_date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `asset_room_id` bigint UNSIGNED DEFAULT NULL,
  `online_platform` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `online_link` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `committee_id` bigint UNSIGNED DEFAULT NULL,
  `is_confidential` tinyint(1) NOT NULL DEFAULT '0',
  `status` enum('draft','scheduled','completed','cancelled') COLLATE utf8mb4_unicode_ci NOT NULL,
  `organizer_id_id` bigint UNSIGNED NOT NULL,
  `leader_id_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `meeting_consumption_requests`
--

CREATE TABLE `meeting_consumption_requests` (
  `id` bigint UNSIGNED NOT NULL,
  `meeting_id` bigint UNSIGNED NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `estimated_participants` int NOT NULL,
  `status` enum('requested','approved','rejected','fulfilled') COLLATE utf8mb4_unicode_ci NOT NULL,
  `requested_at` timestamp NOT NULL,
  `approved_by` bigint UNSIGNED DEFAULT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `meeting_documents`
--

CREATE TABLE `meeting_documents` (
  `id` bigint UNSIGNED NOT NULL,
  `meeting_id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `uploaded_by` bigint UNSIGNED NOT NULL,
  `uploaded_at` timestamp NOT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `meeting_external_participants`
--

CREATE TABLE `meeting_external_participants` (
  `id` bigint UNSIGNED NOT NULL,
  `meeting_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `institution` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `meeting_minutes`
--

CREATE TABLE `meeting_minutes` (
  `id` bigint UNSIGNED NOT NULL,
  `meeting_id` bigint UNSIGNED NOT NULL,
  `summary` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `file` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_confidential` tinyint(1) NOT NULL DEFAULT '0',
  `created_by` bigint UNSIGNED NOT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `meeting_participants`
--

CREATE TABLE `meeting_participants` (
  `id` bigint UNSIGNED NOT NULL,
  `meeting_id` bigint UNSIGNED NOT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `status` enum('invited','confirmed','attended') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `model_has_permissions`
--

CREATE TABLE `model_has_permissions` (
  `permission_id` bigint UNSIGNED NOT NULL,
  `model_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `model_has_roles`
--

CREATE TABLE `model_has_roles` (
  `role_id` bigint UNSIGNED NOT NULL,
  `model_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `mou`
--

CREATE TABLE `mou` (
  `id` int NOT NULL,
  `potential_partner_id` bigint UNSIGNED DEFAULT NULL,
  `draft_isi` text,
  `status` enum('draft','disetujui','ditolak') DEFAULT 'draft',
  `created_by` bigint UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `mou`
--

INSERT INTO `mou` (`id`, `potential_partner_id`, `draft_isi`, `status`, `created_by`, `created_at`) VALUES
(1, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-21 07:19:37'),
(2, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-21 07:19:37'),
(3, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-21 07:19:43'),
(4, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-21 07:20:48'),
(5, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-21 07:20:56'),
(6, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-21 07:23:17'),
(7, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-21 07:23:22'),
(8, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-21 07:23:22'),
(9, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-21 07:23:44'),
(10, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-21 07:23:49'),
(11, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-21 07:24:22'),
(12, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-21 07:33:21'),
(13, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-21 07:33:58'),
(14, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-21 07:34:35'),
(15, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-21 07:35:20'),
(16, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-21 07:35:26'),
(17, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-21 07:35:33'),
(18, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-22 10:37:40'),
(19, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-22 10:38:28'),
(20, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-22 10:39:13'),
(21, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-22 10:42:47'),
(22, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-22 10:43:27'),
(23, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-22 10:44:07'),
(24, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-22 10:44:32'),
(25, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-22 10:44:43'),
(26, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-22 10:44:55'),
(28, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-22 11:57:53'),
(29, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-22 11:58:06'),
(30, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-22 11:58:20'),
(31, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-22 12:02:20'),
(32, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-22 12:02:29'),
(34, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-23 10:00:44'),
(35, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-23 10:00:52'),
(36, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-23 10:01:00'),
(37, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-23 10:08:54'),
(38, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-23 10:09:00'),
(39, 1, 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa', 'draft', 1, '2026-06-23 10:09:07');

-- --------------------------------------------------------

--
-- Table structure for table `nomenclatures`
--

CREATE TABLE `nomenclatures` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `qualification` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `duties` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `grade` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nomenclature_classifications`
--

CREATE TABLE `nomenclature_classifications` (
  `id` bigint UNSIGNED NOT NULL,
  `nomenclature_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `official_travel`
--

CREATE TABLE `official_travel` (
  `id` bigint UNSIGNED NOT NULL,
  `request_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `purpose` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `destination` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `invitation_file` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('draft','pending','approved','rejected','completed') COLLATE utf8mb4_unicode_ci NOT NULL,
  `submitted_by` bigint UNSIGNED NOT NULL,
  `submitted_at` timestamp NOT NULL,
  `approved_by` bigint UNSIGNED DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `travel_outcome` text COLLATE utf8mb4_unicode_ci,
  `outcome_followup` text COLLATE utf8mb4_unicode_ci,
  `submitted_by_id` bigint UNSIGNED NOT NULL,
  `approved_by_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `official_travel_approvals`
--

CREATE TABLE `official_travel_approvals` (
  `id` bigint UNSIGNED NOT NULL,
  `official_travel_id` bigint UNSIGNED NOT NULL,
  `approver_id` bigint UNSIGNED NOT NULL,
  `status` enum('approved','rejected') COLLATE utf8mb4_unicode_ci NOT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `action_date` timestamp NOT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `official_travel_documents`
--

CREATE TABLE `official_travel_documents` (
  `id` bigint UNSIGNED NOT NULL,
  `official_travel_id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `uploaded_at` timestamp NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `official_travel_itineraries`
--

CREATE TABLE `official_travel_itineraries` (
  `id` bigint UNSIGNED NOT NULL,
  `official_travel_id` bigint UNSIGNED NOT NULL,
  `date` date NOT NULL,
  `location` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `activity` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `official_travel_members`
--

CREATE TABLE `official_travel_members` (
  `id` bigint UNSIGNED NOT NULL,
  `official_travel_id` bigint UNSIGNED NOT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `report_date` date NOT NULL,
  `summary` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `attachment` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `organization_units`
--

CREATE TABLE `organization_units` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `parent_id` bigint UNSIGNED DEFAULT NULL,
  `type` enum('university','faculty','department','lab','unit') COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `organization_unit_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `overtime_approval_logs`
--

CREATE TABLE `overtime_approval_logs` (
  `id` bigint UNSIGNED NOT NULL,
  `overtime_request_id` bigint UNSIGNED NOT NULL,
  `approver_id` bigint UNSIGNED NOT NULL,
  `status` enum('approved','rejected') COLLATE utf8mb4_unicode_ci NOT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `action_date` timestamp NOT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `overtime_requests`
--

CREATE TABLE `overtime_requests` (
  `id` bigint UNSIGNED NOT NULL,
  `request_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `request_date` date NOT NULL,
  `planned_start_time` datetime NOT NULL,
  `planned_end_time` datetime NOT NULL,
  `submitted_by` bigint UNSIGNED NOT NULL,
  `approved_by` bigint UNSIGNED DEFAULT NULL,
  `status` enum('draft','pending','approved','rejected','completed','cancelled') COLLATE utf8mb4_unicode_ci NOT NULL,
  `submitted_at` timestamp NULL DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `submitted_by_id` bigint UNSIGNED NOT NULL,
  `approved_by_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `overtime_request_members`
--

CREATE TABLE `overtime_request_members` (
  `id` bigint UNSIGNED NOT NULL,
  `overtime_request_id` bigint UNSIGNED NOT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `role` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `job_desc` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `planned_hours` decimal(5,2) NOT NULL,
  `actual_start_time` datetime NOT NULL,
  `actual_end_time` datetime NOT NULL,
  `actual_hours` decimal(5,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `partners`
--

CREATE TABLE `partners` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('university','company','government','ngo','other') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` text COLLATE utf8mb4_unicode_ci,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `contact_person` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `partners`
--

INSERT INTO `partners` (`id`, `name`, `type`, `address`, `email`, `phone`, `description`, `contact_person`, `created_at`, `updated_at`) VALUES
(1, 'PT Teknologi Nusantara', 'company', 'Jl. Sudirman No. 100, Jakarta Pusat', 'budi@teknus.co.id', '08123456789', NULL, 'Updated Contact 1782125043003', '2026-06-22 10:29:53', '2026-06-22 10:44:03'),
(2, 'Universitas Merdeka Indonesia', 'university', 'Jl. Pahlawan No. 20, Surabaya', 'sari@unimerdeka.ac.id', '02188765432', NULL, 'Dr. Sari Dewi', '2026-06-22 10:29:53', NULL),
(3, 'BRIN Pusat Riset AI', 'government', 'Jl. Gatot Subroto Kav. 33, Jakarta Selatan', 'ahmad.fauzi@brin.go.id', '02134567890', NULL, 'Ir. Ahmad Fauzi M.T.', '2026-06-22 10:29:53', NULL),
(4, 'CV Makmur Jaya', 'company', 'Jl. Raya Bogor KM 25, Depok', 'retno@makmurjaya.id', '08567891234', NULL, 'Retno Wulandari', '2026-06-22 10:29:53', NULL),
(5, 'Test Company', 'university', NULL, 'test@example.com', '081234567890', NULL, 'John Doe', '2026-06-20 15:40:32', '2026-06-20 15:43:40'),
(6, 'Test Company 1782026376820', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Ahmad Dani', '2026-06-21 07:19:37', NULL),
(7, 'Test Company 1782026378035', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Ahmad Dani', '2026-06-21 07:19:38', NULL),
(8, 'Test Company 1782026382645', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Updated Contact 1782026447776', '2026-06-21 07:19:43', '2026-06-21 07:20:48'),
(9, 'Test Company 1782026448217', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Updated Contact 1782026450474', '2026-06-21 07:20:49', '2026-06-21 07:20:50'),
(10, 'Test Company 1782026451476', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Updated Contact 1782026453805', '2026-06-21 07:20:52', '2026-06-21 07:20:54'),
(11, 'Test Company 1782026453436', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Updated Contact 1782026597418', '2026-06-21 07:20:54', '2026-06-21 07:23:17'),
(12, 'Test Company 1782026596860', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Updated Contact 1782026598831', '2026-06-21 07:23:17', '2026-06-21 07:23:19'),
(13, 'Test Company 1782026599185', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Ahmad Dani', '2026-06-21 07:23:19', NULL),
(14, 'Test Company 1782026600478', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Updated Contact 1782026623885', '2026-06-21 07:23:20', '2026-06-21 07:23:43'),
(15, 'Test Company 1782026623340', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Updated Contact 1782026627466', '2026-06-21 07:23:44', '2026-06-21 07:23:47'),
(16, 'Test Company 1782026626653', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Ahmad Dani', '2026-06-21 07:23:47', NULL),
(17, 'Test Company 1782026630963', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Updated Contact 1782026661918', '2026-06-21 07:23:51', '2026-06-21 07:24:21'),
(18, 'Test Company 1782026664619', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Updated Contact 1782026667433', '2026-06-21 07:24:25', '2026-06-21 07:24:27'),
(19, 'Test Company 1782026664783', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Ahmad Dani', '2026-06-21 07:24:25', NULL),
(20, 'Test Company 1782027167379', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Updated Contact 1782027169392', '2026-06-21 07:32:48', '2026-06-21 07:32:49'),
(21, 'Test Company 1782027203680', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Updated Contact 1782027205282', '2026-06-21 07:33:23', '2026-06-21 07:33:25'),
(22, 'Test Company 1782027240766', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Updated Contact 1782027242558', '2026-06-21 07:34:01', '2026-06-21 07:34:02'),
(23, 'Test Company 1782027316480', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Updated Contact 1782027318418', '2026-06-21 07:35:17', '2026-06-21 07:35:18'),
(24, 'Test Company 1782027322923', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Updated Contact 1782027324625', '2026-06-21 07:35:23', '2026-06-21 07:35:24'),
(25, 'Test Company 1782027329005', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Updated Contact 1782027330836', '2026-06-21 07:35:29', '2026-06-21 07:35:31'),
(26, 'Test Company 1782125067761', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Updated Contact 1782125070266', '2026-06-22 10:44:28', '2026-06-22 10:44:30'),
(27, 'Test Company 1782125077023', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Updated Contact 1782125080040', '2026-06-22 10:44:37', '2026-06-22 10:44:40'),
(28, 'Test Company 1782125087082', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Updated Contact 1782125090582', '2026-06-22 10:44:47', '2026-06-22 10:44:50'),
(29, 'Test Company 1782129469794', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Updated Contact 1782129471883', '2026-06-22 11:57:50', '2026-06-22 11:57:51'),
(30, 'Test Company 1782129482128', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Updated Contact 1782129483837', '2026-06-22 11:58:02', '2026-06-22 11:58:03'),
(31, 'Test Company 1782129495286', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Updated Contact 1782129497262', '2026-06-22 11:58:15', '2026-06-22 11:58:17'),
(32, 'Test Company 1782129736688', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Updated Contact 1782129738812', '2026-06-22 12:02:17', '2026-06-22 12:02:18'),
(33, 'Test Company 1782129743933', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Updated Contact 1782129746033', '2026-06-22 12:02:24', '2026-06-22 12:02:26'),
(35, 'Test Company 1782208840513', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Updated Contact 1782208842520', '2026-06-23 10:00:41', '2026-06-23 10:00:42'),
(36, 'Test Company 1782208847813', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Updated Contact 1782208849805', '2026-06-23 10:00:47', '2026-06-23 10:00:49'),
(37, 'Test Company 1782208856030', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Updated Contact 1782208857871', '2026-06-23 10:00:56', '2026-06-23 10:00:58'),
(38, 'Test Company 1782209330493', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Updated Contact 1782209332440', '2026-06-23 10:08:51', '2026-06-23 10:08:52'),
(39, 'Test Company 1782209336746', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Updated Contact 1782209338260', '2026-06-23 10:08:56', '2026-06-23 10:08:58'),
(40, 'Test Company 1782209342535', 'company', 'Jl. Sudirman No. 45 Jakarta', 'dani@testcompany.com', '+628123456789', NULL, 'Updated Contact 1782209344356', '2026-06-23 10:09:02', '2026-06-23 10:09:04');

-- --------------------------------------------------------

--
-- Table structure for table `partnerships`
--

CREATE TABLE `partnerships` (
  `id` bigint UNSIGNED NOT NULL,
  `partner_id` bigint UNSIGNED NOT NULL,
  `partner_potential_id` bigint UNSIGNED DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `document_type` enum('moa','pks') COLLATE utf8mb4_unicode_ci NOT NULL,
  `document_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `status` enum('active','expired','terminated') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `partnership_documents`
--

CREATE TABLE `partnership_documents` (
  `id` bigint UNSIGNED NOT NULL,
  `partnership_id` bigint UNSIGNED NOT NULL,
  `file_path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `signed_date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `partnership_implementations`
--

CREATE TABLE `partnership_implementations` (
  `id` bigint UNSIGNED NOT NULL,
  `partnership_id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `status` enum('planned','ongoing','completed') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `partner_contacts`
--

CREATE TABLE `partner_contacts` (
  `id` bigint UNSIGNED NOT NULL,
  `partner_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `position` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_primary` tinyint(1) NOT NULL DEFAULT '0',
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `partner_follow_ups`
--

CREATE TABLE `partner_follow_ups` (
  `id` bigint UNSIGNED NOT NULL,
  `partner_potential_id` bigint UNSIGNED NOT NULL,
  `activity_date` date NOT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `status` enum('planned','ongoing','completed') COLLATE utf8mb4_unicode_ci NOT NULL,
  `conducted_by` bigint UNSIGNED NOT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `partner_potentials`
--

CREATE TABLE `partner_potentials` (
  `id` bigint UNSIGNED NOT NULL,
  `partner_id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `status` enum('identified','in_discussion','proposed','converted','rejected') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'identified',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `partner_potentials`
--

INSERT INTO `partner_potentials` (`id`, `partner_id`, `title`, `description`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 'PT Teknologi Nusantara', 'Perusahaan teknologi bidang pengembangan perangkat lunak enterprise.', 'identified', '2026-06-22 10:29:53', '2026-06-22 10:44:03'),
(2, 2, 'Universitas Merdeka Indonesia', 'Kerjasama riset bersama dan program pertukaran mahasiswa antar institusi.', 'identified', '2026-06-22 10:29:53', NULL),
(3, 3, 'BRIN Pusat Riset AI', 'Kolaborasi riset nasional bidang kecerdasan buatan dan data sains.', 'identified', '2026-06-22 10:29:53', NULL),
(4, 4, 'CV Makmur Jaya', 'Program magang mahasiswa di bidang manufaktur dan logistik.', 'rejected', '2026-06-22 10:29:53', NULL),
(5, 5, 'Test Company', NULL, 'rejected', '2026-06-20 15:40:32', '2026-06-20 15:43:40'),
(6, 6, 'Test Company 1782026376820', 'Kemitraan magang industri', 'identified', '2026-06-21 07:19:37', NULL),
(7, 7, 'Test Company 1782026378035', 'Kemitraan magang industri', 'identified', '2026-06-21 07:19:38', NULL),
(8, 8, 'Test Company 1782026382645', 'Kemitraan magang industri', 'identified', '2026-06-21 07:19:43', '2026-06-21 07:20:48'),
(9, 9, 'Test Company 1782026448217', 'Kemitraan magang industri', 'identified', '2026-06-21 07:20:49', '2026-06-21 07:20:50'),
(10, 10, 'Test Company 1782026451476', 'Kemitraan magang industri', 'identified', '2026-06-21 07:20:52', '2026-06-21 07:20:54'),
(11, 11, 'Test Company 1782026453436', 'Kemitraan magang industri', 'identified', '2026-06-21 07:20:54', '2026-06-21 07:23:17'),
(12, 12, 'Test Company 1782026596860', 'Kemitraan magang industri', 'identified', '2026-06-21 07:23:17', '2026-06-21 07:23:19'),
(13, 13, 'Test Company 1782026599185', 'Kemitraan magang industri', 'identified', '2026-06-21 07:23:19', NULL),
(14, 14, 'Test Company 1782026600478', 'Kemitraan magang industri', 'identified', '2026-06-21 07:23:20', '2026-06-21 07:23:43'),
(15, 15, 'Test Company 1782026623340', 'Kemitraan magang industri', 'identified', '2026-06-21 07:23:44', '2026-06-21 07:23:47'),
(16, 16, 'Test Company 1782026626653', 'Kemitraan magang industri', 'identified', '2026-06-21 07:23:47', NULL),
(17, 17, 'Test Company 1782026630963', 'Kemitraan magang industri', 'identified', '2026-06-21 07:23:51', '2026-06-21 07:24:21'),
(18, 18, 'Test Company 1782026664619', 'Kemitraan magang industri', 'identified', '2026-06-21 07:24:25', '2026-06-21 07:24:27'),
(19, 19, 'Test Company 1782026664783', 'Kemitraan magang industri', 'identified', '2026-06-21 07:24:25', NULL),
(20, 20, 'Test Company 1782027167379', 'Kemitraan magang industri', 'identified', '2026-06-21 07:32:48', '2026-06-21 07:32:49'),
(21, 21, 'Test Company 1782027203680', 'Kemitraan magang industri', 'identified', '2026-06-21 07:33:23', '2026-06-21 07:33:25'),
(22, 22, 'Test Company 1782027240766', 'Kemitraan magang industri', 'identified', '2026-06-21 07:34:01', '2026-06-21 07:34:02'),
(23, 23, 'Test Company 1782027316480', 'Kemitraan magang industri', 'identified', '2026-06-21 07:35:17', '2026-06-21 07:35:18'),
(24, 24, 'Test Company 1782027322923', 'Kemitraan magang industri', 'identified', '2026-06-21 07:35:23', '2026-06-21 07:35:24'),
(25, 25, 'Test Company 1782027329005', 'Kemitraan magang industri', 'identified', '2026-06-21 07:35:29', '2026-06-21 07:35:31'),
(26, 26, 'Test Company 1782125067761', 'Kemitraan magang industri', 'identified', '2026-06-22 10:44:28', '2026-06-22 10:44:30'),
(27, 27, 'Test Company 1782125077023', 'Kemitraan magang industri', 'identified', '2026-06-22 10:44:37', '2026-06-22 10:44:40'),
(28, 28, 'Test Company 1782125087082', 'Kemitraan magang industri', 'identified', '2026-06-22 10:44:47', '2026-06-22 10:44:50'),
(29, 29, 'Test Company 1782129469794', 'Kemitraan magang industri', 'identified', '2026-06-22 11:57:50', '2026-06-22 11:57:51'),
(30, 30, 'Test Company 1782129482128', 'Kemitraan magang industri', 'identified', '2026-06-22 11:58:02', '2026-06-22 11:58:03'),
(31, 31, 'Test Company 1782129495286', 'Kemitraan magang industri', 'identified', '2026-06-22 11:58:15', '2026-06-22 11:58:17'),
(32, 32, 'Test Company 1782129736688', 'Kemitraan magang industri', 'identified', '2026-06-22 12:02:17', '2026-06-22 12:02:18'),
(33, 33, 'Test Company 1782129743933', 'Kemitraan magang industri', 'identified', '2026-06-22 12:02:24', '2026-06-22 12:02:26'),
(35, 35, 'Test Company 1782208840513', 'Kemitraan magang industri', 'identified', '2026-06-23 10:00:41', '2026-06-23 10:00:42'),
(36, 36, 'Test Company 1782208847813', 'Kemitraan magang industri', 'identified', '2026-06-23 10:00:47', '2026-06-23 10:00:49'),
(37, 37, 'Test Company 1782208856030', 'Kemitraan magang industri', 'identified', '2026-06-23 10:00:56', '2026-06-23 10:00:58'),
(38, 38, 'Test Company 1782209330493', 'Kemitraan magang industri', 'rejected', '2026-06-23 10:08:51', '2026-06-23 10:14:10'),
(39, 39, 'Test Company 1782209336746', 'Kemitraan magang industri', 'converted', '2026-06-23 10:08:56', '2026-06-23 10:14:08'),
(40, 40, 'Test Company 1782209342535', 'Kemitraan magang industri', 'converted', '2026-06-23 10:09:02', '2026-06-23 10:11:32');

-- --------------------------------------------------------

--
-- Table structure for table `partner_potential_fields`
--

CREATE TABLE `partner_potential_fields` (
  `id` bigint UNSIGNED NOT NULL,
  `partner_potential_id` bigint UNSIGNED NOT NULL,
  `field` enum('research','community_service','internship','training','other') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `created_at`, `updated_at`) VALUES
(1, 'potential-partner.view', '2026-05-30 17:28:21', NULL),
(2, 'potential-partner.create', '2026-05-30 17:28:21', NULL),
(3, 'potential-partner.edit', '2026-05-30 17:28:21', NULL),
(4, 'potential-partner.delete', '2026-05-30 17:28:21', NULL),
(5, 'potential-partner.export', '2026-05-30 17:28:21', NULL),
(6, 'potential-partner.api', '2026-05-30 17:28:21', NULL),
(7, 'potential_partners.view', NULL, NULL),
(8, 'potential_partners.create', NULL, NULL),
(9, 'potential_partners.update', NULL, NULL),
(10, 'potential_partners.delete', NULL, NULL),
(11, 'potential_partners.export', NULL, NULL),
(12, 'potential_partners.api', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `potential_partners`
--

CREATE TABLE `potential_partners` (
  `id` bigint UNSIGNED NOT NULL,
  `nama_instansi` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bidang` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `kontak_person` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telepon` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `alamat` text COLLATE utf8mb4_unicode_ci,
  `status` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'aktif',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `potential_partners`
--

INSERT INTO `potential_partners` (`id`, `nama_instansi`, `bidang`, `kontak_person`, `email`, `telepon`, `alamat`, `status`, `created_at`, `updated_at`) VALUES
(1, 'PT Teknologi Nusantara', 'Industry', 'Updated Contact 1782125043003', 'budi@teknus.co.id', '08123456789', 'Jl. Sudirman No. 100, Jakarta Pusat', 'aktif', '2026-06-22 10:29:53', '2026-06-22 10:44:03'),
(2, 'Universitas Merdeka Indonesia', 'Academic', 'Dr. Sari Dewi', 'sari@unimerdeka.ac.id', '02188765432', 'Jl. Pahlawan No. 20, Surabaya', 'aktif', '2026-06-22 10:29:53', NULL),
(3, 'BRIN Pusat Riset AI', 'Research', 'Ir. Ahmad Fauzi M.T.', 'ahmad.fauzi@brin.go.id', '02134567890', 'Jl. Gatot Subroto Kav. 33, Jakarta Selatan', 'aktif', '2026-06-22 10:29:53', NULL),
(4, 'CV Makmur Jaya', 'Industry', 'Retno Wulandari', 'retno@makmurjaya.id', '08567891234', 'Jl. Raya Bogor KM 25, Depok', 'nonaktif', '2026-06-22 10:29:53', NULL),
(5, 'Test Company', 'Academic', 'John Doe', 'test@example.com', '081234567890', NULL, 'nonaktif', '2026-06-20 15:40:32', '2026-06-20 15:43:40'),
(6, 'Test Company 1782026376820', 'Industry', 'Ahmad Dani', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-21 07:19:37', NULL),
(7, 'Test Company 1782026378035', 'Industry', 'Ahmad Dani', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-21 07:19:38', NULL),
(8, 'Test Company 1782026382645', 'Industry', 'Updated Contact 1782026447776', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-21 07:19:43', '2026-06-21 07:20:48'),
(9, 'Test Company 1782026448217', 'Industry', 'Updated Contact 1782026450474', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-21 07:20:49', '2026-06-21 07:20:50'),
(10, 'Test Company 1782026451476', 'Industry', 'Updated Contact 1782026453805', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-21 07:20:52', '2026-06-21 07:20:54'),
(11, 'Test Company 1782026453436', 'Industry', 'Updated Contact 1782026597418', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-21 07:20:54', '2026-06-21 07:23:17'),
(12, 'Test Company 1782026596860', 'Industry', 'Updated Contact 1782026598831', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-21 07:23:17', '2026-06-21 07:23:19'),
(13, 'Test Company 1782026599185', 'Industry', 'Ahmad Dani', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-21 07:23:19', NULL),
(14, 'Test Company 1782026600478', 'Industry', 'Updated Contact 1782026623885', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-21 07:23:20', '2026-06-21 07:23:43'),
(15, 'Test Company 1782026623340', 'Industry', 'Updated Contact 1782026627466', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-21 07:23:44', '2026-06-21 07:23:47'),
(16, 'Test Company 1782026626653', 'Industry', 'Ahmad Dani', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-21 07:23:47', NULL),
(17, 'Test Company 1782026630963', 'Industry', 'Updated Contact 1782026661918', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-21 07:23:51', '2026-06-21 07:24:21'),
(18, 'Test Company 1782026664619', 'Industry', 'Updated Contact 1782026667433', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-21 07:24:25', '2026-06-21 07:24:27'),
(19, 'Test Company 1782026664783', 'Industry', 'Ahmad Dani', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-21 07:24:25', NULL),
(20, 'Test Company 1782027167379', 'Industry', 'Updated Contact 1782027169392', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-21 07:32:48', '2026-06-21 07:32:49'),
(21, 'Test Company 1782027203680', 'Industry', 'Updated Contact 1782027205282', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-21 07:33:23', '2026-06-21 07:33:25'),
(22, 'Test Company 1782027240766', 'Industry', 'Updated Contact 1782027242558', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-21 07:34:01', '2026-06-21 07:34:02'),
(23, 'Test Company 1782027316480', 'Industry', 'Updated Contact 1782027318418', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-21 07:35:17', '2026-06-21 07:35:18'),
(24, 'Test Company 1782027322923', 'Industry', 'Updated Contact 1782027324625', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-21 07:35:23', '2026-06-21 07:35:24'),
(25, 'Test Company 1782027329005', 'Industry', 'Updated Contact 1782027330836', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-21 07:35:29', '2026-06-21 07:35:31'),
(26, 'Test Company 1782125067761', 'Industry', 'Updated Contact 1782125070266', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-22 10:44:28', '2026-06-22 10:44:30'),
(27, 'Test Company 1782125077023', 'Industry', 'Updated Contact 1782125080040', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-22 10:44:37', '2026-06-22 10:44:40'),
(28, 'Test Company 1782125087082', 'Industry', 'Updated Contact 1782125090582', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-22 10:44:47', '2026-06-22 10:44:50'),
(29, 'Test Company 1782129469794', 'Industry', 'Updated Contact 1782129471883', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-22 11:57:50', '2026-06-22 11:57:51'),
(30, 'Test Company 1782129482128', 'Industry', 'Updated Contact 1782129483837', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-22 11:58:02', '2026-06-22 11:58:03'),
(31, 'Test Company 1782129495286', 'Industry', 'Updated Contact 1782129497262', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-22 11:58:15', '2026-06-22 11:58:17'),
(32, 'Test Company 1782129736688', 'Industry', 'Updated Contact 1782129738812', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-22 12:02:17', '2026-06-22 12:02:18'),
(33, 'Test Company 1782129743933', 'Industry', 'Updated Contact 1782129746033', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-22 12:02:24', '2026-06-22 12:02:26'),
(35, 'Test Company 1782208840513', 'Industry', 'Updated Contact 1782208842520', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-23 10:00:41', '2026-06-23 10:00:42'),
(36, 'Test Company 1782208847813', 'Industry', 'Updated Contact 1782208849805', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-23 10:00:47', '2026-06-23 10:00:49'),
(37, 'Test Company 1782208856030', 'Industry', 'Updated Contact 1782208857871', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-23 10:00:56', '2026-06-23 10:00:58'),
(38, 'Test Company 1782209330493', 'Industry', 'Updated Contact 1782209332440', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'nonaktif', '2026-06-23 10:08:51', '2026-06-23 10:08:52'),
(39, 'Test Company 1782209336746', 'Industry', 'Updated Contact 1782209338260', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-23 10:08:56', '2026-06-23 10:08:58'),
(40, 'Test Company 1782209342535', 'Industry', 'Updated Contact 1782209344356', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'aktif', '2026-06-23 10:09:02', '2026-06-23 10:11:32');

-- --------------------------------------------------------

--
-- Table structure for table `potential_partners_backup_1782124193798`
--

CREATE TABLE `potential_partners_backup_1782124193798` (
  `id` bigint UNSIGNED NOT NULL,
  `company_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contact_person` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` text COLLATE utf8mb4_unicode_ci,
  `partnership_type` enum('Academic','Industry','Research','Internship','Other') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `notes` text COLLATE utf8mb4_unicode_ci,
  `document_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `document_original_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `nama_instansi` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bidang` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `kontak_person` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telepon` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `alamat` text COLLATE utf8mb4_unicode_ci,
  `created_by` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `potential_partners_backup_1782124193798`
--

INSERT INTO `potential_partners_backup_1782124193798` (`id`, `company_name`, `contact_person`, `email`, `phone`, `address`, `partnership_type`, `description`, `status`, `notes`, `document_path`, `document_original_name`, `created_at`, `updated_at`, `nama_instansi`, `bidang`, `kontak_person`, `telepon`, `alamat`, `created_by`) VALUES
(1, 'PT Teknologi Nusantara', 'Budi Santoso', 'budi@teknus.co.id', '08123456789', 'Jl. Sudirman No. 100, Jakarta Pusat', 'Industry', 'Perusahaan teknologi bidang pengembangan perangkat lunak enterprise.', 'active', NULL, NULL, NULL, '2026-05-30 17:28:21', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2, 'Universitas Merdeka Indonesia', 'Dr. Sari Dewi', 'sari@unimerdeka.ac.id', '02188765432', 'Jl. Pahlawan No. 20, Surabaya', 'Academic', 'Kerjasama riset bersama dan program pertukaran mahasiswa antar institusi.', 'active', NULL, NULL, NULL, '2026-05-30 17:28:21', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(3, 'BRIN Pusat Riset AI', 'Ir. Ahmad Fauzi M.T.', 'ahmad.fauzi@brin.go.id', '02134567890', 'Jl. Gatot Subroto Kav. 33, Jakarta Selatan', 'Research', 'Kolaborasi riset nasional bidang kecerdasan buatan dan data sains.', 'active', NULL, NULL, NULL, '2026-05-30 17:28:21', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(4, 'CV Makmur Jaya', 'Retno Wulandari', 'retno@makmurjaya.id', '08567891234', 'Jl. Raya Bogor KM 25, Depok', 'Internship', 'Program magang mahasiswa di bidang manufaktur dan logistik.', 'inactive', NULL, NULL, NULL, '2026-05-30 17:28:21', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(6, 'Test Company', 'John Doe', 'test@example.com', '081234567890', NULL, 'Academic', NULL, 'inactive', NULL, NULL, NULL, '2026-06-20 15:40:32', '2026-06-20 15:43:40', NULL, NULL, NULL, NULL, NULL, NULL),
(7, 'Test Company 1782026376820', 'Ahmad Dani', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'Industry', 'Kemitraan magang industri', 'active', NULL, NULL, NULL, '2026-06-21 07:19:37', NULL, 'Test Company 1782026376820', 'Industry', 'Ahmad Dani', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', NULL),
(8, 'Test Company 1782026378035', 'Ahmad Dani', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'Industry', 'Kemitraan magang industri', 'active', NULL, NULL, NULL, '2026-06-21 07:19:38', NULL, 'Test Company 1782026378035', 'Industry', 'Ahmad Dani', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', NULL),
(9, 'Test Company 1782026382645', 'Updated Contact 1782026447776', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'Industry', 'Kemitraan magang industri', 'active', NULL, NULL, NULL, '2026-06-21 07:19:43', '2026-06-21 07:20:48', 'Test Company 1782026382645', 'Industry', 'Updated Contact 1782026447776', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', NULL),
(10, 'Test Company 1782026448217', 'Updated Contact 1782026450474', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'Industry', 'Kemitraan magang industri', 'active', NULL, NULL, NULL, '2026-06-21 07:20:49', '2026-06-21 07:20:50', 'Test Company 1782026448217', 'Industry', 'Updated Contact 1782026450474', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', NULL),
(11, 'Test Company 1782026451476', 'Updated Contact 1782026453805', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'Industry', 'Kemitraan magang industri', 'active', NULL, NULL, NULL, '2026-06-21 07:20:52', '2026-06-21 07:20:54', 'Test Company 1782026451476', 'Industry', 'Updated Contact 1782026453805', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', NULL),
(12, 'Test Company 1782026453436', 'Updated Contact 1782026597418', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'Industry', 'Kemitraan magang industri', 'active', NULL, NULL, NULL, '2026-06-21 07:20:54', '2026-06-21 07:23:17', 'Test Company 1782026453436', 'Industry', 'Updated Contact 1782026597418', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', NULL),
(13, 'Test Company 1782026596860', 'Updated Contact 1782026598831', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'Industry', 'Kemitraan magang industri', 'active', NULL, NULL, NULL, '2026-06-21 07:23:17', '2026-06-21 07:23:19', 'Test Company 1782026596860', 'Industry', 'Updated Contact 1782026598831', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', NULL),
(14, 'Test Company 1782026599185', 'Ahmad Dani', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'Industry', 'Kemitraan magang industri', 'active', NULL, NULL, NULL, '2026-06-21 07:23:19', NULL, 'Test Company 1782026599185', 'Industry', 'Ahmad Dani', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', NULL),
(15, 'Test Company 1782026600478', 'Updated Contact 1782026623885', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'Industry', 'Kemitraan magang industri', 'active', NULL, NULL, NULL, '2026-06-21 07:23:20', '2026-06-21 07:23:43', 'Test Company 1782026600478', 'Industry', 'Updated Contact 1782026623885', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', NULL),
(16, 'Test Company 1782026623340', 'Updated Contact 1782026627466', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'Industry', 'Kemitraan magang industri', 'active', NULL, NULL, NULL, '2026-06-21 07:23:44', '2026-06-21 07:23:47', 'Test Company 1782026623340', 'Industry', 'Updated Contact 1782026627466', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', NULL),
(17, 'Test Company 1782026626653', 'Ahmad Dani', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'Industry', 'Kemitraan magang industri', 'active', NULL, NULL, NULL, '2026-06-21 07:23:47', NULL, 'Test Company 1782026626653', 'Industry', 'Ahmad Dani', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', NULL),
(18, 'Test Company 1782026630963', 'Updated Contact 1782026661918', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'Industry', 'Kemitraan magang industri', 'active', NULL, NULL, NULL, '2026-06-21 07:23:51', '2026-06-21 07:24:21', 'Test Company 1782026630963', 'Industry', 'Updated Contact 1782026661918', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', NULL),
(19, 'Test Company 1782026664619', 'Updated Contact 1782026667433', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'Industry', 'Kemitraan magang industri', 'active', NULL, NULL, NULL, '2026-06-21 07:24:25', '2026-06-21 07:24:27', 'Test Company 1782026664619', 'Industry', 'Updated Contact 1782026667433', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', NULL),
(20, 'Test Company 1782026664783', 'Ahmad Dani', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'Industry', 'Kemitraan magang industri', 'active', NULL, NULL, NULL, '2026-06-21 07:24:25', NULL, 'Test Company 1782026664783', 'Industry', 'Ahmad Dani', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', NULL),
(21, 'Test Company 1782027167379', 'Updated Contact 1782027169392', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'Industry', 'Kemitraan magang industri', 'active', NULL, NULL, NULL, '2026-06-21 07:32:48', '2026-06-21 07:32:49', 'Test Company 1782027167379', 'Industry', 'Updated Contact 1782027169392', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', NULL),
(22, 'Test Company 1782027203680', 'Updated Contact 1782027205282', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'Industry', 'Kemitraan magang industri', 'active', NULL, NULL, NULL, '2026-06-21 07:33:23', '2026-06-21 07:33:25', 'Test Company 1782027203680', 'Industry', 'Updated Contact 1782027205282', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', NULL),
(23, 'Test Company 1782027240766', 'Updated Contact 1782027242558', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'Industry', 'Kemitraan magang industri', 'active', NULL, NULL, NULL, '2026-06-21 07:34:01', '2026-06-21 07:34:02', 'Test Company 1782027240766', 'Industry', 'Updated Contact 1782027242558', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', NULL),
(24, 'Test Company 1782027316480', 'Updated Contact 1782027318418', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'Industry', 'Kemitraan magang industri', 'active', NULL, NULL, NULL, '2026-06-21 07:35:17', '2026-06-21 07:35:18', 'Test Company 1782027316480', 'Industry', 'Updated Contact 1782027318418', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', NULL),
(25, 'Test Company 1782027322923', 'Updated Contact 1782027324625', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'Industry', 'Kemitraan magang industri', 'active', NULL, NULL, NULL, '2026-06-21 07:35:23', '2026-06-21 07:35:24', 'Test Company 1782027322923', 'Industry', 'Updated Contact 1782027324625', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', NULL),
(26, 'Test Company 1782027329005', 'Updated Contact 1782027330836', 'dani@testcompany.com', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', 'Industry', 'Kemitraan magang industri', 'active', NULL, NULL, NULL, '2026-06-21 07:35:29', '2026-06-21 07:35:31', 'Test Company 1782027329005', 'Industry', 'Updated Contact 1782027330836', '+628123456789', 'Jl. Sudirman No. 45 Jakarta', NULL);

--
-- Triggers `potential_partners_backup_1782124193798`
--
DELIMITER $$
CREATE TRIGGER `before_insert_potential_partners` BEFORE INSERT ON `potential_partners_backup_1782124193798` FOR EACH ROW BEGIN
        IF NEW.company_name IS NOT NULL AND NEW.nama_instansi IS NULL THEN
          SET NEW.nama_instansi = NEW.company_name;
        ELSEIF NEW.nama_instansi IS NOT NULL AND NEW.company_name IS NULL THEN
          SET NEW.company_name = NEW.nama_instansi;
        END IF;

        IF NEW.contact_person IS NOT NULL AND NEW.kontak_person IS NULL THEN
          SET NEW.kontak_person = NEW.contact_person;
        ELSEIF NEW.kontak_person IS NOT NULL AND NEW.contact_person IS NULL THEN
          SET NEW.contact_person = NEW.kontak_person;
        END IF;

        IF NEW.phone IS NOT NULL AND NEW.telepon IS NULL THEN
          SET NEW.telepon = NEW.phone;
        ELSEIF NEW.telepon IS NOT NULL AND NEW.phone IS NULL THEN
          SET NEW.phone = NEW.telepon;
        END IF;

        IF NEW.address IS NOT NULL AND NEW.alamat IS NULL THEN
          SET NEW.alamat = NEW.address;
        ELSEIF NEW.alamat IS NOT NULL AND NEW.address IS NULL THEN
          SET NEW.address = NEW.alamat;
        END IF;

        IF NEW.partnership_type IS NOT NULL AND NEW.bidang IS NULL THEN
          SET NEW.bidang = NEW.partnership_type;
        ELSEIF NEW.bidang IS NOT NULL AND NEW.partnership_type IS NULL THEN
          IF NEW.bidang IN ('Academic', 'Industry', 'Research', 'Internship', 'Other') THEN
            SET NEW.partnership_type = NEW.bidang;
          ELSE
            SET NEW.partnership_type = 'Other';
          END IF;
        END IF;

        IF NEW.status = 'aktif' THEN
          SET NEW.status = 'active';
        ELSEIF NEW.status = 'nonaktif' THEN
          SET NEW.status = 'inactive';
        END IF;
      END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `publications`
--

CREATE TABLE `publications` (
  `id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `publication_date` date NOT NULL,
  `doi` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `abstract` text COLLATE utf8mb4_unicode_ci,
  `research_id` bigint UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `publication_authors`
--

CREATE TABLE `publication_authors` (
  `id` bigint UNSIGNED NOT NULL,
  `publication_id` bigint UNSIGNED NOT NULL,
  `lecturer_id` bigint UNSIGNED NOT NULL,
  `author_order` int NOT NULL,
  `is_corresponding` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `research`
--

CREATE TABLE `research` (
  `id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `funding_source` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `budget` decimal(12,2) DEFAULT NULL,
  `status` enum('proposed','ongoing','completed') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `research_members`
--

CREATE TABLE `research_members` (
  `id` bigint UNSIGNED NOT NULL,
  `research_id` bigint UNSIGNED NOT NULL,
  `lecturer_id` bigint UNSIGNED NOT NULL,
  `role` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `created_at`, `updated_at`) VALUES
(1, 'admin', '2026-05-30 17:28:21', NULL),
(2, 'staff', '2026-05-30 17:28:21', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `role_has_permissions`
--

CREATE TABLE `role_has_permissions` (
  `role_id` bigint UNSIGNED NOT NULL,
  `permission_id` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `role_has_permissions`
--

INSERT INTO `role_has_permissions` (`role_id`, `permission_id`) VALUES
(1, 1),
(2, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(2, 6),
(1, 7),
(1, 8),
(1, 9),
(1, 10),
(1, 11),
(1, 12);

-- --------------------------------------------------------

--
-- Table structure for table `rooms`
--

CREATE TABLE `rooms` (
  `id` bigint UNSIGNED NOT NULL,
  `asset_id` bigint UNSIGNED NOT NULL,
  `building_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `floor` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `capacity` int NOT NULL,
  `is_public` tinyint(1) NOT NULL DEFAULT '0',
  `responsible_employee_id` bigint UNSIGNED NOT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `room_loans`
--

CREATE TABLE `room_loans` (
  `id` bigint UNSIGNED NOT NULL,
  `room_id` bigint UNSIGNED NOT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `purpose` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('requested','approved','rejected','completed') COLLATE utf8mb4_unicode_ci NOT NULL,
  `approved_by` bigint UNSIGNED DEFAULT NULL,
  `approved_by_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `room_maintenance_requests`
--

CREATE TABLE `room_maintenance_requests` (
  `id` bigint UNSIGNED NOT NULL,
  `room_id` bigint UNSIGNED NOT NULL,
  `reported_by` bigint UNSIGNED NOT NULL,
  `issue_description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('reported','in_progress','resolved') COLLATE utf8mb4_unicode_ci NOT NULL,
  `reported_at` timestamp NOT NULL,
  `resolved_at` timestamp NULL DEFAULT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `room_maintenance_request_log`
--

CREATE TABLE `room_maintenance_request_log` (
  `id` bigint NOT NULL,
  `room_maintenance_request_id` bigint UNSIGNED DEFAULT NULL,
  `log` varchar(45) DEFAULT NULL,
  `logged_by` bigint UNSIGNED DEFAULT NULL,
  `logged_at` datetime DEFAULT NULL,
  `log_file` varchar(255) DEFAULT NULL,
  `verified_by` bigint UNSIGNED DEFAULT NULL,
  `verified_at` datetime DEFAULT NULL,
  `verification_file` varchar(255) DEFAULT NULL,
  `description` text,
  `status` int DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `session_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `expires` int UNSIGNED NOT NULL,
  `data` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`session_id`, `expires`, `data`) VALUES
('-eg8WfsPed9INqKeEYh_o08MDSQlTlXZ', 1782211492, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:44:51.982Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('-qauGrVvBZa_HSCsr1hYjZ6Fg_xXPQ4_', 1782211493, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:44:53.198Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('08Nv_nGqI8Xp8MQp_O48XeqRNCjasodY', 1782295250, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:00:49.909Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('0GTsEpVPTLyJdnUrgxEMfXUb4m6-Y7G_', 1782216142, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T12:02:21.494Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('0PEh1I_uhkDeNB4VNbqh-kYj2-MP1Mzr', 1782216144, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T12:02:24.099Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('1_7f6fwVlNxhEhAsZwJ1aqA_S59zvA7o', 1782211065, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:37:44.460Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('1eQL1xcq4P2f5lyw3MupOu6QU3jWyMnh', 1782211368, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:42:48.373Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('1ywEt4ZMPjMSfeEnXz12hxO8yD9on-tF', 1782215894, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T11:58:13.608Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('2IAWHF0qt_ZxVpsL3LAXcTSuaMwC9bqo', 1782210819, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:33:38.766Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('2blcEJvkDlVjjsGlHUNFUUVW1JYN-9Cl', 1782210887, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:34:47.210Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('2mdS2WOwewX6mHPTwPUBlB24dAfwXiTV', 1782216157, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T12:02:37.166Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('3LuNGkTGnGvSfP2a4lm1muTYcN2qD19X', 1782211098, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:38:17.662Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('3LvPqT-78MSiI0u8AzzmDTVdfI7ZuWnZ', 1782295259, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:00:58.813Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('3ajUsUBW2vNpLxta1xpRmXlF5wPXTsgl', 1782211470, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:44:30.367Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('3zF8j8HAhyhtWTWK3hgi5wOibg-lg6Mc', 1782211411, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:43:30.686Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('4n1t925uCm5c4ZhEDFYPWORF9VcC5vCf', 1782216145, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T12:02:24.826Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('5B-zZ_fs-FUzSfBJwnCKLljrPz9A89ZZ', 1782211020, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:37:00.167Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('5FNScK_dDE6V3Q-XY3AGPkfzo73NLDVM', 1782216154, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T12:02:33.820Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{\"success\":\"Data \\\"Test Company 1782129751682\\\" berhasil diperbarui.\"}}'),
('5I14-TilsH102iedpIUcf8oebEsoaUPb', 1782211480, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:44:40.160Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('6DYwaogPBYfsPSgSFTqeUFGeTd-84puR', 1782295738, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:08:57.453Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('6vqsvIMRQHJb5s_OrO4nhFCNeTfn6p4C', 1782211471, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:44:30.965Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('7LvPkYYe23gOlWJ35Lrz-LfjwazmVtPG', 1782295734, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:08:53.890Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('7NB0CWyyPgmM1yLG2jXFtUgT9T5Zk447', 1782211405, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:43:25.340Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('7bJyD0hmuY999ioopJxZrqc8W-6GWVcG', 1782215899, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T11:58:18.853Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('7f0EtRd3sVHqCkUBKIpAswS0CmDO5qRX', 1782216154, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T12:02:34.366Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('8amHtwtpCmzGWpFVcc28flBgRk9Sio_Y', 1782295741, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:09:01.053Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('8pBSWRo6e6Ti_DtMb0ALMCvAgOF4Zsj1', 1782295243, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:00:42.582Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{\"success\":\"Data \\\"Test Company 1782208840513\\\" berhasil diperbarui.\"}}'),
('96UtErJ8l74i-MDmD8LDgYXmmCAMeEX4', 1782215883, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T11:58:02.920Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('9xK3iUZl04ugtSOcTcexnAK_uEyCrvsU', 1782210781, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:33:00.488Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('Au5tdEtQW-3K1461OGQDUydKsSUXIzwR', 1782216149, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T12:02:28.665Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('AvbD9Erm1NrBiDvQpJ67a5E1OBrwQWYp', 1782210889, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:34:49.233Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('BR4ILrexSq5f9QupPCnH6JCdeBlDLMFB', 1782215898, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T11:58:17.544Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{\"success\":\"Data \\\"Test Company 1782129495286\\\" berhasil diperbarui.\"}}'),
('Bh4AwKOajidYCPX0MvaozzocK8zNeFVs', 1782215872, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T11:57:51.956Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{\"success\":\"Data \\\"Test Company 1782129469794\\\" berhasil diperbarui.\"}}'),
('BmOLFJ5YkRt771kh2U0jbXPkQZa9zvMj', 1782216156, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T12:02:35.807Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('CYJT56qz6JXDzPJe2MDzt1FVxhiFeJpb', 1782295261, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:01:00.032Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('C_eMm5rTPkbHLlMRlka-uczmpJYMmHue', 1782211470, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:44:29.422Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('D26jCKlkYpO0r7ymH-tsNl4215E1fDD6', 1782295733, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:08:52.905Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('D47nuScLYzIpiQo4i6Qnuq1rWvadsnpp', 1782216139, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T12:02:18.899Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{\"success\":\"Data \\\"Test Company 1782129736688\\\" berhasil diperbarui.\"}}'),
('D8R2pWelvNoHpEnfdxIJAMpVnmd98DCV', 1782295261, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:01:01.209Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('D9npdKA9kHn1VK9DTL24Khqu9cMY2NsE', 1782216155, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T12:02:35.076Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('DI6SqwuAutFJNV0WGuWPCsIYv7YMouNe', 1782211109, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:38:27.965Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('DitI9uodOF3oVX5BxULdp8DMR3-xwVUE', 1782210715, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:31:54.653Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('DzRu2ya81_Inr2ACwlm8DAk6ZzxByNKJ', 1782211482, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:44:42.032Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('E66PP89fE6iJvwRHwwHAZcn0pA9FWtW6', 1782210822, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:33:41.345Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('EENweGc6bDgAsDIXtdeBS9I6q8cL0CcR', 1782215898, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T11:58:18.196Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('EVs1R3JniYzjDEcfGMlR5YSC4pMNCwQq', 1782295737, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:08:56.881Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('ElIHAlFyh8rVVNHnsB2c7u4bBwvGpGFq', 1782215871, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T11:57:51.253Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('EprjNgCKw9tvxmvNMaRxVUC85a1_Pyg_', 1782295739, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:08:58.905Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('Ewdt598V8Q8QGbJYTRExfEy68-5YHqnP', 1782295740, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:09:00.139Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('FNQVQCPKw6Z60bDLQr0dffDHEOWTxzIB', 1782295251, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:00:50.829Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('FbU9cZuhLQ81HeIYD7jjl1CsMOpZMzvE', 1782295244, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:00:43.498Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('G4vVtlgvp3c_jkyBsZQBZaiFp98EXPaX', 1782211481, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:44:41.066Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('G8iKm6KcQqjNYeH3h6Bj3PkBLPze_GtM', 1782210885, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:34:45.251Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('GP9RsOiS0FI7xUi353NbuEMdJeEDCiUc', 1782295743, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:09:02.926Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{\"success\":\"Data \\\"Test Company 1782209342535\\\" berhasil ditambahkan.\"}}'),
('GUm8KS2fud_MNFVmiw2OJ0yBn6U0Cge8', 1782216138, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T12:02:18.175Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('GiODi5Vhu4EEeTn3HCqIxzHfbmNt_Ssf', 1782215896, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T11:58:16.419Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('Hdn21iN0WLC8vffAo6TZB73BV7eDHTds', 1782211364, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:42:44.104Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('ISdMa_rD6doTjVkdMcgPyefY5IOfxTij', 1782211489, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:44:48.947Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('IUhAzZQ6gl7LlBagv3cmyjNziU51lWaI', 1782295746, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:09:05.897Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('IwRx-omO3NR8VoHqfD2ufOsimiUQxKJp', 1782296187, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:14:10.624Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('J8rpp6ivF_1je4cT_JKVZsbAqC2jkKb3', 1782211367, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:42:46.349Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('JN-gQd7_8qQd_tDi519zZ5KDH4SPRg0E', 1782295245, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:00:44.343Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('K8864rBNnwNUQSEapRPfcH2PcOQQQug8', 1782210815, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:33:34.918Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('KGOSYtj9UdlkVhknQUZ96gM3dnspIH9u', 1782211155, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:39:14.556Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('KNweJwAaLd2YxilcKKygBFxsNmJmSGaI', 1782211405, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:43:24.562Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('KlldFm2Cr1_kTvrtLTswRr094bRsPAMM', 1782211488, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:44:47.889Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('LPvkBBZlr_xfUkH8MyjniAkwQhlxcMKf', 1782211496, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:44:54.296Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('MXZc6Nr5nSP6eYd7xJ02WLCvV3bxCzCs', 1782295241, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:00:41.482Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{\"success\":\"Data \\\"Test Company 1782208840513\\\" berhasil ditambahkan.\"}}'),
('N4yegEQtWQ61Fwk5T9qS1OO1wlYF49xB', 1782215886, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T11:58:05.914Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('N5cAOtJpz62vNB9h_D7lRKDyS4Jd6EYk', 1782216146, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T12:02:26.138Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('NI68lkPW3Q1bivVp5eFLJu3LxAZ5TLVU', 1782215873, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T11:57:52.826Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('Nfq1J2Bd7Hoomt7PR-L6uSDs9ijT__ow', 1782211497, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:44:56.623Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('O0NUJf46wDPpR4EmzZ_LDnsrNbYFEJsV', 1782210888, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:34:48.086Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('OEdonK3gKZOMfeCdesfJ6dpf1T0_esrz', 1782211473, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:44:32.510Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('OgTZBta6mObhbRSXo3OF_dY9wOWQIBGa', 1782295734, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:08:53.313Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('Qmmkr0oiSt2Lp4nXH-bwEjgaLuVP55M3', 1782295258, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:00:58.194Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{\"success\":\"Data \\\"Test Company 1782208856030\\\" berhasil diperbarui.\"}}'),
('Qq5aYgjh17HidQTNn3iKHsGCOmsVyEt4', 1782295735, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:08:54.538Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('R4RO37qFA9x2CxNoUvYoeJO6MldnV-eK', 1782215882, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T11:58:02.287Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('S3x0iIqONgZV9Qva7Jcf4LELQSpjnenN', 1782211110, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:38:29.474Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('S5S0IJHp9jcT0cJmkncefCHouuZiiX9F', 1782211442, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:44:01.387Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('SNBo3OX-sVBuWhsJurF4V5dD-xfQcgrl', 1782211474, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:44:33.559Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('Thxg2-Z17PyfUok5O6YKT5IadspH3rxW', 1782211366, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:42:45.718Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('UD0EJhiHjC9sA5KjcaQAKgy-cKctIb_G', 1782211469, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:44:28.822Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('U_U4ssF3KVn9V3-SimXUntUhnnenV6XW', 1782216150, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T12:02:29.972Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('V19tB-yfksZBP_cJkOaU-0lMNHQDNGLr', 1782211477, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:44:37.304Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('V9kLWuCoX_wHAZgYkGbbJJaXw_RW6qox', 1782211406, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:43:26.204Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('VyHTFUvundbFFLuSTfHAPQROJy35Rgr9', 1782210777, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:32:56.649Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('X5k82QkI5Yh1yYiwnE4ZaMaj0Hb43Hvq', 1782210855, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:34:14.690Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('Y9m3ybPBp4OzJ0RZtkkDSMRG5O7unf8s', 1782210813, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:33:32.480Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('YNF8yfQYc66-XVOlkVHgaPrxeazFDsH7', 1782211372, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:42:51.536Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('YWC3cknG1bKj7AG8X7KD_Cy8qMIiC9k7', 1782211152, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:39:11.786Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('Y_WwbFRyYasNhrqVtumjHSsBlOPsGuJ8', 1782211484, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:44:43.040Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('YmfwJhuf-ESOFWNytHv-GxpVSXfN7-TV', 1782215900, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T11:58:19.526Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('YmtHX8g6h-fj9vGBrSHaoBcICL8MrxAI', 1782211449, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:44:08.507Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('ZGuVCLu24M7i__UcdqnOgAt-c4xq2J07', 1782295748, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:09:07.737Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('ZOazvhF-P216r6CmYUAdY8GuqqPq1lUV', 1782211112, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:38:31.612Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('_KEpy4bDDzgBcw_MI7Teos9Wz2znn11w', 1782211060, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:37:39.239Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('_gIlTFhHHsM2goB163-3bgDoUtFKO3Pi', 1782211408, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:43:27.117Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('aTtw0UKG8vkkLyPs1Rz67s2MuZ3kdABW', 1782295252, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:00:52.036Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('atRjmOlqvhcEjkwhxMvwgT2bYTJtiYRD', 1782211446, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:44:05.520Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('awPKEJ43ZILto9Gm5oYRMwUGOWcngTJI', 1782216153, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T12:02:32.613Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('b-a4WSXBBAUdMUvr9zzIJaT7Mlr_E_Iz', 1782295257, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:00:56.984Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('bA1fbYFDtltcOlX8wcX3XUCNCSOfxCqi', 1782211142, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:39:02.169Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('bcmM3JGa105g8e8Yx9hY8CWmJfdm_4sX', 1782211448, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:44:06.535Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('c0S0l-dXn8xVRDyzzwy4efVQf5GCu5yo', 1782211491, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:44:50.988Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('cPqzLWumPFBaiKxRq0TGOr8nzSF5lrj0', 1782216140, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T12:02:19.924Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('c_wqqxhSAXhRSxZk3dXoUZCxJhW_pHjN', 1782210890, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:34:50.154Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('cagbV2qYcY2261DgGbC_KYWeJHprWno6', 1782211151, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:39:10.659Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('ceJbbdffFXD2Jon8hIR9goeE3EKJy32Z', 1782295245, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:00:44.983Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('dEIr1y69RtKgThRjxt4EiWat8ypyWRVt', 1782211479, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:44:38.684Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('dLTrvnn5mKyge_Ms68AFMuU9qfzAVvyP', 1782211409, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:43:28.409Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('dLuXguwiT5h6SO4ngTVb6CQjFFdUSvfg', 1782211144, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:39:04.033Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{\"errors\":[\"Gagal memperbarui data: Can\'t update table \'partner_potentials\' in stored function/trigger because it is already used by statement which invoked this stored function/trigger.\"]}}'),
('dTaHEfkUnpWPGnBED6eFUS1v3tSHCtPq', 1782211061, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:37:41.348Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('dqQgGhwbsRbv8MddsIETfCeliwpci_Jp', 1782295745, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:09:05.256Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('eeu8drDTktosM1M_XStgxvoPGAtn6Yc5', 1782216138, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T12:02:17.687Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('eweoqyraS1gaHaVSuCct4cfp0NmgeTZL', 1782215896, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T11:58:15.688Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{\"success\":\"Data \\\"Test Company 1782129495286\\\" berhasil ditambahkan.\"}}'),
('fIXNd2ZYDffUSUZm1aN9OUMlQ53e5q_P', 1782216148, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T12:02:27.822Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('fVvKX9MIK5xC9hO-23GlcZPXOCWPqerW', 1782211107, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:38:27.094Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('fcHL3BhxfSAsEtd85qHw77UKHTRQ-P7-', 1782295732, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:08:51.502Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('ffcH-Bnx7lTB2UeV2A9seIIaOUZJmDae', 1782210817, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:33:36.642Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('fmeLoI7IjpWrD97z8BokvUpo26b1N31p', 1782295248, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:00:47.974Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('gbpvuxj1bUozKu2MyML_CGbN9k6NSAta', 1782211365, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:42:45.157Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('h-pjsLdv66NOP0Z7uf5d446BunmOIgMr', 1782211472, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:44:31.580Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('hBw_UKDktRlpjjk196JManaV4rP-9UdN', 1782211368, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:42:47.261Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('hCcS8gKkfOSXHalxM0FsUyusQsy43Zbz', 1782215874, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T11:57:53.402Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('hDbt6JmOVWFWOsRTYKNC_X9M7VwuyHK-', 1782211051, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:37:30.890Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('hZKyFHT-1WAnAGPJcBbc0W361XKkhW_p', 1782295243, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:00:43.000Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('hkrT8Utr-XV3hixoxQ-52VD4Ye6G60Rh', 1782210744, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:32:23.868Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('hmR-RXOvA-zJsNhtOr5EITC6hzd9ZBRu', 1782215885, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T11:58:05.254Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('iEvTQ9-18dbCr0ljYlgA6zWMra8I6GZd', 1782210921, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:35:20.946Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('iRqBLhlrI2hbyn6NwK-KnVuC2tYDhUkN', 1782211334, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:42:13.440Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('ifO0O3WsFsECx5lGdCYbmzZSp1iCqKgX', 1782210746, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:32:25.514Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('j0RJejA3M7WhSsw711-GghY305XJy-QF', 1782295732, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:08:51.901Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('jBKb-iStKdOqSZRyw965OuKN2WUNZvXK', 1782211444, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:44:04.402Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('jeMO6pobUmViStH2D2EDbK6AdT8w6mPC', 1782215885, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T11:58:04.577Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('kHsOqAYEbQeXB9lfGoF-bjP1e8Ol_oCO', 1782211058, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:37:38.405Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('kZYOFwrXJkPKB0NU_QNR35JAHiUKKCjM', 1782295252, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:00:51.437Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('lCwqdnyyZfk8sB9lZWBOu14q06XPJj-z', 1782210745, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:32:24.494Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('lJV2Dv4CtBKRkvGRU_6JBCpZynNHok0L', 1782295733, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:08:52.502Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{\"success\":\"Data \\\"Test Company 1782209330493\\\" berhasil diperbarui.\"}}'),
('leArn8GynGHSfauO2zd1wmBjAdTfsxj7', 1782211485, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:44:44.620Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('lezKvBUh49nNm2z8NqFi57C2ldeHs11g', 1782211096, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:38:16.244Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('mf9wd19O2s3biWwCTbtWSa4A-n7auNeM', 1782215906, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T11:58:26.369Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('n4xBZ_3VUDDzaNYAd5djOVxUhIUQjJ2q', 1782215872, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T11:57:52.390Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('nDR7PSRnph9qbiGSkRVGpwClfZ5TCO34', 1782215884, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T11:58:03.923Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('nKnq3lrHCsDnuCL4yJ8pNiQhlCrT1Rzh', 1782211052, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:37:31.821Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('nN5MiSm7QJqkjFHWi5xnpDGTe0zJO3bR', 1782295260, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:00:59.425Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('nbgBBrzA4Jk4mjCiLJtTkG82l4aLxKXg', 1782210743, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:32:23.309Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('nxmYYyAn4a6i-jVt90iKDRtNdzWdDFCn', 1782215871, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T11:57:50.789Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{\"success\":\"Data \\\"Test Company 1782129469794\\\" berhasil ditambahkan.\"}}'),
('nzUGmvPW4NHWQxQARCTMeNF2Hns4gpVs', 1782215880, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T11:57:59.586Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('o1FCYNWyt77duFpFuQvdELLZzNbfgjqx', 1782216147, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T12:02:26.851Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('o_lGM4B8jwj2rxL08dEws-lEGukG4QQ5', 1782295744, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:09:03.488Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('oivjz9G78H3DTVrwwPtagS0FYzWbsiKa', 1782216141, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T12:02:20.675Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('pAmcYOiab4z4Tkx7a32ICAkuIwfRiIB_', 1782295249, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:00:48.603Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('qpJ_82Cl4T4QbHwqLDhaDzem4-j9qD-t', 1782295745, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:09:04.683Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('qpYYvvInMtMxGEYCUFsrCB6AHPmR1iKz', 1782211154, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:39:12.787Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('r-u9bG_AMAaQZlexfzJ-oE86fjLdhn3r', 1782216152, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T12:02:32.082Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{\"success\":\"Data \\\"Test Company 1782129751682\\\" berhasil ditambahkan.\"}}'),
('sxsvi-qoPQb4ft8yEMIxkPUgr_GyVeJ8', 1782295747, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:09:06.525Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('uFoFVy_QgpCHxqmFUG5MUMaagXDd7VfS', 1782295253, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:00:52.979Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('ulD1NSkc6liQqwBBL9MJUE0kqFBFVyZP', 1782211106, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:38:26.090Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('v4HX7jItqamj5oqlGxg7cxX0hBpYEfKX', 1782216139, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T12:02:19.382Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('vBlVjKHK4dm9YWv-y0H3bE-XqSJJYDRt', 1782210853, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:34:12.591Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('wS-6OkmHT3dWOtmiDdce4jB29xlY2cNv', 1782211443, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:44:03.368Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('wXaqc28VxFZD0nfRQRafAXRI3AGeC9RC', 1782295740, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:08:59.539Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('xL12dXNErfrGe14UcA4g6Dp16PqL2dZF', 1782295242, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:00:41.917Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('yZwM0pza_2bNa5Wd1npNcCow8wapf9EQ', 1782210742, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:32:22.327Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('yqLxrSBqSj3IuzfXBeM-0vkc7H0R1S_5', 1782295738, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:08:58.331Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('ytr4w7bHWD9vaWbZUjgaW8nLEqD6gXFw', 1782211403, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:43:23.099Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('zHwkccZx-8kBg-9nFXXvGO67DdeP87Xl', 1782211061, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-23T10:37:40.202Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{}}'),
('zUuzsVlqwvquEcIuYK8qSmZ4sRby9Lki', 1782295256, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2026-06-24T10:00:56.375Z\",\"httpOnly\":true,\"path\":\"/\"},\"userId\":1,\"username\":\"admin\",\"user\":{\"id\":1,\"name\":\"Administrator\",\"role\":\"admin\"},\"flash\":{\"success\":\"Data \\\"Test Company 1782208856030\\\" berhasil ditambahkan.\"}}');

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

CREATE TABLE `staff` (
  `id` bigint UNSIGNED NOT NULL,
  `position` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `department` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `staff_nomenclature_histories`
--

CREATE TABLE `staff_nomenclature_histories` (
  `id` bigint UNSIGNED NOT NULL,
  `staff_id` bigint UNSIGNED NOT NULL,
  `nomenclature_class_id` bigint UNSIGNED NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `nomenclature_classification_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `structural_positions`
--

CREATE TABLE `structural_positions` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `parent_id` bigint UNSIGNED DEFAULT NULL,
  `grade` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `qualification` text COLLATE utf8mb4_unicode_ci,
  `description` text COLLATE utf8mb4_unicode_ci,
  `structural_position_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `structural_position_histories`
--

CREATE TABLE `structural_position_histories` (
  `id` bigint UNSIGNED NOT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `structural_position_id` bigint UNSIGNED NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `decree_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `decree_date` date DEFAULT NULL,
  `document` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `regno` varchar(255) NOT NULL,
  `birth_date` datetime DEFAULT NULL,
  `birth_place` varchar(45) DEFAULT NULL,
  `gender` int DEFAULT NULL,
  `religion` int DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `campus_email` varchar(255) DEFAULT NULL,
  `phone_no` varchar(45) DEFAULT NULL,
  `home_address` varchar(255) DEFAULT NULL,
  `home_town` varchar(45) DEFAULT NULL,
  `home_province` varchar(45) DEFAULT NULL,
  `home_postalcode` varchar(5) DEFAULT NULL,
  `current_address` varchar(255) DEFAULT NULL,
  `current_town` varchar(45) DEFAULT NULL,
  `current_province` varchar(45) DEFAULT NULL,
  `current_postalcode` varchar(5) DEFAULT NULL,
  `department_id` bigint UNSIGNED DEFAULT NULL,
  `year` int DEFAULT NULL,
  `status` int DEFAULT NULL,
  `advisor_id` bigint UNSIGNED DEFAULT NULL,
  `citizenship` varchar(45) DEFAULT NULL,
  `photo` varchar(45) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `student_requests`
--

CREATE TABLE `student_requests` (
  `id` bigint UNSIGNED NOT NULL,
  `request_nunmber` varchar(45) DEFAULT NULL,
  `request_type` varchar(45) DEFAULT NULL,
  `title` varchar(45) DEFAULT NULL,
  `description` varchar(45) DEFAULT NULL,
  `status` int DEFAULT NULL,
  `requested_by` bigint UNSIGNED DEFAULT NULL,
  `requested_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `student_request_active_references`
--

CREATE TABLE `student_request_active_references` (
  `id` bigint UNSIGNED NOT NULL,
  `student_requests_id` bigint UNSIGNED NOT NULL,
  `student_study_plan_file` varchar(45) DEFAULT NULL,
  `parent_decree_file` varchar(45) DEFAULT NULL,
  `checked_by` bigint UNSIGNED NOT NULL,
  `checked_at` datetime DEFAULT NULL,
  `check_reason` text,
  `signed_by` bigint UNSIGNED NOT NULL,
  `signed_at` datetime DEFAULT NULL,
  `sign_reason` text,
  `status` varchar(45) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `surveys`
--

CREATE TABLE `surveys` (
  `id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '0',
  `created_by` bigint UNSIGNED NOT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `survey_answers`
--

CREATE TABLE `survey_answers` (
  `id` bigint UNSIGNED NOT NULL,
  `survey_response_id` bigint UNSIGNED NOT NULL,
  `survey_question_id` bigint UNSIGNED NOT NULL,
  `answer_text` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `survey_answer_options`
--

CREATE TABLE `survey_answer_options` (
  `id` bigint UNSIGNED NOT NULL,
  `survey_answer_id` bigint UNSIGNED NOT NULL,
  `survey_question_option_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `survey_invitations`
--

CREATE TABLE `survey_invitations` (
  `id` bigint UNSIGNED NOT NULL,
  `survey_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pin` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_used` tinyint(1) NOT NULL DEFAULT '0',
  `used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `survey_questions`
--

CREATE TABLE `survey_questions` (
  `id` bigint UNSIGNED NOT NULL,
  `question_text` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('single_choice','multiple_choice','short_answer') COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `survey_question_assignments`
--

CREATE TABLE `survey_question_assignments` (
  `id` bigint UNSIGNED NOT NULL,
  `survey_id` bigint UNSIGNED NOT NULL,
  `survey_question_id` bigint UNSIGNED NOT NULL,
  `order` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `survey_question_options`
--

CREATE TABLE `survey_question_options` (
  `id` bigint UNSIGNED NOT NULL,
  `survey_question_id` bigint UNSIGNED NOT NULL,
  `option_text` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `weight` decimal(5,2) NOT NULL DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `survey_responses`
--

CREATE TABLE `survey_responses` (
  `id` bigint UNSIGNED NOT NULL,
  `survey_id` bigint UNSIGNED NOT NULL,
  `survey_invitation_id` bigint UNSIGNED NOT NULL,
  `submitted_at` timestamp NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `travel_cost_components`
--

CREATE TABLE `travel_cost_components` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `travel_cost_standards`
--

CREATE TABLE `travel_cost_standards` (
  `id` bigint UNSIGNED NOT NULL,
  `city_id` bigint UNSIGNED NOT NULL,
  `structural_position_id` bigint UNSIGNED DEFAULT NULL,
  `employee_grade_id` bigint UNSIGNED DEFAULT NULL,
  `travel_cost_component_id` bigint UNSIGNED NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `travel_expenses`
--

CREATE TABLE `travel_expenses` (
  `id` bigint UNSIGNED NOT NULL,
  `official_travel_id` bigint UNSIGNED NOT NULL,
  `employee_id` bigint UNSIGNED NOT NULL,
  `travel_cost_component_id` bigint UNSIGNED NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `receipt_file` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `submitted_at` timestamp NOT NULL,
  `verified_at` timestamp NULL DEFAULT NULL,
  `status` enum('submitted','approved','rejected') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `username`, `email`, `password`, `created_at`, `updated_at`) VALUES
(1, 'Administrator', 'admin', 'admin@facultyware.ac.id', '$2b$10$Vbg/sfUlq2F//CDJjR7EcuzSE.bdMdeiyMoaB/32Qv3LoWA2l3PT6', '2026-05-30 17:28:21', NULL),
(2, 'Codex Test Admin', 'codex_test_admin', 'codex-test-admin@example.test', '$2b$10$wThf7OXUOYY14CJuJrCW5.OxMj0ghGK2ZBZXX625PlVb7i7SSUxNO', '2026-06-17 12:55:55', '2026-06-17 12:55:55');

-- --------------------------------------------------------

--
-- Table structure for table `user_has_roles`
--

CREATE TABLE `user_has_roles` (
  `user_id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_has_roles`
--

INSERT INTO `user_has_roles` (`user_id`, `role_id`) VALUES
(1, 1),
(2, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `assets`
--
ALTER TABLE `assets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `assets_code_unique` (`code`),
  ADD KEY `assets_asset_grant_id_foreign` (`asset_grant_id`);

--
-- Indexes for table `asset_audits`
--
ALTER TABLE `asset_audits`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `asset_audits_audit_number_unique` (`audit_number`),
  ADD KEY `asset_audits_conducted_by_foreign` (`conducted_by`);

--
-- Indexes for table `asset_audit_details`
--
ALTER TABLE `asset_audit_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `asset_audit_details_asset_audit_id_foreign` (`asset_audit_id`),
  ADD KEY `asset_audit_details_asset_id_foreign` (`asset_id`);

--
-- Indexes for table `asset_grants`
--
ALTER TABLE `asset_grants`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `asset_insurances`
--
ALTER TABLE `asset_insurances`
  ADD PRIMARY KEY (`id`),
  ADD KEY `asset_insurances_asset_id_foreign` (`asset_id`);

--
-- Indexes for table `asset_insurance_claims`
--
ALTER TABLE `asset_insurance_claims`
  ADD PRIMARY KEY (`id`),
  ADD KEY `asset_insurance_claims_asset_insurance_id_foreign` (`asset_insurance_id`);

--
-- Indexes for table `asset_trackings`
--
ALTER TABLE `asset_trackings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `asset_trackings_asset_id_foreign` (`asset_id`);

--
-- Indexes for table `asset_tracking_logs`
--
ALTER TABLE `asset_tracking_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `asset_tracking_logs_asset_id_foreign` (`asset_id`),
  ADD KEY `asset_tracking_logs_moved_by_foreign` (`moved_by`);

--
-- Indexes for table `assignments`
--
ALTER TABLE `assignments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `assignments_assigned_by_foreign` (`assigned_by`),
  ADD KEY `assignments_assigned_to_foreign` (`assigned_to`),
  ADD KEY `assignments_parent_id_foreign` (`parent_id`);

--
-- Indexes for table `assignment_progress`
--
ALTER TABLE `assignment_progress`
  ADD PRIMARY KEY (`id`),
  ADD KEY `assignment_progress_assignment_id_foreign` (`assignment_id`),
  ADD KEY `assignment_progress_created_by_foreign` (`created_by`);

--
-- Indexes for table `attendances`
--
ALTER TABLE `attendances`
  ADD PRIMARY KEY (`id`),
  ADD KEY `attendances_employee_id_foreign` (`employee_id`);

--
-- Indexes for table `buildings`
--
ALTER TABLE `buildings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `buildings_code_unique` (`code`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- Indexes for table `committees`
--
ALTER TABLE `committees`
  ADD PRIMARY KEY (`id`),
  ADD KEY `committees_created_by_foreign` (`created_by`);

--
-- Indexes for table `committee_budgets`
--
ALTER TABLE `committee_budgets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `committee_budgets_committee_id_foreign` (`committee_id`);

--
-- Indexes for table `committee_budget_items`
--
ALTER TABLE `committee_budget_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `committee_budget_items_committee_budget_id_foreign` (`committee_budget_id`);

--
-- Indexes for table `committee_expenses`
--
ALTER TABLE `committee_expenses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `committee_expenses_committee_budget_item_id_foreign` (`committee_budget_item_id`),
  ADD KEY `committee_expenses_approved_by_foreign` (`approved_by`);

--
-- Indexes for table `committee_external_members`
--
ALTER TABLE `committee_external_members`
  ADD PRIMARY KEY (`id`),
  ADD KEY `committee_external_members_committee_id_foreign` (`committee_id`);

--
-- Indexes for table `committee_members`
--
ALTER TABLE `committee_members`
  ADD PRIMARY KEY (`id`),
  ADD KEY `committee_members_committee_id_foreign` (`committee_id`),
  ADD KEY `committee_members_employee_id_foreign` (`employee_id`);

--
-- Indexes for table `committee_tasks`
--
ALTER TABLE `committee_tasks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `committee_tasks_committee_id_foreign` (`committee_id`),
  ADD KEY `committee_tasks_assigned_to_foreign` (`assigned_to`);

--
-- Indexes for table `committee_task_progress`
--
ALTER TABLE `committee_task_progress`
  ADD PRIMARY KEY (`id`),
  ADD KEY `committee_task_progress_committee_task_id_foreign` (`committee_task_id`);

--
-- Indexes for table `community_services`
--
ALTER TABLE `community_services`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `community_service_members`
--
ALTER TABLE `community_service_members`
  ADD PRIMARY KEY (`id`),
  ADD KEY `community_service_members_community_service_id_foreign` (`community_service_id`),
  ADD KEY `community_service_members_lecturer_id_foreign` (`lecturer_id`);

--
-- Indexes for table `conference_proceedings`
--
ALTER TABLE `conference_proceedings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `conference_proceedings_publication_id_foreign` (`publication_id`);

--
-- Indexes for table `documents`
--
ALTER TABLE `documents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_documents_users1_idx` (`created_by`),
  ADD KEY `fk_documents_document_types1_idx` (`document_type_id`);

--
-- Indexes for table `document_revisions`
--
ALTER TABLE `document_revisions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_document_revisions_documents1_idx` (`document_id`);

--
-- Indexes for table `document_types`
--
ALTER TABLE `document_types`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `education_histories`
--
ALTER TABLE `education_histories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `education_histories_employee_id_foreign` (`employee_id`);

--
-- Indexes for table `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `employees_employee_number_unique` (`employee_number`),
  ADD KEY `employees_organization_unit_id_foreign` (`organization_unit_id`),
  ADD KEY `employees_employment_status_id_foreign` (`employment_status_id`);

--
-- Indexes for table `employee_grades`
--
ALTER TABLE `employee_grades`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `employment_statuses`
--
ALTER TABLE `employment_statuses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `equipments`
--
ALTER TABLE `equipments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `asset_equipment_asset_id_foreign` (`asset_id`);

--
-- Indexes for table `equipment_loans`
--
ALTER TABLE `equipment_loans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `asset_loans_employee_id_foreign` (`employee_id`),
  ADD KEY `asset_loans_approved_by_foreign` (`approved_by`),
  ADD KEY `asset_loans_asset_equipment_id_foreign_idx` (`equipment_id`);

--
-- Indexes for table `equipment_maintenance_requests`
--
ALTER TABLE `equipment_maintenance_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `asset_maintenance_requests_reported_by_foreign` (`reported_by`),
  ADD KEY `asset_maintenance_requests_asset_equipment_foreign_idx` (`equipment_id`);

--
-- Indexes for table `equipment_maintenance_request_log`
--
ALTER TABLE `equipment_maintenance_request_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_equipment_maintenance_request_log_equipment_maintenance__idx` (`equipment_maintenance_request_id`),
  ADD KEY `fk_equipment_maintenance_request_log_employees1_idx` (`logged_by`),
  ADD KEY `fk_equipment_maintenance_request_log_employees2_idx` (`verified_by`);

--
-- Indexes for table `equipment_procurements`
--
ALTER TABLE `equipment_procurements`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `asset_equipment_procurements_request_number_unique` (`request_number`),
  ADD KEY `asset_equipment_procurements_created_by_foreign` (`created_by`);

--
-- Indexes for table `equipment_proc_items`
--
ALTER TABLE `equipment_proc_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `asset_equipment_proc_items_asset_equipment_proc_id_foreign` (`equipment_proc_id`);

--
-- Indexes for table `equipment_requests`
--
ALTER TABLE `equipment_requests`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `asset_equipment_requests_request_number_unique` (`request_number`),
  ADD KEY `asset_equipment_requests_employee_id_foreign` (`employee_id`),
  ADD KEY `asset_equipment_requests_approved_by_foreign` (`approved_by`);

--
-- Indexes for table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `events_slug_unique` (`slug`),
  ADD KEY `events_created_by_foreign` (`created_by`);

--
-- Indexes for table `event_attendances`
--
ALTER TABLE `event_attendances`
  ADD PRIMARY KEY (`id`),
  ADD KEY `event_attendances_event_registration_id_foreign` (`event_registration_id`),
  ADD KEY `event_attendances_checked_by_foreign` (`checked_by`);

--
-- Indexes for table `event_committee_members`
--
ALTER TABLE `event_committee_members`
  ADD PRIMARY KEY (`id`),
  ADD KEY `event_committee_members_event_id_foreign` (`event_id`),
  ADD KEY `event_committee_members_employee_id_foreign` (`employee_id`);

--
-- Indexes for table `event_documents`
--
ALTER TABLE `event_documents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `event_documents_event_id_foreign` (`event_id`),
  ADD KEY `event_documents_uploaded_by_foreign` (`uploaded_by`);

--
-- Indexes for table `event_registrations`
--
ALTER TABLE `event_registrations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `event_registrations_registration_number_unique` (`registration_number`),
  ADD UNIQUE KEY `event_registrations_ticket_number_unique` (`ticket_number`),
  ADD UNIQUE KEY `event_registrations_certificate_number_unique` (`certificate_number`),
  ADD KEY `event_registrations_user_id_foreign` (`user_id`),
  ADD KEY `event_registrations_generated_by_foreign` (`generated_by`),
  ADD KEY `event_registrations_event_id_foreign_idx` (`event_id`);

--
-- Indexes for table `event_reminders`
--
ALTER TABLE `event_reminders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `event_reminders_event_id_foreign` (`event_id`),
  ADD KEY `event_reminders_sent_by_foreign` (`sent_by`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `follow_up`
--
ALTER TABLE `follow_up`
  ADD PRIMARY KEY (`id`),
  ADD KEY `potential_partner_id` (`potential_partner_id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `functional_positions`
--
ALTER TABLE `functional_positions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `holidays`
--
ALTER TABLE `holidays`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `implementation_arrangements`
--
ALTER TABLE `implementation_arrangements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `implementation_arrangements_partnership_id_foreign` (`partnership_id`),
  ADD KEY `implementation_arrangements_partnership_impl_id_foreign` (`partnership_impl_id`);

--
-- Indexes for table `inventories`
--
ALTER TABLE `inventories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `inventories_item_id_foreign` (`item_id`);

--
-- Indexes for table `inventory_procurements`
--
ALTER TABLE `inventory_procurements`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `inventory_procurements_request_number_unique` (`request_number`),
  ADD KEY `inventory_procurements_created_by_foreign` (`created_by`);

--
-- Indexes for table `inventory_procurement_items`
--
ALTER TABLE `inventory_procurement_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `inventory_procurement_items_inventory_procurement_id_foreign` (`inventory_procurement_id`),
  ADD KEY `inventory_procurement_items_item_id_foreign` (`item_id`);

--
-- Indexes for table `inventory_purchases`
--
ALTER TABLE `inventory_purchases`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `inventory_purchases_purchase_number_unique` (`purchase_number`),
  ADD KEY `inventory_purchases_inventory_procurement_id_foreign` (`inventory_procurement_id`);

--
-- Indexes for table `inventory_purchase_items`
--
ALTER TABLE `inventory_purchase_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `inventory_purchase_items_inventory_purchase_id_foreign` (`inventory_purchase_id`),
  ADD KEY `inventory_purchase_items_item_id_foreign` (`item_id`);

--
-- Indexes for table `inventory_requests`
--
ALTER TABLE `inventory_requests`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `inventory_requests_request_number_unique` (`request_number`),
  ADD KEY `inventory_requests_employee_id_foreign` (`employee_id`),
  ADD KEY `inventory_requests_approved_by_foreign` (`approved_by`);

--
-- Indexes for table `inventory_request_approvals`
--
ALTER TABLE `inventory_request_approvals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `inventory_request_approvals_inventory_request_id_foreign` (`inventory_request_id`),
  ADD KEY `inventory_request_approvals_approver_id_foreign` (`approver_id`);

--
-- Indexes for table `inventory_request_details`
--
ALTER TABLE `inventory_request_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `inventory_request_details_inventory_request_id_foreign` (`inventory_request_id`),
  ADD KEY `inventory_request_details_item_id_foreign` (`item_id`);

--
-- Indexes for table `inventory_transactions`
--
ALTER TABLE `inventory_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `inventory_transactions_item_id_foreign` (`item_id`);

--
-- Indexes for table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `items_code_unique` (`code`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `job_responsibilities`
--
ALTER TABLE `job_responsibilities`
  ADD PRIMARY KEY (`id`),
  ADD KEY `job_responsibilities_structural_position_id_foreign` (`structural_position_id`);

--
-- Indexes for table `journal_publications`
--
ALTER TABLE `journal_publications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `journal_publications_publication_id_foreign` (`publication_id`);

--
-- Indexes for table `leave_approvals`
--
ALTER TABLE `leave_approvals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `leave_approvals_leave_request_id_foreign` (`leave_request_id`),
  ADD KEY `leave_approvals_approver_id_foreign` (`approver_id`);

--
-- Indexes for table `leave_balances`
--
ALTER TABLE `leave_balances`
  ADD PRIMARY KEY (`id`),
  ADD KEY `leave_balances_employee_id_foreign` (`employee_id`),
  ADD KEY `leave_balances_leave_type_id_foreign` (`leave_type_id`);

--
-- Indexes for table `leave_requests`
--
ALTER TABLE `leave_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `leave_requests_employee_id_foreign` (`employee_id`),
  ADD KEY `leave_requests_leave_type_id_foreign` (`leave_type_id`),
  ADD KEY `leave_requests_approver_id_foreign` (`approver_id`);

--
-- Indexes for table `leave_types`
--
ALTER TABLE `leave_types`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `lecturers`
--
ALTER TABLE `lecturers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `lecturer_functional_positions`
--
ALTER TABLE `lecturer_functional_positions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lecturer_functional_positions_lecturer_id_foreign` (`lecturer_id`),
  ADD KEY `lecturer_functional_positions_functional_position_id_foreign` (`functional_position_id`);

--
-- Indexes for table `meetings`
--
ALTER TABLE `meetings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `meetings_organizer_id_foreign` (`organizer_id`),
  ADD KEY `meetings_leader_id_foreign` (`leader_id`),
  ADD KEY `meetings_asset_room_id_foreign` (`asset_room_id`),
  ADD KEY `meetings_committee_id_foreign` (`committee_id`);

--
-- Indexes for table `meeting_consumption_requests`
--
ALTER TABLE `meeting_consumption_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `meeting_consumption_requests_meeting_id_foreign` (`meeting_id`),
  ADD KEY `meeting_consumption_requests_approved_by_foreign` (`approved_by`);

--
-- Indexes for table `meeting_documents`
--
ALTER TABLE `meeting_documents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `meeting_documents_meeting_id_foreign` (`meeting_id`),
  ADD KEY `meeting_documents_uploaded_by_foreign` (`uploaded_by`);

--
-- Indexes for table `meeting_external_participants`
--
ALTER TABLE `meeting_external_participants`
  ADD PRIMARY KEY (`id`),
  ADD KEY `meeting_external_participants_meeting_id_foreign` (`meeting_id`);

--
-- Indexes for table `meeting_minutes`
--
ALTER TABLE `meeting_minutes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `meeting_minutes_meeting_id_foreign` (`meeting_id`),
  ADD KEY `meeting_minutes_created_by_foreign` (`created_by`);

--
-- Indexes for table `meeting_participants`
--
ALTER TABLE `meeting_participants`
  ADD PRIMARY KEY (`id`),
  ADD KEY `meeting_participants_meeting_id_foreign` (`meeting_id`),
  ADD KEY `meeting_participants_employee_id_foreign` (`employee_id`);

--
-- Indexes for table `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`model_id`,`model_type`),
  ADD KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Indexes for table `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD PRIMARY KEY (`role_id`,`model_id`,`model_type`),
  ADD KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Indexes for table `mou`
--
ALTER TABLE `mou`
  ADD PRIMARY KEY (`id`),
  ADD KEY `potential_partner_id` (`potential_partner_id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `nomenclatures`
--
ALTER TABLE `nomenclatures`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `nomenclature_classifications`
--
ALTER TABLE `nomenclature_classifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `nomenclature_classifications_nomenclature_id_foreign` (`nomenclature_id`);

--
-- Indexes for table `official_travel`
--
ALTER TABLE `official_travel`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `official_travel_request_number_unique` (`request_number`),
  ADD KEY `official_travel_submitted_by_foreign` (`submitted_by`),
  ADD KEY `official_travel_approved_by_foreign` (`approved_by`);

--
-- Indexes for table `official_travel_approvals`
--
ALTER TABLE `official_travel_approvals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `official_travel_approvals_official_travel_id_foreign` (`official_travel_id`),
  ADD KEY `official_travel_approvals_approver_id_foreign` (`approver_id`);

--
-- Indexes for table `official_travel_documents`
--
ALTER TABLE `official_travel_documents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `official_travel_documents_official_travel_id_foreign` (`official_travel_id`);

--
-- Indexes for table `official_travel_itineraries`
--
ALTER TABLE `official_travel_itineraries`
  ADD PRIMARY KEY (`id`),
  ADD KEY `official_travel_itineraries_official_travel_id_foreign` (`official_travel_id`);

--
-- Indexes for table `official_travel_members`
--
ALTER TABLE `official_travel_members`
  ADD PRIMARY KEY (`id`),
  ADD KEY `official_travel_members_official_travel_id_foreign` (`official_travel_id`),
  ADD KEY `official_travel_members_employee_id_foreign` (`employee_id`);

--
-- Indexes for table `organization_units`
--
ALTER TABLE `organization_units`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `organization_units_code_unique` (`code`),
  ADD KEY `organization_units_parent_id_foreign` (`parent_id`);

--
-- Indexes for table `overtime_approval_logs`
--
ALTER TABLE `overtime_approval_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `overtime_approval_logs_overtime_request_id_foreign` (`overtime_request_id`),
  ADD KEY `overtime_approval_logs_approver_id_foreign` (`approver_id`);

--
-- Indexes for table `overtime_requests`
--
ALTER TABLE `overtime_requests`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `overtime_requests_request_number_unique` (`request_number`),
  ADD KEY `overtime_requests_submitted_by_foreign` (`submitted_by`),
  ADD KEY `overtime_requests_approved_by_foreign` (`approved_by`);

--
-- Indexes for table `overtime_request_members`
--
ALTER TABLE `overtime_request_members`
  ADD PRIMARY KEY (`id`),
  ADD KEY `overtime_request_members_overtime_request_id_foreign` (`overtime_request_id`),
  ADD KEY `overtime_request_members_employee_id_foreign` (`employee_id`);

--
-- Indexes for table `partners`
--
ALTER TABLE `partners`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `partnerships`
--
ALTER TABLE `partnerships`
  ADD PRIMARY KEY (`id`),
  ADD KEY `partnerships_partner_id_foreign` (`partner_id`),
  ADD KEY `partnerships_partner_potential_id_foreign` (`partner_potential_id`);

--
-- Indexes for table `partnership_documents`
--
ALTER TABLE `partnership_documents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `partnership_documents_partnership_id_foreign` (`partnership_id`);

--
-- Indexes for table `partnership_implementations`
--
ALTER TABLE `partnership_implementations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `partnership_implementations_partnership_id_foreign` (`partnership_id`);

--
-- Indexes for table `partner_contacts`
--
ALTER TABLE `partner_contacts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `partner_contacts_partner_id_foreign` (`partner_id`);

--
-- Indexes for table `partner_follow_ups`
--
ALTER TABLE `partner_follow_ups`
  ADD PRIMARY KEY (`id`),
  ADD KEY `partner_follow_ups_partner_potential_id_foreign` (`partner_potential_id`),
  ADD KEY `partner_follow_ups_conducted_by_foreign` (`conducted_by`);

--
-- Indexes for table `partner_potentials`
--
ALTER TABLE `partner_potentials`
  ADD PRIMARY KEY (`id`),
  ADD KEY `partner_potentials_partner_id_foreign` (`partner_id`);

--
-- Indexes for table `partner_potential_fields`
--
ALTER TABLE `partner_potential_fields`
  ADD PRIMARY KEY (`id`),
  ADD KEY `partner_potential_fields_partner_potential_id_foreign` (`partner_potential_id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `permissions_name_unique` (`name`);

--
-- Indexes for table `potential_partners`
--
ALTER TABLE `potential_partners`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `potential_partners_backup_1782124193798`
--
ALTER TABLE `potential_partners_backup_1782124193798`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `publications`
--
ALTER TABLE `publications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `publications_research_id_foreign` (`research_id`);

--
-- Indexes for table `publication_authors`
--
ALTER TABLE `publication_authors`
  ADD PRIMARY KEY (`id`),
  ADD KEY `publication_authors_publication_id_foreign` (`publication_id`),
  ADD KEY `publication_authors_lecturer_id_foreign` (`lecturer_id`);

--
-- Indexes for table `research`
--
ALTER TABLE `research`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `research_members`
--
ALTER TABLE `research_members`
  ADD PRIMARY KEY (`id`),
  ADD KEY `research_members_research_id_foreign` (`research_id`),
  ADD KEY `research_members_lecturer_id_foreign` (`lecturer_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_name_unique` (`name`);

--
-- Indexes for table `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD PRIMARY KEY (`role_id`,`permission_id`),
  ADD KEY `rhp_permission_fk` (`permission_id`);

--
-- Indexes for table `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `asset_rooms_code_unique` (`code`),
  ADD KEY `asset_rooms_asset_id_foreign` (`asset_id`),
  ADD KEY `asset_rooms_building_id_foreign` (`building_id`),
  ADD KEY `asset_rooms_responsible_employee_id_foreign` (`responsible_employee_id`);

--
-- Indexes for table `room_loans`
--
ALTER TABLE `room_loans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `room_loans_asset_room_id_foreign` (`room_id`),
  ADD KEY `room_loans_employee_id_foreign` (`employee_id`),
  ADD KEY `room_loans_approved_by_foreign` (`approved_by`);

--
-- Indexes for table `room_maintenance_requests`
--
ALTER TABLE `room_maintenance_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `room_maintenance_requests_asset_room_id_foreign` (`room_id`),
  ADD KEY `room_maintenance_requests_reported_by_foreign` (`reported_by`);

--
-- Indexes for table `room_maintenance_request_log`
--
ALTER TABLE `room_maintenance_request_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_room_maintenance_request_log_room_maintenance_requests1_idx` (`room_maintenance_request_id`),
  ADD KEY `fk_room_maintenance_request_log_employees1_idx` (`logged_by`),
  ADD KEY `fk_room_maintenance_request_log_employees2_idx` (`verified_by`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`session_id`);

--
-- Indexes for table `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `staff_nomenclature_histories`
--
ALTER TABLE `staff_nomenclature_histories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `staff_nomenclature_histories_staff_id_foreign` (`staff_id`),
  ADD KEY `staff_nomenclature_histories_nomenclature_class_id_foreign` (`nomenclature_class_id`);

--
-- Indexes for table `structural_positions`
--
ALTER TABLE `structural_positions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `structural_positions_parent_id_foreign` (`parent_id`);

--
-- Indexes for table `structural_position_histories`
--
ALTER TABLE `structural_position_histories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `structural_position_histories_employee_id_foreign` (`employee_id`),
  ADD KEY `structural_position_histories_structural_position_id_foreign` (`structural_position_id`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_students_lecturers1_idx` (`advisor_id`),
  ADD KEY `fk_students_organization_units1_idx` (`department_id`);

--
-- Indexes for table `student_requests`
--
ALTER TABLE `student_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_student_requests_students1_idx` (`requested_by`);

--
-- Indexes for table `student_request_active_references`
--
ALTER TABLE `student_request_active_references`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_student_request_recomendations_student_requests1_idx` (`student_requests_id`),
  ADD KEY `fk_student_request_recomendations_employees1_idx` (`signed_by`),
  ADD KEY `fk_student_request_recomendations_employees2_idx` (`checked_by`);

--
-- Indexes for table `surveys`
--
ALTER TABLE `surveys`
  ADD PRIMARY KEY (`id`),
  ADD KEY `surveys_created_by_foreign` (`created_by`);

--
-- Indexes for table `survey_answers`
--
ALTER TABLE `survey_answers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `survey_answers_survey_response_id_foreign` (`survey_response_id`),
  ADD KEY `survey_answers_survey_question_id_foreign` (`survey_question_id`);

--
-- Indexes for table `survey_answer_options`
--
ALTER TABLE `survey_answer_options`
  ADD PRIMARY KEY (`id`),
  ADD KEY `survey_answer_options_survey_answer_id_foreign` (`survey_answer_id`),
  ADD KEY `survey_answer_options_survey_question_option_id_foreign` (`survey_question_option_id`);

--
-- Indexes for table `survey_invitations`
--
ALTER TABLE `survey_invitations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `survey_invitations_pin_unique` (`pin`),
  ADD KEY `survey_invitations_survey_id_foreign` (`survey_id`);

--
-- Indexes for table `survey_questions`
--
ALTER TABLE `survey_questions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `survey_question_assignments`
--
ALTER TABLE `survey_question_assignments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `survey_question_assignments_survey_id_foreign` (`survey_id`),
  ADD KEY `survey_question_assignments_survey_question_id_foreign` (`survey_question_id`);

--
-- Indexes for table `survey_question_options`
--
ALTER TABLE `survey_question_options`
  ADD PRIMARY KEY (`id`),
  ADD KEY `survey_question_options_survey_question_id_foreign` (`survey_question_id`);

--
-- Indexes for table `survey_responses`
--
ALTER TABLE `survey_responses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `survey_responses_survey_id_foreign` (`survey_id`),
  ADD KEY `survey_responses_survey_invitation_id_foreign` (`survey_invitation_id`);

--
-- Indexes for table `travel_cost_components`
--
ALTER TABLE `travel_cost_components`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `travel_cost_components_code_unique` (`code`);

--
-- Indexes for table `travel_cost_standards`
--
ALTER TABLE `travel_cost_standards`
  ADD PRIMARY KEY (`id`),
  ADD KEY `travel_cost_standards_city_id_foreign` (`city_id`),
  ADD KEY `travel_cost_standards_structural_position_id_foreign` (`structural_position_id`),
  ADD KEY `travel_cost_standards_employee_grade_id_foreign` (`employee_grade_id`),
  ADD KEY `travel_cost_standards_travel_cost_component_id_foreign` (`travel_cost_component_id`);

--
-- Indexes for table `travel_expenses`
--
ALTER TABLE `travel_expenses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `travel_expenses_official_travel_id_foreign` (`official_travel_id`),
  ADD KEY `travel_expenses_employee_id_foreign` (`employee_id`),
  ADD KEY `travel_expenses_travel_cost_component_id_foreign` (`travel_cost_component_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD UNIQUE KEY `users_username_unique` (`username`);

--
-- Indexes for table `user_has_roles`
--
ALTER TABLE `user_has_roles`
  ADD PRIMARY KEY (`user_id`,`role_id`),
  ADD KEY `uhr_role_fk` (`role_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `assets`
--
ALTER TABLE `assets`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `asset_audits`
--
ALTER TABLE `asset_audits`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `asset_audit_details`
--
ALTER TABLE `asset_audit_details`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `asset_grants`
--
ALTER TABLE `asset_grants`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `asset_insurances`
--
ALTER TABLE `asset_insurances`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `asset_insurance_claims`
--
ALTER TABLE `asset_insurance_claims`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `asset_trackings`
--
ALTER TABLE `asset_trackings`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `asset_tracking_logs`
--
ALTER TABLE `asset_tracking_logs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `assignments`
--
ALTER TABLE `assignments`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `assignment_progress`
--
ALTER TABLE `assignment_progress`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `attendances`
--
ALTER TABLE `attendances`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `buildings`
--
ALTER TABLE `buildings`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `committees`
--
ALTER TABLE `committees`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `committee_budgets`
--
ALTER TABLE `committee_budgets`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `committee_budget_items`
--
ALTER TABLE `committee_budget_items`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `committee_expenses`
--
ALTER TABLE `committee_expenses`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `committee_external_members`
--
ALTER TABLE `committee_external_members`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `committee_members`
--
ALTER TABLE `committee_members`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `committee_tasks`
--
ALTER TABLE `committee_tasks`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `committee_task_progress`
--
ALTER TABLE `committee_task_progress`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `community_services`
--
ALTER TABLE `community_services`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `community_service_members`
--
ALTER TABLE `community_service_members`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `conference_proceedings`
--
ALTER TABLE `conference_proceedings`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `education_histories`
--
ALTER TABLE `education_histories`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `employees`
--
ALTER TABLE `employees`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `employee_grades`
--
ALTER TABLE `employee_grades`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `employment_statuses`
--
ALTER TABLE `employment_statuses`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `equipments`
--
ALTER TABLE `equipments`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `equipment_loans`
--
ALTER TABLE `equipment_loans`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `equipment_maintenance_requests`
--
ALTER TABLE `equipment_maintenance_requests`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `equipment_procurements`
--
ALTER TABLE `equipment_procurements`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `equipment_proc_items`
--
ALTER TABLE `equipment_proc_items`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `equipment_requests`
--
ALTER TABLE `equipment_requests`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `event_attendances`
--
ALTER TABLE `event_attendances`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `event_committee_members`
--
ALTER TABLE `event_committee_members`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `event_documents`
--
ALTER TABLE `event_documents`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `event_registrations`
--
ALTER TABLE `event_registrations`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `event_reminders`
--
ALTER TABLE `event_reminders`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `follow_up`
--
ALTER TABLE `follow_up`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `functional_positions`
--
ALTER TABLE `functional_positions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `holidays`
--
ALTER TABLE `holidays`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `implementation_arrangements`
--
ALTER TABLE `implementation_arrangements`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inventories`
--
ALTER TABLE `inventories`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inventory_procurements`
--
ALTER TABLE `inventory_procurements`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inventory_procurement_items`
--
ALTER TABLE `inventory_procurement_items`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inventory_purchases`
--
ALTER TABLE `inventory_purchases`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inventory_purchase_items`
--
ALTER TABLE `inventory_purchase_items`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inventory_requests`
--
ALTER TABLE `inventory_requests`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inventory_request_approvals`
--
ALTER TABLE `inventory_request_approvals`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inventory_request_details`
--
ALTER TABLE `inventory_request_details`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inventory_transactions`
--
ALTER TABLE `inventory_transactions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `items`
--
ALTER TABLE `items`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `job_responsibilities`
--
ALTER TABLE `job_responsibilities`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `journal_publications`
--
ALTER TABLE `journal_publications`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `leave_approvals`
--
ALTER TABLE `leave_approvals`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `leave_balances`
--
ALTER TABLE `leave_balances`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `leave_requests`
--
ALTER TABLE `leave_requests`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `leave_types`
--
ALTER TABLE `leave_types`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lecturers`
--
ALTER TABLE `lecturers`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lecturer_functional_positions`
--
ALTER TABLE `lecturer_functional_positions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `meetings`
--
ALTER TABLE `meetings`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `meeting_consumption_requests`
--
ALTER TABLE `meeting_consumption_requests`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `meeting_documents`
--
ALTER TABLE `meeting_documents`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `meeting_external_participants`
--
ALTER TABLE `meeting_external_participants`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `meeting_minutes`
--
ALTER TABLE `meeting_minutes`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `meeting_participants`
--
ALTER TABLE `meeting_participants`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `mou`
--
ALTER TABLE `mou`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `nomenclatures`
--
ALTER TABLE `nomenclatures`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nomenclature_classifications`
--
ALTER TABLE `nomenclature_classifications`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `official_travel`
--
ALTER TABLE `official_travel`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `official_travel_approvals`
--
ALTER TABLE `official_travel_approvals`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `official_travel_documents`
--
ALTER TABLE `official_travel_documents`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `official_travel_itineraries`
--
ALTER TABLE `official_travel_itineraries`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `official_travel_members`
--
ALTER TABLE `official_travel_members`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `organization_units`
--
ALTER TABLE `organization_units`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `overtime_approval_logs`
--
ALTER TABLE `overtime_approval_logs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `overtime_requests`
--
ALTER TABLE `overtime_requests`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `overtime_request_members`
--
ALTER TABLE `overtime_request_members`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `partners`
--
ALTER TABLE `partners`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `partnerships`
--
ALTER TABLE `partnerships`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `partnership_documents`
--
ALTER TABLE `partnership_documents`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `partnership_implementations`
--
ALTER TABLE `partnership_implementations`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `partner_contacts`
--
ALTER TABLE `partner_contacts`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `partner_follow_ups`
--
ALTER TABLE `partner_follow_ups`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `partner_potentials`
--
ALTER TABLE `partner_potentials`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `partner_potential_fields`
--
ALTER TABLE `partner_potential_fields`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `potential_partners_backup_1782124193798`
--
ALTER TABLE `potential_partners_backup_1782124193798`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `publications`
--
ALTER TABLE `publications`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `publication_authors`
--
ALTER TABLE `publication_authors`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `research`
--
ALTER TABLE `research`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `research_members`
--
ALTER TABLE `research_members`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `rooms`
--
ALTER TABLE `rooms`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `room_loans`
--
ALTER TABLE `room_loans`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `room_maintenance_requests`
--
ALTER TABLE `room_maintenance_requests`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `staff`
--
ALTER TABLE `staff`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `staff_nomenclature_histories`
--
ALTER TABLE `staff_nomenclature_histories`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `structural_positions`
--
ALTER TABLE `structural_positions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `structural_position_histories`
--
ALTER TABLE `structural_position_histories`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `surveys`
--
ALTER TABLE `surveys`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `survey_answers`
--
ALTER TABLE `survey_answers`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `survey_answer_options`
--
ALTER TABLE `survey_answer_options`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `survey_invitations`
--
ALTER TABLE `survey_invitations`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `survey_questions`
--
ALTER TABLE `survey_questions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `survey_question_assignments`
--
ALTER TABLE `survey_question_assignments`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `survey_question_options`
--
ALTER TABLE `survey_question_options`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `survey_responses`
--
ALTER TABLE `survey_responses`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `travel_cost_components`
--
ALTER TABLE `travel_cost_components`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `travel_cost_standards`
--
ALTER TABLE `travel_cost_standards`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `travel_expenses`
--
ALTER TABLE `travel_expenses`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `assets`
--
ALTER TABLE `assets`
  ADD CONSTRAINT `assets_asset_grant_id_foreign` FOREIGN KEY (`asset_grant_id`) REFERENCES `asset_grants` (`id`);

--
-- Constraints for table `asset_audits`
--
ALTER TABLE `asset_audits`
  ADD CONSTRAINT `asset_audits_conducted_by_foreign` FOREIGN KEY (`conducted_by`) REFERENCES `employees` (`id`);

--
-- Constraints for table `asset_audit_details`
--
ALTER TABLE `asset_audit_details`
  ADD CONSTRAINT `asset_audit_details_asset_audit_id_foreign` FOREIGN KEY (`asset_audit_id`) REFERENCES `asset_audits` (`id`),
  ADD CONSTRAINT `asset_audit_details_asset_id_foreign` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`);

--
-- Constraints for table `asset_insurances`
--
ALTER TABLE `asset_insurances`
  ADD CONSTRAINT `asset_insurances_asset_id_foreign` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`);

--
-- Constraints for table `asset_insurance_claims`
--
ALTER TABLE `asset_insurance_claims`
  ADD CONSTRAINT `asset_insurance_claims_asset_insurance_id_foreign` FOREIGN KEY (`asset_insurance_id`) REFERENCES `asset_insurances` (`id`);

--
-- Constraints for table `asset_trackings`
--
ALTER TABLE `asset_trackings`
  ADD CONSTRAINT `asset_trackings_asset_id_foreign` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`);

--
-- Constraints for table `asset_tracking_logs`
--
ALTER TABLE `asset_tracking_logs`
  ADD CONSTRAINT `asset_tracking_logs_asset_id_foreign` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`),
  ADD CONSTRAINT `asset_tracking_logs_moved_by_foreign` FOREIGN KEY (`moved_by`) REFERENCES `employees` (`id`);

--
-- Constraints for table `assignments`
--
ALTER TABLE `assignments`
  ADD CONSTRAINT `assignments_assigned_by_foreign` FOREIGN KEY (`assigned_by`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `assignments_assigned_to_foreign` FOREIGN KEY (`assigned_to`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `assignments_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `assignments` (`id`);

--
-- Constraints for table `assignment_progress`
--
ALTER TABLE `assignment_progress`
  ADD CONSTRAINT `assignment_progress_assignment_id_foreign` FOREIGN KEY (`assignment_id`) REFERENCES `assignments` (`id`),
  ADD CONSTRAINT `assignment_progress_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `employees` (`id`);

--
-- Constraints for table `attendances`
--
ALTER TABLE `attendances`
  ADD CONSTRAINT `attendances_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`);

--
-- Constraints for table `committees`
--
ALTER TABLE `committees`
  ADD CONSTRAINT `committees_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `employees` (`id`);

--
-- Constraints for table `committee_budgets`
--
ALTER TABLE `committee_budgets`
  ADD CONSTRAINT `committee_budgets_committee_id_foreign` FOREIGN KEY (`committee_id`) REFERENCES `committees` (`id`);

--
-- Constraints for table `committee_budget_items`
--
ALTER TABLE `committee_budget_items`
  ADD CONSTRAINT `committee_budget_items_committee_budget_id_foreign` FOREIGN KEY (`committee_budget_id`) REFERENCES `committee_budgets` (`id`);

--
-- Constraints for table `committee_expenses`
--
ALTER TABLE `committee_expenses`
  ADD CONSTRAINT `committee_expenses_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `committee_expenses_committee_budget_item_id_foreign` FOREIGN KEY (`committee_budget_item_id`) REFERENCES `committee_budget_items` (`id`);

--
-- Constraints for table `committee_external_members`
--
ALTER TABLE `committee_external_members`
  ADD CONSTRAINT `committee_external_members_committee_id_foreign` FOREIGN KEY (`committee_id`) REFERENCES `committees` (`id`);

--
-- Constraints for table `committee_members`
--
ALTER TABLE `committee_members`
  ADD CONSTRAINT `committee_members_committee_id_foreign` FOREIGN KEY (`committee_id`) REFERENCES `committees` (`id`),
  ADD CONSTRAINT `committee_members_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`);

--
-- Constraints for table `committee_tasks`
--
ALTER TABLE `committee_tasks`
  ADD CONSTRAINT `committee_tasks_assigned_to_foreign` FOREIGN KEY (`assigned_to`) REFERENCES `committee_members` (`id`),
  ADD CONSTRAINT `committee_tasks_committee_id_foreign` FOREIGN KEY (`committee_id`) REFERENCES `committees` (`id`);

--
-- Constraints for table `committee_task_progress`
--
ALTER TABLE `committee_task_progress`
  ADD CONSTRAINT `committee_task_progress_committee_task_id_foreign` FOREIGN KEY (`committee_task_id`) REFERENCES `committee_tasks` (`id`);

--
-- Constraints for table `community_service_members`
--
ALTER TABLE `community_service_members`
  ADD CONSTRAINT `community_service_members_community_service_id_foreign` FOREIGN KEY (`community_service_id`) REFERENCES `community_services` (`id`),
  ADD CONSTRAINT `community_service_members_lecturer_id_foreign` FOREIGN KEY (`lecturer_id`) REFERENCES `lecturers` (`id`);

--
-- Constraints for table `conference_proceedings`
--
ALTER TABLE `conference_proceedings`
  ADD CONSTRAINT `conference_proceedings_publication_id_foreign` FOREIGN KEY (`publication_id`) REFERENCES `publications` (`id`);

--
-- Constraints for table `documents`
--
ALTER TABLE `documents`
  ADD CONSTRAINT `fk_documents_document_types1` FOREIGN KEY (`document_type_id`) REFERENCES `document_types` (`id`),
  ADD CONSTRAINT `fk_documents_users1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `document_revisions`
--
ALTER TABLE `document_revisions`
  ADD CONSTRAINT `fk_document_revisions_documents1` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`);

--
-- Constraints for table `education_histories`
--
ALTER TABLE `education_histories`
  ADD CONSTRAINT `education_histories_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`);

--
-- Constraints for table `employees`
--
ALTER TABLE `employees`
  ADD CONSTRAINT `employees_employment_status_id_foreign` FOREIGN KEY (`employment_status_id`) REFERENCES `employment_statuses` (`id`),
  ADD CONSTRAINT `employees_organization_unit_id_foreign` FOREIGN KEY (`organization_unit_id`) REFERENCES `organization_units` (`id`),
  ADD CONSTRAINT `employees_user_id_foreign` FOREIGN KEY (`id`) REFERENCES `users` (`id`);

--
-- Constraints for table `equipments`
--
ALTER TABLE `equipments`
  ADD CONSTRAINT `asset_equipment_asset_id_foreign` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`);

--
-- Constraints for table `equipment_loans`
--
ALTER TABLE `equipment_loans`
  ADD CONSTRAINT `asset_loans_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `asset_loans_asset_equipment_id_foreign` FOREIGN KEY (`equipment_id`) REFERENCES `equipments` (`id`),
  ADD CONSTRAINT `asset_loans_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`);

--
-- Constraints for table `equipment_maintenance_requests`
--
ALTER TABLE `equipment_maintenance_requests`
  ADD CONSTRAINT `asset_maintenance_requests_asset_equipment_foreign` FOREIGN KEY (`equipment_id`) REFERENCES `equipments` (`id`),
  ADD CONSTRAINT `asset_maintenance_requests_reported_by_foreign` FOREIGN KEY (`reported_by`) REFERENCES `employees` (`id`);

--
-- Constraints for table `equipment_maintenance_request_log`
--
ALTER TABLE `equipment_maintenance_request_log`
  ADD CONSTRAINT `fk_equipment_maintenance_request_log_employees1` FOREIGN KEY (`logged_by`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `fk_equipment_maintenance_request_log_employees2` FOREIGN KEY (`verified_by`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `fk_equipment_maintenance_request_log_equipment_maintenance_re1` FOREIGN KEY (`equipment_maintenance_request_id`) REFERENCES `equipment_maintenance_requests` (`id`);

--
-- Constraints for table `equipment_procurements`
--
ALTER TABLE `equipment_procurements`
  ADD CONSTRAINT `asset_equipment_procurements_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `employees` (`id`);

--
-- Constraints for table `equipment_proc_items`
--
ALTER TABLE `equipment_proc_items`
  ADD CONSTRAINT `asset_equipment_proc_items_asset_equipment_proc_id_foreign` FOREIGN KEY (`equipment_proc_id`) REFERENCES `equipment_procurements` (`id`);

--
-- Constraints for table `equipment_requests`
--
ALTER TABLE `equipment_requests`
  ADD CONSTRAINT `asset_equipment_requests_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `asset_equipment_requests_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`);

--
-- Constraints for table `events`
--
ALTER TABLE `events`
  ADD CONSTRAINT `events_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `employees` (`id`);

--
-- Constraints for table `event_attendances`
--
ALTER TABLE `event_attendances`
  ADD CONSTRAINT `event_attendances_checked_by_foreign` FOREIGN KEY (`checked_by`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `event_attendances_event_registration_id_foreign` FOREIGN KEY (`event_registration_id`) REFERENCES `event_registrations` (`id`);

--
-- Constraints for table `event_committee_members`
--
ALTER TABLE `event_committee_members`
  ADD CONSTRAINT `event_committee_members_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `event_committee_members_event_id_foreign` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`);

--
-- Constraints for table `event_documents`
--
ALTER TABLE `event_documents`
  ADD CONSTRAINT `event_documents_event_id_foreign` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`),
  ADD CONSTRAINT `event_documents_uploaded_by_foreign` FOREIGN KEY (`uploaded_by`) REFERENCES `employees` (`id`);

--
-- Constraints for table `event_registrations`
--
ALTER TABLE `event_registrations`
  ADD CONSTRAINT `event_registrations_event_id_foreign` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`),
  ADD CONSTRAINT `event_registrations_generated_by_foreign` FOREIGN KEY (`generated_by`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `event_registrations_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `event_reminders`
--
ALTER TABLE `event_reminders`
  ADD CONSTRAINT `event_reminders_event_id_foreign` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`),
  ADD CONSTRAINT `event_reminders_sent_by_foreign` FOREIGN KEY (`sent_by`) REFERENCES `employees` (`id`);

--
-- Constraints for table `follow_up`
--
ALTER TABLE `follow_up`
  ADD CONSTRAINT `follow_up_ibfk_1` FOREIGN KEY (`potential_partner_id`) REFERENCES `potential_partners_backup_1782124193798` (`id`),
  ADD CONSTRAINT `follow_up_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `implementation_arrangements`
--
ALTER TABLE `implementation_arrangements`
  ADD CONSTRAINT `implementation_arrangements_partnership_id_foreign` FOREIGN KEY (`partnership_id`) REFERENCES `partnerships` (`id`),
  ADD CONSTRAINT `implementation_arrangements_partnership_impl_id_foreign` FOREIGN KEY (`partnership_impl_id`) REFERENCES `partnership_implementations` (`id`);

--
-- Constraints for table `inventories`
--
ALTER TABLE `inventories`
  ADD CONSTRAINT `inventories_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`);

--
-- Constraints for table `inventory_procurements`
--
ALTER TABLE `inventory_procurements`
  ADD CONSTRAINT `inventory_procurements_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `employees` (`id`);

--
-- Constraints for table `inventory_procurement_items`
--
ALTER TABLE `inventory_procurement_items`
  ADD CONSTRAINT `inventory_procurement_items_inventory_procurement_id_foreign` FOREIGN KEY (`inventory_procurement_id`) REFERENCES `inventory_procurements` (`id`),
  ADD CONSTRAINT `inventory_procurement_items_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`);

--
-- Constraints for table `inventory_purchases`
--
ALTER TABLE `inventory_purchases`
  ADD CONSTRAINT `inventory_purchases_inventory_procurement_id_foreign` FOREIGN KEY (`inventory_procurement_id`) REFERENCES `inventory_procurements` (`id`);

--
-- Constraints for table `inventory_purchase_items`
--
ALTER TABLE `inventory_purchase_items`
  ADD CONSTRAINT `inventory_purchase_items_inventory_purchase_id_foreign` FOREIGN KEY (`inventory_purchase_id`) REFERENCES `inventory_purchases` (`id`),
  ADD CONSTRAINT `inventory_purchase_items_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`);

--
-- Constraints for table `inventory_requests`
--
ALTER TABLE `inventory_requests`
  ADD CONSTRAINT `inventory_requests_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `inventory_requests_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`);

--
-- Constraints for table `inventory_request_approvals`
--
ALTER TABLE `inventory_request_approvals`
  ADD CONSTRAINT `inventory_request_approvals_approver_id_foreign` FOREIGN KEY (`approver_id`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `inventory_request_approvals_inventory_request_id_foreign` FOREIGN KEY (`inventory_request_id`) REFERENCES `inventory_requests` (`id`);

--
-- Constraints for table `inventory_request_details`
--
ALTER TABLE `inventory_request_details`
  ADD CONSTRAINT `inventory_request_details_inventory_request_id_foreign` FOREIGN KEY (`inventory_request_id`) REFERENCES `inventory_requests` (`id`),
  ADD CONSTRAINT `inventory_request_details_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`);

--
-- Constraints for table `inventory_transactions`
--
ALTER TABLE `inventory_transactions`
  ADD CONSTRAINT `inventory_transactions_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`);

--
-- Constraints for table `job_responsibilities`
--
ALTER TABLE `job_responsibilities`
  ADD CONSTRAINT `job_responsibilities_structural_position_id_foreign` FOREIGN KEY (`structural_position_id`) REFERENCES `structural_positions` (`id`);

--
-- Constraints for table `journal_publications`
--
ALTER TABLE `journal_publications`
  ADD CONSTRAINT `journal_publications_publication_id_foreign` FOREIGN KEY (`publication_id`) REFERENCES `publications` (`id`);

--
-- Constraints for table `leave_approvals`
--
ALTER TABLE `leave_approvals`
  ADD CONSTRAINT `leave_approvals_approver_id_foreign` FOREIGN KEY (`approver_id`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `leave_approvals_leave_request_id_foreign` FOREIGN KEY (`leave_request_id`) REFERENCES `leave_requests` (`id`);

--
-- Constraints for table `leave_balances`
--
ALTER TABLE `leave_balances`
  ADD CONSTRAINT `leave_balances_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `leave_balances_leave_type_id_foreign` FOREIGN KEY (`leave_type_id`) REFERENCES `leave_types` (`id`);

--
-- Constraints for table `leave_requests`
--
ALTER TABLE `leave_requests`
  ADD CONSTRAINT `leave_requests_approver_id_foreign` FOREIGN KEY (`approver_id`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `leave_requests_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `leave_requests_leave_type_id_foreign` FOREIGN KEY (`leave_type_id`) REFERENCES `leave_types` (`id`);

--
-- Constraints for table `lecturers`
--
ALTER TABLE `lecturers`
  ADD CONSTRAINT `lecturers_employee_id_foreign` FOREIGN KEY (`id`) REFERENCES `employees` (`id`);

--
-- Constraints for table `lecturer_functional_positions`
--
ALTER TABLE `lecturer_functional_positions`
  ADD CONSTRAINT `lecturer_functional_positions_functional_position_id_foreign` FOREIGN KEY (`functional_position_id`) REFERENCES `functional_positions` (`id`),
  ADD CONSTRAINT `lecturer_functional_positions_lecturer_id_foreign` FOREIGN KEY (`lecturer_id`) REFERENCES `lecturers` (`id`);

--
-- Constraints for table `meetings`
--
ALTER TABLE `meetings`
  ADD CONSTRAINT `meetings_asset_room_id_foreign` FOREIGN KEY (`asset_room_id`) REFERENCES `rooms` (`id`),
  ADD CONSTRAINT `meetings_committee_id_foreign` FOREIGN KEY (`committee_id`) REFERENCES `committees` (`id`),
  ADD CONSTRAINT `meetings_leader_id_foreign` FOREIGN KEY (`leader_id`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `meetings_organizer_id_foreign` FOREIGN KEY (`organizer_id`) REFERENCES `employees` (`id`);

--
-- Constraints for table `meeting_consumption_requests`
--
ALTER TABLE `meeting_consumption_requests`
  ADD CONSTRAINT `meeting_consumption_requests_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `meeting_consumption_requests_meeting_id_foreign` FOREIGN KEY (`meeting_id`) REFERENCES `meetings` (`id`);

--
-- Constraints for table `meeting_documents`
--
ALTER TABLE `meeting_documents`
  ADD CONSTRAINT `meeting_documents_meeting_id_foreign` FOREIGN KEY (`meeting_id`) REFERENCES `meetings` (`id`),
  ADD CONSTRAINT `meeting_documents_uploaded_by_foreign` FOREIGN KEY (`uploaded_by`) REFERENCES `employees` (`id`);

--
-- Constraints for table `meeting_external_participants`
--
ALTER TABLE `meeting_external_participants`
  ADD CONSTRAINT `meeting_external_participants_meeting_id_foreign` FOREIGN KEY (`meeting_id`) REFERENCES `meetings` (`id`);

--
-- Constraints for table `meeting_minutes`
--
ALTER TABLE `meeting_minutes`
  ADD CONSTRAINT `meeting_minutes_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `meeting_minutes_meeting_id_foreign` FOREIGN KEY (`meeting_id`) REFERENCES `meetings` (`id`);

--
-- Constraints for table `meeting_participants`
--
ALTER TABLE `meeting_participants`
  ADD CONSTRAINT `meeting_participants_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `meeting_participants_meeting_id_foreign` FOREIGN KEY (`meeting_id`) REFERENCES `meetings` (`id`);

--
-- Constraints for table `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `mou`
--
ALTER TABLE `mou`
  ADD CONSTRAINT `mou_ibfk_1` FOREIGN KEY (`potential_partner_id`) REFERENCES `potential_partners_backup_1782124193798` (`id`),
  ADD CONSTRAINT `mou_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `nomenclature_classifications`
--
ALTER TABLE `nomenclature_classifications`
  ADD CONSTRAINT `nomenclature_classifications_nomenclature_id_foreign` FOREIGN KEY (`nomenclature_id`) REFERENCES `nomenclatures` (`id`);

--
-- Constraints for table `official_travel`
--
ALTER TABLE `official_travel`
  ADD CONSTRAINT `official_travel_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `official_travel_submitted_by_foreign` FOREIGN KEY (`submitted_by`) REFERENCES `employees` (`id`);

--
-- Constraints for table `official_travel_approvals`
--
ALTER TABLE `official_travel_approvals`
  ADD CONSTRAINT `official_travel_approvals_approver_id_foreign` FOREIGN KEY (`approver_id`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `official_travel_approvals_official_travel_id_foreign` FOREIGN KEY (`official_travel_id`) REFERENCES `official_travels` (`id`);

--
-- Constraints for table `official_travel_documents`
--
ALTER TABLE `official_travel_documents`
  ADD CONSTRAINT `official_travel_documents_official_travel_id_foreign` FOREIGN KEY (`official_travel_id`) REFERENCES `official_travels` (`id`);

--
-- Constraints for table `official_travel_itineraries`
--
ALTER TABLE `official_travel_itineraries`
  ADD CONSTRAINT `official_travel_itineraries_official_travel_id_foreign` FOREIGN KEY (`official_travel_id`) REFERENCES `official_travels` (`id`);

--
-- Constraints for table `official_travel_members`
--
ALTER TABLE `official_travel_members`
  ADD CONSTRAINT `official_travel_members_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `official_travel_members_official_travel_id_foreign` FOREIGN KEY (`official_travel_id`) REFERENCES `official_travels` (`id`);

--
-- Constraints for table `organization_units`
--
ALTER TABLE `organization_units`
  ADD CONSTRAINT `organization_units_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `organization_units` (`id`);

--
-- Constraints for table `overtime_approval_logs`
--
ALTER TABLE `overtime_approval_logs`
  ADD CONSTRAINT `overtime_approval_logs_approver_id_foreign` FOREIGN KEY (`approver_id`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `overtime_approval_logs_overtime_request_id_foreign` FOREIGN KEY (`overtime_request_id`) REFERENCES `overtime_requests` (`id`);

--
-- Constraints for table `overtime_requests`
--
ALTER TABLE `overtime_requests`
  ADD CONSTRAINT `overtime_requests_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `overtime_requests_submitted_by_foreign` FOREIGN KEY (`submitted_by`) REFERENCES `employees` (`id`);

--
-- Constraints for table `overtime_request_members`
--
ALTER TABLE `overtime_request_members`
  ADD CONSTRAINT `overtime_request_members_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `overtime_request_members_overtime_request_id_foreign` FOREIGN KEY (`overtime_request_id`) REFERENCES `overtime_requests` (`id`);

--
-- Constraints for table `partnerships`
--
ALTER TABLE `partnerships`
  ADD CONSTRAINT `partnerships_partner_id_foreign` FOREIGN KEY (`partner_id`) REFERENCES `partners` (`id`),
  ADD CONSTRAINT `partnerships_partner_potential_id_foreign` FOREIGN KEY (`partner_potential_id`) REFERENCES `partner_potentials` (`id`);

--
-- Constraints for table `partnership_documents`
--
ALTER TABLE `partnership_documents`
  ADD CONSTRAINT `partnership_documents_partnership_id_foreign` FOREIGN KEY (`partnership_id`) REFERENCES `partnerships` (`id`);

--
-- Constraints for table `partnership_implementations`
--
ALTER TABLE `partnership_implementations`
  ADD CONSTRAINT `partnership_implementations_partnership_id_foreign` FOREIGN KEY (`partnership_id`) REFERENCES `partnerships` (`id`);

--
-- Constraints for table `partner_contacts`
--
ALTER TABLE `partner_contacts`
  ADD CONSTRAINT `partner_contacts_partner_id_foreign` FOREIGN KEY (`partner_id`) REFERENCES `partners` (`id`);

--
-- Constraints for table `partner_follow_ups`
--
ALTER TABLE `partner_follow_ups`
  ADD CONSTRAINT `partner_follow_ups_conducted_by_foreign` FOREIGN KEY (`conducted_by`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `partner_follow_ups_partner_potential_id_foreign` FOREIGN KEY (`partner_potential_id`) REFERENCES `partner_potentials` (`id`);

--
-- Constraints for table `partner_potentials`
--
ALTER TABLE `partner_potentials`
  ADD CONSTRAINT `partner_potentials_partner_id_foreign` FOREIGN KEY (`partner_id`) REFERENCES `partners` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `partner_potential_fields`
--
ALTER TABLE `partner_potential_fields`
  ADD CONSTRAINT `partner_potential_fields_partner_potential_id_foreign` FOREIGN KEY (`partner_potential_id`) REFERENCES `partner_potentials` (`id`);

--
-- Constraints for table `publications`
--
ALTER TABLE `publications`
  ADD CONSTRAINT `publications_research_id_foreign` FOREIGN KEY (`research_id`) REFERENCES `research` (`id`);

--
-- Constraints for table `publication_authors`
--
ALTER TABLE `publication_authors`
  ADD CONSTRAINT `publication_authors_lecturer_id_foreign` FOREIGN KEY (`lecturer_id`) REFERENCES `lecturers` (`id`),
  ADD CONSTRAINT `publication_authors_publication_id_foreign` FOREIGN KEY (`publication_id`) REFERENCES `publications` (`id`);

--
-- Constraints for table `research_members`
--
ALTER TABLE `research_members`
  ADD CONSTRAINT `research_members_lecturer_id_foreign` FOREIGN KEY (`lecturer_id`) REFERENCES `lecturers` (`id`),
  ADD CONSTRAINT `research_members_research_id_foreign` FOREIGN KEY (`research_id`) REFERENCES `research` (`id`);

--
-- Constraints for table `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD CONSTRAINT `rhp_permission_fk` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `rhp_role_fk` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `rooms`
--
ALTER TABLE `rooms`
  ADD CONSTRAINT `asset_rooms_asset_id_foreign` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`),
  ADD CONSTRAINT `asset_rooms_building_id_foreign` FOREIGN KEY (`building_id`) REFERENCES `buildings` (`id`),
  ADD CONSTRAINT `asset_rooms_responsible_employee_id_foreign` FOREIGN KEY (`responsible_employee_id`) REFERENCES `employees` (`id`);

--
-- Constraints for table `room_loans`
--
ALTER TABLE `room_loans`
  ADD CONSTRAINT `room_loans_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `room_loans_asset_room_id_foreign` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`),
  ADD CONSTRAINT `room_loans_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`);

--
-- Constraints for table `room_maintenance_requests`
--
ALTER TABLE `room_maintenance_requests`
  ADD CONSTRAINT `room_maintenance_requests_asset_room_id_foreign` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`),
  ADD CONSTRAINT `room_maintenance_requests_reported_by_foreign` FOREIGN KEY (`reported_by`) REFERENCES `employees` (`id`);

--
-- Constraints for table `room_maintenance_request_log`
--
ALTER TABLE `room_maintenance_request_log`
  ADD CONSTRAINT `fk_room_maintenance_request_log_employees1` FOREIGN KEY (`logged_by`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `fk_room_maintenance_request_log_employees2` FOREIGN KEY (`verified_by`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `fk_room_maintenance_request_log_room_maintenance_requests1` FOREIGN KEY (`room_maintenance_request_id`) REFERENCES `room_maintenance_requests` (`id`);

--
-- Constraints for table `staff`
--
ALTER TABLE `staff`
  ADD CONSTRAINT `staff_employee_id_foreign` FOREIGN KEY (`id`) REFERENCES `employees` (`id`);

--
-- Constraints for table `staff_nomenclature_histories`
--
ALTER TABLE `staff_nomenclature_histories`
  ADD CONSTRAINT `staff_nomenclature_histories_nomenclature_class_id_foreign` FOREIGN KEY (`nomenclature_class_id`) REFERENCES `nomenclature_classifications` (`id`),
  ADD CONSTRAINT `staff_nomenclature_histories_staff_id_foreign` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`);

--
-- Constraints for table `structural_positions`
--
ALTER TABLE `structural_positions`
  ADD CONSTRAINT `structural_positions_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `structural_positions` (`id`);

--
-- Constraints for table `structural_position_histories`
--
ALTER TABLE `structural_position_histories`
  ADD CONSTRAINT `structural_position_histories_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `structural_position_histories_structural_position_id_foreign` FOREIGN KEY (`structural_position_id`) REFERENCES `structural_positions` (`id`);

--
-- Constraints for table `students`
--
ALTER TABLE `students`
  ADD CONSTRAINT `fk_students_lecturers1` FOREIGN KEY (`advisor_id`) REFERENCES `lecturers` (`id`),
  ADD CONSTRAINT `fk_students_organization_units1` FOREIGN KEY (`department_id`) REFERENCES `organization_units` (`id`),
  ADD CONSTRAINT `fk_students_users` FOREIGN KEY (`id`) REFERENCES `users` (`id`);

--
-- Constraints for table `student_requests`
--
ALTER TABLE `student_requests`
  ADD CONSTRAINT `fk_student_requests_students1` FOREIGN KEY (`requested_by`) REFERENCES `students` (`id`);

--
-- Constraints for table `student_request_active_references`
--
ALTER TABLE `student_request_active_references`
  ADD CONSTRAINT `fk_student_request_recomendations_employees1` FOREIGN KEY (`signed_by`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `fk_student_request_recomendations_employees2` FOREIGN KEY (`checked_by`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `fk_student_request_recomendations_student_requests1` FOREIGN KEY (`student_requests_id`) REFERENCES `student_requests` (`id`);

--
-- Constraints for table `surveys`
--
ALTER TABLE `surveys`
  ADD CONSTRAINT `surveys_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `employees` (`id`);

--
-- Constraints for table `survey_answers`
--
ALTER TABLE `survey_answers`
  ADD CONSTRAINT `survey_answers_survey_question_id_foreign` FOREIGN KEY (`survey_question_id`) REFERENCES `survey_questions` (`id`),
  ADD CONSTRAINT `survey_answers_survey_response_id_foreign` FOREIGN KEY (`survey_response_id`) REFERENCES `survey_responses` (`id`);

--
-- Constraints for table `survey_answer_options`
--
ALTER TABLE `survey_answer_options`
  ADD CONSTRAINT `survey_answer_options_survey_answer_id_foreign` FOREIGN KEY (`survey_answer_id`) REFERENCES `survey_answers` (`id`),
  ADD CONSTRAINT `survey_answer_options_survey_question_option_id_foreign` FOREIGN KEY (`survey_question_option_id`) REFERENCES `survey_question_options` (`id`);

--
-- Constraints for table `survey_invitations`
--
ALTER TABLE `survey_invitations`
  ADD CONSTRAINT `survey_invitations_survey_id_foreign` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`id`);

--
-- Constraints for table `survey_question_assignments`
--
ALTER TABLE `survey_question_assignments`
  ADD CONSTRAINT `survey_question_assignments_survey_id_foreign` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`id`),
  ADD CONSTRAINT `survey_question_assignments_survey_question_id_foreign` FOREIGN KEY (`survey_question_id`) REFERENCES `survey_questions` (`id`);

--
-- Constraints for table `survey_question_options`
--
ALTER TABLE `survey_question_options`
  ADD CONSTRAINT `survey_question_options_survey_question_id_foreign` FOREIGN KEY (`survey_question_id`) REFERENCES `survey_questions` (`id`);

--
-- Constraints for table `survey_responses`
--
ALTER TABLE `survey_responses`
  ADD CONSTRAINT `survey_responses_survey_id_foreign` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`id`),
  ADD CONSTRAINT `survey_responses_survey_invitation_id_foreign` FOREIGN KEY (`survey_invitation_id`) REFERENCES `survey_invitations` (`id`);

--
-- Constraints for table `travel_cost_standards`
--
ALTER TABLE `travel_cost_standards`
  ADD CONSTRAINT `travel_cost_standards_city_id_foreign` FOREIGN KEY (`city_id`) REFERENCES `cities` (`id`),
  ADD CONSTRAINT `travel_cost_standards_employee_grade_id_foreign` FOREIGN KEY (`employee_grade_id`) REFERENCES `employee_grades` (`id`),
  ADD CONSTRAINT `travel_cost_standards_structural_position_id_foreign` FOREIGN KEY (`structural_position_id`) REFERENCES `structural_positions` (`id`),
  ADD CONSTRAINT `travel_cost_standards_travel_cost_component_id_foreign` FOREIGN KEY (`travel_cost_component_id`) REFERENCES `travel_cost_components` (`id`);

--
-- Constraints for table `travel_expenses`
--
ALTER TABLE `travel_expenses`
  ADD CONSTRAINT `travel_expenses_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `travel_expenses_official_travel_id_foreign` FOREIGN KEY (`official_travel_id`) REFERENCES `official_travels` (`id`),
  ADD CONSTRAINT `travel_expenses_travel_cost_component_id_foreign` FOREIGN KEY (`travel_cost_component_id`) REFERENCES `travel_cost_components` (`id`);

--
-- Constraints for table `user_has_roles`
--
ALTER TABLE `user_has_roles`
  ADD CONSTRAINT `uhr_role_fk` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `uhr_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
