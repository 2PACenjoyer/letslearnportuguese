-- ═══════════════════════════════════════════════════════
-- ZÉCA — schema.sql
-- Schemat bazy danych (SQLite / PostgreSQL kompatybilny)
-- ═══════════════════════════════════════════════════════

-- ── Rozszerzenia (PostgreSQL) ──
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ══════════════════════════
-- TABELA: users
-- Profil użytkownika
-- ══════════════════════════
CREATE TABLE IF NOT EXISTS users (
  id           TEXT    PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),  -- UUID
  name         TEXT,                        -- opcjonalna nazwa
  created_at   TEXT    NOT NULL DEFAULT (datetime('now')),
  updated_at   TEXT    NOT NULL DEFAULT (datetime('now'))
);

-- ══════════════════════════
-- TABELA: progress
-- Postęp nauki użytkownika
-- ══════════════════════════
CREATE TABLE IF NOT EXISTS progress (
  id                 INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id            TEXT    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  xp                 INTEGER NOT NULL DEFAULT 0,
  total_messages     INTEGER NOT NULL DEFAULT 0,
  sessions           INTEGER NOT NULL DEFAULT 0,
  streak_days        INTEGER NOT NULL DEFAULT 0,
  current_level      INTEGER NOT NULL DEFAULT 1 CHECK (current_level BETWEEN 1 AND 4),
  first_session_at   TEXT,
  last_session_at    TEXT,
  updated_at         TEXT    NOT NULL DEFAULT (datetime('now')),
  UNIQUE(user_id)
);

-- ══════════════════════════
-- TABELA: sessions
-- Historia sesji nauki
-- ══════════════════════════
CREATE TABLE IF NOT EXISTS sessions (
  id           INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id      TEXT    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  started_at   TEXT    NOT NULL DEFAULT (datetime('now')),
  ended_at     TEXT,
  xp_gained    INTEGER NOT NULL DEFAULT 0,
  messages_count INTEGER NOT NULL DEFAULT 0,
  topic_ids    TEXT    -- JSON array, np. '["greeting","numbers"]'
);

-- ══════════════════════════
-- TABELA: messages
-- Historia wiadomości (opcjonalna — dla backupu)
-- ══════════════════════════
CREATE TABLE IF NOT EXISTS messages (
  id           INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id   INTEGER NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
  user_id      TEXT    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  role         TEXT    NOT NULL CHECK (role IN ('user', 'assistant')),
  content      TEXT    NOT NULL,
  xp_gained    INTEGER NOT NULL DEFAULT 0,
  created_at   TEXT    NOT NULL DEFAULT (datetime('now'))
);

-- ══════════════════════════
-- TABELA: tts_settings
-- Ustawienia głosu TTS
-- ══════════════════════════
CREATE TABLE IF NOT EXISTS tts_settings (
  user_id      TEXT    PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  rate         REAL    NOT NULL DEFAULT 0.82 CHECK (rate BETWEEN 0.5 AND 1.5),
  pitch        REAL    NOT NULL DEFAULT 1.0  CHECK (pitch BETWEEN 0.5 AND 2.0),
  preferred_voice TEXT,        -- nazwa głosu systemowego, np. 'Microsoft Inês'
  preferred_lang  TEXT DEFAULT 'pt-PT',
  updated_at   TEXT    NOT NULL DEFAULT (datetime('now'))
);

-- ══════════════════════════
-- TABELA: topic_completions
-- Które tematy zostały już przerobione
-- ══════════════════════════
CREATE TABLE IF NOT EXISTS topic_completions (
  id           INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id      TEXT    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  topic_id     TEXT    NOT NULL,             -- np. "greeting", "numbers"
  completed_at TEXT    NOT NULL DEFAULT (datetime('now')),
  times_visited INTEGER NOT NULL DEFAULT 1,
  UNIQUE(user_id, topic_id)
);

-- ══════════════════════════
-- TABELA: vocabulary_seen
-- Słówka które uczeń już widział
-- ══════════════════════════
CREATE TABLE IF NOT EXISTS vocabulary_seen (
  id           INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id      TEXT    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  word_pt      TEXT    NOT NULL,
  word_pl      TEXT,
  first_seen_at TEXT   NOT NULL DEFAULT (datetime('now')),
  times_heard  INTEGER NOT NULL DEFAULT 0,   -- ile razy kliknął TTS
  UNIQUE(user_id, word_pt)
);

-- ══════════════════════════
-- INDEKSY
-- ══════════════════════════
CREATE INDEX IF NOT EXISTS idx_progress_user       ON progress(user_id);
CREATE INDEX IF NOT EXISTS idx_sessions_user       ON sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_sessions_started    ON sessions(started_at);
CREATE INDEX IF NOT EXISTS idx_messages_session    ON messages(session_id);
CREATE INDEX IF NOT EXISTS idx_messages_user       ON messages(user_id);
CREATE INDEX IF NOT EXISTS idx_topic_user          ON topic_completions(user_id);
CREATE INDEX IF NOT EXISTS idx_vocab_user          ON vocabulary_seen(user_id);

-- ══════════════════════════
-- WIDOKI
-- ══════════════════════════

-- Podsumowanie postępu użytkownika
CREATE VIEW IF NOT EXISTS v_user_summary AS
  SELECT
    u.id         AS user_id,
    u.name,
    p.xp,
    p.current_level,
    p.total_messages,
    p.sessions,
    p.streak_days,
    p.first_session_at,
    p.last_session_at,
    (SELECT COUNT(*) FROM topic_completions tc WHERE tc.user_id = u.id) AS topics_visited,
    (SELECT COUNT(*) FROM vocabulary_seen   vs WHERE vs.user_id = u.id) AS words_seen
  FROM users u
  LEFT JOIN progress p ON p.user_id = u.id;
