-- ═══════════════════════════════════════════════════════
-- ZÉCA — migration: 002_add_streak_tracking.sql
-- Dodaje kolumnę last_streak_date do progress
-- Data: 2026-06-08
-- ═══════════════════════════════════════════════════════

BEGIN TRANSACTION;

-- Dodaj kolumnę do śledzenia kiedy ostatnio streak był aktualizowany
ALTER TABLE progress ADD COLUMN last_streak_date TEXT;

-- Dodaj kolumnę best_streak do przechowywania rekordu
ALTER TABLE progress ADD COLUMN best_streak INTEGER NOT NULL DEFAULT 0;

INSERT OR IGNORE INTO _migrations (name) VALUES ('002_add_streak_tracking');

COMMIT;
