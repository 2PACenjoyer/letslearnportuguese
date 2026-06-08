// ═══════════════════════════════════════════════════════
// ZÉCA — src/utils/parseMessage.js
// Parsowanie wiadomości — wyodrębnianie znaczników {{PT:...}}
// ═══════════════════════════════════════════════════════

const PT_TAG_REGEX = /\{\{PT:\s*(.*?)\s*\}\}/g;

/**
 * Dzieli tekst wiadomości na segmenty:
 * { type: "text", content: "..." }
 * { type: "pt",   content: "Bom dia!" }
 *
 * @param {string} text
 * @returns {Array<{type: string, content: string}>}
 */
export function parseMessage(text) {
  const parts = [];
  let last = 0;
  let match;
  PT_TAG_REGEX.lastIndex = 0;

  while ((match = PT_TAG_REGEX.exec(text)) !== null) {
    if (match.index > last) {
      parts.push({ type: "text", content: text.slice(last, match.index) });
    }
    parts.push({ type: "pt", content: match[1].trim() });
    last = match.index + match[0].length;
  }

  if (last < text.length) {
    parts.push({ type: "text", content: text.slice(last) });
  }

  return parts;
}

/**
 * Wyciąga wszystkie frazy PT z tekstu jako tablicę stringów
 * @param {string} text
 * @returns {string[]}
 */
export function extractPtPhrases(text) {
  return parseMessage(text)
    .filter(p => p.type === "pt")
    .map(p => p.content);
}

/**
 * Usuwa wszystkie znaczniki {{PT:...}} z tekstu (do czystego TTS)
 * @param {string} text
 * @returns {string}
 */
export function stripPtTags(text) {
  return text.replace(/\{\{PT:\s*(.*?)\s*\}\}/g, "$1");
}

/**
 * Usuwa markdown z tekstu (bold, italic, headers)
 * @param {string} text
 * @returns {string}
 */
export function stripMarkdown(text) {
  return text
    .replace(/\*\*(.*?)\*\*/g, "$1")
    .replace(/\*(.*?)\*/g, "$1")
    .replace(/`(.*?)`/g, "$1")
    .replace(/#{1,6}\s/g, "");
}
