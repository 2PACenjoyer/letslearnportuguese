// ═══════════════════════════════════════════════════════
// ZÉCA — src/utils/api.js
// Komunikacja z Anthropic API
// ═══════════════════════════════════════════════════════

import CONFIG       from "../../data/config.json";
import SYSTEM_DATA  from "../../data/system-prompt.json";

const { endpoint, model, maxTokens } = CONFIG.api;
const SYSTEM_PROMPT = SYSTEM_DATA.prompt;

/**
 * Wysyła wiadomości do Claude i zwraca odpowiedź jako string
 * @param {Array<{role: string, content: string}>} messages
 * @returns {Promise<string>}
 */
export async function sendToAgent(messages) {
  const response = await fetch(endpoint, {
    method:  "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      model,
      max_tokens: maxTokens,
      system:     SYSTEM_PROMPT,
      messages,
    }),
  });

  if (!response.ok) {
    throw new Error(`API error ${response.status}: ${response.statusText}`);
  }

  const data = await response.json();
  return data.content?.map(b => b.text || "").join("") || "";
}

/** Wiadomość inicjująca pierwszą sesję */
export const INIT_MESSAGE = {
  role: "user",
  content: "Witaj! Chcę się nauczyć portugalskiego z Portugalii. Zacznijmy! Pamiętaj żeby oznaczać frazy do wymowy znacznikami {{PT:...}}",
};
