-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 29, 2026 at 03:22 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `task_api`
--

-- --------------------------------------------------------

--
-- Table structure for table `tasks`
--

CREATE TABLE `tasks` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `due_date` date NOT NULL,
  `priority` enum('low','medium','high') NOT NULL,
  `status` enum('pending','in_progress','done') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tasks`
--

INSERT INTO `tasks` (`id`, `title`, `due_date`, `priority`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Design API', '2026-03-29', 'medium', 'pending', '2026-03-28 19:50:23', '2026-03-28 19:50:23'),
(2, 'Fix Bug', '2026-03-30', 'low', 'pending', '2026-03-28 19:50:23', '2026-03-28 19:50:23'),
(6, 'Optimize Code', '2026-04-03', 'low', 'pending', '2026-03-28 19:50:23', '2026-03-28 19:50:23'),
(15, 'Add Features', '2026-04-12', 'medium', 'done', '2026-03-28 19:50:23', '2026-03-28 20:56:03'),
(16, 'Performance Test', '2026-04-13', 'high', 'pending', '2026-03-28 19:50:23', '2026-03-28 19:50:23'),
(17, 'Setup Hosting', '2026-04-14', 'low', 'in_progress', '2026-03-28 19:50:23', '2026-03-28 19:50:23'),
(18, 'Monitor Logs', '2026-04-15', 'low', 'pending', '2026-03-28 19:50:23', '2026-03-28 19:50:23'),
(19, 'Backup Data', '2026-04-16', 'high', 'pending', '2026-03-28 19:50:23', '2026-03-28 19:50:23'),
(20, 'Final Submission', '2026-04-17', 'medium', 'pending', '2026-03-28 19:50:23', '2026-03-28 19:50:23'),
(22, 'Model deployment', '2026-04-01', 'low', 'in_progress', '2026-03-28 20:14:23', '2026-03-28 20:38:22'),
(24, 'Project Inspection', '2026-04-10', 'medium', 'in_progress', '2026-03-28 21:19:40', '2026-03-28 21:19:54');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tasks`
--
ALTER TABLE `tasks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tasks_title_due_date_unique` (`title`,`due_date`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tasks`
--
ALTER TABLE `tasks`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
