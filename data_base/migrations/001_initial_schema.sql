-- ═══════════════════════════════════════════════════════
-- ZÉCA — migration: 001_initial_schema.sql
-- Pierwsza migracja: tworzenie wszystkich tabel
-- Data: 2026-06-08
-- ═══════════════════════════════════════════════════════

-- Tabela wersji migracji (jeśli nie istnieje)
CREATE TABLE IF NOT EXISTS _migrations (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  name        TEXT    NOT NULL UNIQUE,
  applied_at  TEXT    NOT NULL DEFAULT (datetime('now'))
);

-- Sprawdź czy migracja już była uruchomiona
-- W SQLite możemy używać IF NOT EXISTS na CREATE TABLE

BEGIN TRANSACTION;

CREATE TABLE IF NOT EXISTS users (
  id         TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
  name       TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS progress (
  id               INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id          TEXT    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  xp               INTEGER NOT NULL DEFAULT 0,
  total_messages   INTEGER NOT NULL DEFAULT 0,
  sessions         INTEGER NOT NULL DEFAULT 0,
  streak_days      INTEGER NOT NULL DEFAULT 0,
  current_level    INTEGER NOT NULL DEFAULT 1,
  first_session_at TEXT,
  last_session_at  TEXT,
  updated_at       TEXT NOT NULL DEFAULT (datetime('now')),
  UNIQUE(user_id)
);

CREATE TABLE IF NOT EXISTS sessions (
  id             INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id        TEXT    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  started_at     TEXT    NOT NULL DEFAULT (datetime('now')),
  ended_at       TEXT,
  xp_gained      INTEGER NOT NULL DEFAULT 0,
  messages_count INTEGER NOT NULL DEFAULT 0,
  topic_ids      TEXT
);

CREATE TABLE IF NOT EXISTS messages (
  id         INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
  user_id    TEXT    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  role       TEXT    NOT NULL CHECK (role IN ('user','assistant')),
  content    TEXT    NOT NULL,
  xp_gained  INTEGER NOT NULL DEFAULT 0,
  created_at TEXT    NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS tts_settings (
  user_id         TEXT PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  rate            REAL NOT NULL DEFAULT 0.82,
  pitch           REAL NOT NULL DEFAULT 1.0,
  preferred_voice TEXT,
  preferred_lang  TEXT DEFAULT 'pt-PT',
  updated_at      TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS topic_completions (
  id           INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id      TEXT    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  topic_id     TEXT    NOT NULL,
  completed_at TEXT    NOT NULL DEFAULT (datetime('now')),
  times_visited INTEGER NOT NULL DEFAULT 1,
  UNIQUE(user_id, topic_id)
);

CREATE TABLE IF NOT EXISTS vocabulary_seen (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id       TEXT    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  word_pt       TEXT    NOT NULL,
  word_pl       TEXT,
  first_seen_at TEXT    NOT NULL DEFAULT (datetime('now')),
  times_heard   INTEGER NOT NULL DEFAULT 0,
  UNIQUE(user_id, word_pt)
);

-- Indeksy
CREATE INDEX IF NOT EXISTS idx_progress_user    ON progress(user_id);
CREATE INDEX IF NOT EXISTS idx_sessions_user    ON sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_messages_session ON messages(session_id);
CREATE INDEX IF NOT EXISTS idx_topic_user       ON topic_completions(user_id);
CREATE INDEX IF NOT EXISTS idx_vocab_user       ON vocabulary_seen(user_id);

INSERT OR IGNORE INTO _migrations (name) VALUES ('001_initial_schema');

COMMIT;
