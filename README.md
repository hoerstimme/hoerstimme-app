# 🇩🇪 README (Deutsch)

## 🎙 Hörstimme App

Diese Anwendung ermöglicht die Verarbeitung und Transformation von Sprache direkt im Browser.

Die komplette Anwendung (Backend, Frontend und Datenbank) wird automatisch über Docker gestartet.

## 🌐 Live-Demo

👉 [https://hoerstimme.demo.sinceare.com](https://hoerstimme.demo.sinceare.com)

## 📥 Download / Installation

Die Anwendung muss aus folgendem Repository bezogen werden:

👉 https://github.com/hoerstimme/hoerstimme-app

### Option A: Download als ZIP (empfohlen für Nutzer)
- Öffne den Link oben
- Klicke auf Code → Download ZIP
- ZIP-Datei entpacken

### Option B: Mit Git klonen (für Entwickler)
```
git clone --recurse-submodules https://github.com/hoerstimme/hoerstimme-app.git
cd hoerstimme-app
```

Falls die Submodules nicht geladen wurden:
```
git submodule update --init --recursive
```

## 🚀 Schnellstart (für Nutzer)

### 1️⃣ Einmalige Einrichtung
Stelle sicher, dass Docker Desktop installiert ist.  
Führe aus:

**👉 Windows**  
Doppelklick auf: `scripts/Install_Hoerstimme.bat`

**👉 Mac**  
Doppelklick auf: `scripts/Install_Hoerstimme.command`

### 2️⃣ Anwendung starten

**👉 Windows**  
Doppelklick auf: `scripts/Start_Hoerstimme.bat`

**👉 Mac**  
Doppelklick auf: `scripts/Start_Hoerstimme.command`

➡️ Die Anwendung wird automatisch gestartet  
➡️ Der Browser öffnet sich selbstständig

### 3️⃣ Anwendung stoppen

**👉 Windows**  
Doppelklick auf: `scripts/Stop_Hoerstimme.bat`

**👉 Mac**  
Doppelklick auf: `scripts/Stop_Hoerstimme.command`

## 🧰 Voraussetzungen
- Docker Desktop  
  https://www.docker.com/products/docker-desktop

## ⚙️ Konfiguration (.env)

Im Ordner `voice_bridge_be/` muss eine `.env` Datei vorhanden sein.

Wichtig ist insbesondere:
```
ELEVEN_LABS_API_KEY=your_api_key_here
```

Weitere Variablen können erforderlich sein (siehe Backend-Repository).

## 📦 Projektstruktur
```
hoerstimme-app/
  scripts/              → Start-/Stop-/Setup-Skripte
  voice_bridge_be/      → Backend (Docker)
  voice_bridge_fe/      → Frontend (Docker)
```

## 💡 Hinweise
- Beim ersten Start kann es etwas länger dauern (Docker Build)
- Danach startet die App deutlich schneller
- Internetverbindung wird benötigt (API-Zugriffe)

---

# 🇬🇧 README (English)

## 🎙 Hörstimme App

This application enables real-time speech processing and transformation directly in the browser.

The full stack (backend, frontend, and database) is automatically started using Docker.

## 🌐 Live Demo

👉 [https://hoerstimme.demo.sinceare.com](https://hoerstimme.demo.sinceare.com)


## 📥 Download / Installation

The application must be obtained from this repository:

👉 https://github.com/hoerstimme/hoerstimme-app

### Option A: Download as ZIP (recommended for users)
- Open the link above
- Click Code → Download ZIP
- Extract the ZIP file

### Option B: Clone via Git (for developers)
```
git clone --recurse-submodules https://github.com/hoerstimme/hoerstimme-app.git
cd hoerstimme-app
```

If submodules are missing:
```
git submodule update --init --recursive
```

## 🚀 Quick Start (for users)

### 1️⃣ Initial setup (one-time)
Make sure Docker Desktop is installed.

**👉 Windows**  
Double-click: `scripts/Setup-Hoerstimme.bat`

**👉 Mac**  
Double-click: `scripts/Setup-Hoerstimme.command`

### 2️⃣ Start the application

**👉 Windows**  
Double-click: `scripts/Start_Hoerstimme.bat`

**👉 Mac**  
Double-click: `scripts/Start_Hoerstimme.command`

➡️ The application starts automatically  
➡️ Your browser opens automatically

### 3️⃣ Stop the application

**👉 Windows**  
Double-click: `scripts/Stop_Hoerstimme.bat`

**👉 Mac**  
Double-click: `scripts/Stop_Hoerstimme.command`

## 🧰 Requirements
- Docker Desktop  
  https://www.docker.com/products/docker-desktop

## ⚙️ Configuration (.env)

In the folder `voice_bridge_be/`, a `.env` file must exist.

Important:
```
ELEVEN_LABS_API_KEY=your_api_key_here
```

Other variables may be required (see backend repository).

## 📦 Project structure
```
hoerstimme-app/
  scripts/              → start/stop/setup scripts
  voice_bridge_be/      → backend (Docker)
  voice_bridge_fe/      → frontend (Docker)
```

## 💡 Notes
- First startup may take longer (Docker build)
- Subsequent starts are faster

## 🪪 License

The software is released under the [PolyForm Noncommercial License 1.0.0](https://polyformproject.org/licenses/noncommercial/1.0.0/),  
which permits noncommercial use, modification, and distribution.

That means:

- ✅ You can **view, clone, and modify** the code for **personal, academic, or research use**.
- 🚫 You **cannot use, sell, or integrate** this code in **commercial applications**.
- 🧠 You must **include this license** in any copies or derivatives.

For commercial or partnership inquiries, please contact:  
📧 ps@sinceare.com

See the full license text at:  
🔗 [PolyForm Noncommercial License 1.0.0](https://polyformproject.org/licenses/noncommercial/1.0.0/)

## 🏢 Ownership

All code and related assets in this repository are the intellectual property of  
**sinceare UG (haftungsbeschränkt)**, Berlin, Germany.