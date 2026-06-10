<<<<<<< HEAD
# letslearnportuguese
🇵🇹 ZÉCA — Open Source Portuguese Learning Agent
Show Image
Show Image
Show Image
AI nauczyciel europejskiego języka portugalskiego (pt-PT). Działa w przeglądarce — bez serwera, bez rejestracji. Potrzebujesz tylko własnego klucza Anthropic API.
🚀 Demo
➡️ Otwórz ZÉCA
✨ Funkcje

🗣️ Europejski portugalski (pt-PT) — akcent lisbonski, nie brazylijski
🔊 TTS — kliknij każdą frazę żeby usłyszeć wymowę (Web Speech API)
📈 System XP i 4 poziomy nauki
💾 Postęp zapisywany lokalnie (localStorage)
📱 Działa na telefonie i komputerze
🔑 Twój klucz API — tylko w Twojej przeglądarce, nigdzie nie wysyłany

📁 Struktura projektu
letslearnportuguese/
│
├── docs/                    ← GitHub Pages serwuje stąd
│   └── index.html           ← cała aplikacja (React przez CDN)
│
├── data/                    ← dane statyczne JSON
│   ├── config.json          ← ustawienia API, TTS, XP
│   ├── levels.json          ← 4 poziomy nauki
│   ├── topics.json          ← 10 tematów lekcji
│   └── system-prompt.json   ← prompt agenta ZÉCA
│
├── style/                   ← arkusze CSS
│   ├── global.css
│   ├── themes.css           ← zmienne CSS (kolory, spacing)
│   ├── animations.css
│   └── components.css
│
├── src/                     ← źródła JS (referencja / przyszły bundler)
│   ├── hooks/
│   │   ├── useTTS.js
│   │   └── useProgress.js
│   └── utils/
│       ├── api.js
│       ├── levels.js
│       ├── parseMessage.js
│       └── storage.js
│
├── data_base/               ← schemat SQL (opcjonalny backend)
│   ├── schema.sql
│   ├── migrations/
│   └── seeds/
│
├── .github/workflows/
│   └── deploy.yml           ← auto-deploy na GitHub Pages
│
└── README.md
🔧 Jak uruchomić lokalnie
bash# 1. Sklonuj repo
git clone https://github.com/2PACenjoyer/letslearnportuguese.git
cd letslearnportuguese

# 2. Otwórz w przeglądarce — zero instalacji!
# Otwórz plik docs/index.html lub użyj serwera:
npx serve docs
# → http://localhost:3000

# 3. Przy pierwszym otwarciu wpisz klucz Anthropic API
# Klucz: https://console.anthropic.com/
🌐 Deploy na GitHub Pages
Automatycznie (GitHub Actions)
Po każdym push do main GitHub Actions automatycznie deployuje zawartość folderu docs/.
Jednorazowa konfiguracja:

Wejdź w repo → Settings → Pages
Source: GitHub Actions
Zrób push — workflow uruchomi się automatycznie

Ręcznie (bez Actions)

Settings → Pages → Source: Deploy from branch
Branch: main, folder: /docs
Save

Strona będzie dostępna pod:
https://2PACenjoyer.github.io/letslearnportuguese/
🔑 Klucz API
Aplikacja wymaga klucza Anthropic API:

Załóż konto: console.anthropic.com
Utwórz klucz API
Wpisz go przy pierwszym uruchomieniu ZÉCA

Klucz jest zapisywany tylko w Twojej przeglądarce (localStorage). Nie jest nigdzie wysyłany poza bezpośrednim wywołaniem API Anthropic.
🤝 Jak współtworzyć (Contributing)

Fork tego repo
Utwórz branch: git checkout -b feature/moja-funkcja
Wprowadź zmiany i zatwierdź: git commit -m "Dodaj: opis zmiany"
Wypchnij: git push origin feature/moja-funkcja
Otwórz Pull Request

Co można ulepszyć

 Więcej tematów lekcji
 System fiszek (flashcards)
 Quiz tryb z automatyczną oceną
 Eksport postępu do pliku
 Tryb offline (Service Worker)
 Tłumaczenie UI na angielski

📄 Licencja
MIT — możesz używać, modyfikować i dystrybuować swobodnie.
=======
# if you want to learn some portuguese from Portugal, you can try my open source learning agent
>>>>>>> 3daf1f1e4afd16dd83e56e348dc2d3649e7fd19f
