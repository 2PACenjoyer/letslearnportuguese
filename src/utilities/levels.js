// ═══════════════════════════════════════════════════════
// ZÉCA — src/utils/levels.js
// Helpery do obliczeń XP i poziomów
// ═══════════════════════════════════════════════════════

import LEVELS from "../../data/levels.json";

export { LEVELS };

/**
 * Zwraca aktualny poziom na podstawie XP
 * @param {number} xp
 * @returns {object} level
 */
export function getCurrentLevel(xp) {
  return [...LEVELS].reverse().find(l => xp >= l.xpRequired) || LEVELS[0];
}

/**
 * Zwraca następny poziom (lub null jeśli max)
 * @param {number} xp
 * @returns {object|null}
 */
export function getNextLevel(xp) {
  return LEVELS.find(l => l.xpRequired > xp) || null;
}

/**
 * Procent postępu do następnego poziomu (0–100)
 * @param {number} xp
 * @returns {number}
 */
export function getXpPercent(xp) {
  const current = getCurrentLevel(xp);
  const next    = getNextLevel(xp);
  if (!next) return 100;
  const range = next.xpRequired - current.xpRequired;
  const done  = xp - current.xpRequired;
  // Use floor (not round) and cap at 99 — bar hits 100% only at exact threshold
  return Math.min(Math.floor((done / range) * 100), 99);
}

/**
 * Losowy XP za wiadomość
 * @returns {number}
 */
export function randomXpGain() {
  return Math.floor(Math.random() * 15) + 10; // 10–24
}

/**
 * Formatuje datę ISO do polskiego formatu
 * @param {string|null} iso
 * @returns {string}
 */
export function formatDate(iso) {
  if (!iso) return "—";
  return new Date(iso).toLocaleDateString("pl-PL", {
    day: "numeric", month: "short", year: "numeric",
  });
}

/**
 * Oblicza liczbę dni od pierwszej sesji
 * @param {string|null} firstSessionDate
 * @returns {number}
 */
export function daysSinceStart(firstSessionDate) {
  if (!firstSessionDate) return 1;
  return Math.max(1, Math.ceil(
    (Date.now() - new Date(firstSessionDate)) / 86_400_000
  ));
}
