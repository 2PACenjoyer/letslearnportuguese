// ═══════════════════════════════════════════════════════
// ZÉCA — src/utils/storage.js
// Stałe kluczy i helpery localStorage
// ═══════════════════════════════════════════════════════

export const STORAGE_KEY          = "zeca-progress-v2";
export const STORAGE_SETTINGS_KEY = "zeca-settings-v1";

export function loadJSON(key) {
  try {
    const raw = localStorage.getItem(key);
    return raw ? JSON.parse(raw) : null;
  } catch {
    return null;
  }
}

export function saveJSON(key, data) {
  try {
    localStorage.setItem(key, JSON.stringify(data));
    return true;
  } catch (e) {
    console.warn(`ZÉCA storage: nie można zapisać '${key}':`, e);
    return false;
  }
}

export function removeKey(key) {
  try { localStorage.removeItem(key); } catch {}
}

export function clearAll() {
  removeKey(STORAGE_KEY);
  removeKey(STORAGE_SETTINGS_KEY);
}
