// ═══════════════════════════════════════════════════════
// ZÉCA — src/hooks/useProgress.js
// Zarządzanie postępem nauki (localStorage)
// ═══════════════════════════════════════════════════════

import { useState, useCallback } from "react";
import { STORAGE_KEY } from "../utils/storage.js";

const DEFAULT_PROGRESS = {
  xp: 0,
  totalMessages: 0,
  sessions: 0,
  streak: 1,
  firstSessionDate: null,
  lastSessionDate: null,
};

function load() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    return raw ? JSON.parse(raw) : null;
  } catch {
    return null;
  }
}

function save(data) {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
  } catch (e) {
    console.warn("ZÉCA: nie można zapisać postępu:", e);
  }
}

export function useProgress() {
  const [progress, setProgress] = useState(() => load() || { ...DEFAULT_PROGRESS });

  const bump = useCallback((xpGain) => {
    const now = new Date().toISOString();
    setProgress(prev => {
      const updated = {
        ...prev,
        xp: prev.xp + xpGain,
        totalMessages: prev.totalMessages + 1,
        lastSessionDate: now,
        firstSessionDate: prev.firstSessionDate || now,
      };
      save(updated);
      return updated;
    });
  }, []);

  const startSession = useCallback(() => {
    const now = new Date().toISOString();
    setProgress(prev => {
      const updated = {
        ...prev,
        sessions: prev.sessions + 1,
        firstSessionDate: prev.firstSessionDate || now,
        lastSessionDate: now,
      };
      save(updated);
      return updated;
    });
  }, []);

  const reset = useCallback(() => {
    const fresh = { ...DEFAULT_PROGRESS };
    setProgress(fresh);
    save(fresh);
  }, []);

  const seedInitialXp = useCallback(() => {
    setProgress(prev => {
      if (prev.xp === 0) {
        const updated = { ...prev, xp: 10 };
        save(updated);
        return updated;
      }
      return prev;
    });
  }, []);

  return { progress, bump, startSession, reset, seedInitialXp };
}
