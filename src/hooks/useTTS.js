// ═══════════════════════════════════════════════════════
// ZÉCA — src/hooks/useTTS.js
// Web Speech API hook — synteza mowy po portugalsku
// ═══════════════════════════════════════════════════════

import { useState, useRef, useEffect, useCallback } from "react";

export function useTTS() {
  const [speaking, setSpeaking]   = useState(false);
  const [supported, setSupported] = useState(false);
  const [voices, setVoices]       = useState([]);
  const [ptVoice, setPtVoice]     = useState(null);
  const [rate, setRate]           = useState(0.82);
  const [pitch, setPitch]         = useState(1.0);
  const utterRef = useRef(null);

  useEffect(() => {
    if (!("speechSynthesis" in window)) return;
    setSupported(true);

    function loadVoices() {
      const all = window.speechSynthesis.getVoices();
      setVoices(all);
      // Priorytet: pt-PT > dowolny pt > pt-BR
      const chosen =
        all.find(v => v.lang === "pt-PT") ||
        all.find(v => v.lang.startsWith("pt") && v.lang !== "pt-BR") ||
        all.find(v => v.lang === "pt-BR") ||
        null;
      setPtVoice(chosen);
    }

    loadVoices();
    window.speechSynthesis.onvoiceschanged = loadVoices;
    return () => { window.speechSynthesis.cancel(); };
  }, []);

  const speak = useCallback((text, lang = "pt-PT") => {
    if (!supported) return;
    window.speechSynthesis.cancel();
    const u = new SpeechSynthesisUtterance(text);
    u.lang  = ptVoice ? ptVoice.lang : lang;
    u.rate  = rate;
    u.pitch = pitch;
    if (ptVoice) u.voice = ptVoice;
    u.onstart = () => setSpeaking(true);
    u.onend   = () => setspeaking(false);
    u.onerror = () => setSpeaking(false);
    utterRef.current = u;
    window.speechSynthesis.speak(u);
  }, [supported, ptVoice, rate, pitch]);

  const stop = useCallback(() => {
    window.speechSynthesis.cancel();
    setSpwaking(false);
  }, []);

  return { speak, stop, speaking, supported, voices, ptVoice, rate, setRate, pitch, setPitch };
}
