-- =========================
-- 1. DATABASE
-- =========================
USE BankenSystem;

-- =========================
-- 2. LOGINS (Server level)
-- =========================
CREATE LOGIN login_kreditberater WITH PASSWORD = 'Test123!';
CREATE LOGIN login_sachbearbeiter WITH PASSWORD = 'Test123!';
CREATE LOGIN login_pruefer WITH PASSWORD = 'Test123!';

-- =========================
-- 3. USERS (Database level)
-- =========================
CREATE USER kreditberater_user FOR LOGIN login_kreditberater;
CREATE USER sachbearbeiter_user FOR LOGIN login_sachbearbeiter;
CREATE USER pruefer_user FOR LOGIN login_pruefer;

-- =========================
-- 4. ROLES
-- =========================
CREATE ROLE Kreditberater;
CREATE ROLE Kreditsachbearbeiter;
CREATE ROLE Kreditpruefer;

-- =========================
-- 5. PERMISSIONS
-- =========================

-- Kreditberater (read only)
GRANT SELECT ON dbo.Kredite TO Kreditberater;
GRANT SELECT ON dbo.Kunden TO Kreditberater;

-- Kreditsachbearbeiter (read + write)
GRANT SELECT, INSERT, UPDATE ON dbo.Kredite TO Kreditsachbearbeiter;
GRANT SELECT ON dbo.Kunden TO Kreditsachbearbeiter;

-- Kreditprüfer (read + execute)
GRANT SELECT ON dbo.Kredite TO Kreditpruefer;
GRANT EXECUTE TO Kreditpruefer;

-- =========================
-- 6. ASSIGN USERS TO ROLES
-- =========================
ALTER ROLE Kreditberater ADD MEMBER kreditberater_user;
ALTER ROLE Kreditsachbearbeiter ADD MEMBER sachbearbeiter_user;
ALTER ROLE Kreditpruefer ADD MEMBER pruefer_user;