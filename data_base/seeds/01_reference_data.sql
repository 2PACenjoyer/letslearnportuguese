-- ═══════════════════════════════════════════════════════
-- ZÉCA — seeds/01_reference_data.sql
-- Dane startowe — poziomy i tematy (statyczne)
-- Uruchom po migracji 001
-- ═══════════════════════════════════════════════════════

-- Tabela statycznych poziomów (jeśli trzymamy je w DB)
CREATE TABLE IF NOT EXISTS ref_levels (
  id           INTEGER PRIMARY KEY,
  name         TEXT    NOT NULL,
  description  TEXT    NOT NULL,
  icon         TEXT    NOT NULL,
  color_hex    TEXT    NOT NULL,
  xp_required  INTEGER NOT NULL,
  xp_to_next   INTEGER           -- NULL dla ostatniego poziomu
);

INSERT OR REPLACE INTO ref_levels VALUES
  (1, 'Nível 1', 'Przetrwanie', '🌱', '#4ade80', 0,    300),
  (2, 'Nível 2', 'Codzienność', '🏙️','#60a5fa', 300,  500),
  (3, 'Nível 3', 'Rozmowa',     '💬', '#c084fc', 800,  1000),
  (4, 'Nível 4', 'Płynność',    '🎯', '#fbbf24', 1800, NULL);

-- Tabela statycznych tematów
CREATE TABLE IF NOT EXISTS ref_topics (
  id          TEXT    PRIMARY KEY,
  label       TEXT    NOT NULL,
  icon        TEXT    NOT NULL,
  level_id    INTEGER NOT NULL REFERENCES ref_levels(id),
  category    TEXT    NOT NULL,
  sort_order  INTEGER NOT NULL DEFAULT 0
);

INSERT OR REPLACE INTO ref_topics VALUES
  ('greeting',  'Powitania',  '🤝', 1, 'komunikacja',  1),
  ('numbers',   'Liczby',     '🔢', 1, 'podstawy',     2),
  ('cafe',      'Kawiarnia',  '☕', 1, 'codzienność',  3),
  ('direction', 'Droga',      '🗺️',2, 'codzienność',  4),
  ('slang',     'Slang',      '😎', 3, 'zaawansowane', 5),
  ('diff',      'EP vs BP',   '🇵🇹',1, 'teoria',      6),
  ('test',      'Test',       '📝', 1, 'ćwiczenia',    7),
  ('grammar',   'Gramatyka',  '📚', 2, 'teoria',       8),
  ('transport', 'Transport',  '🚇', 2, 'codzienność',  9),
  ('shopping',  'Zakupy',     '🛍️',2, 'codzienność', 10);

-- Demo użytkownik (tylko środowisko deweloperskie)
-- INSERT OR IGNORE INTO users (id, name) VALUES ('demo-user-001', 'Demo');
-- INSERT OR IGNORE INTO progress (user_id) VALUES ('demo-user-001');
