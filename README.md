# 🚗 CarSense

**CarSense** è un'applicazione Flutter moderna per la diagnostica automotive tramite OBD-II, con supporto di intelligenza artificiale per la comprensione degli errori del veicolo.

## ✨ Features

- 📊 **Dashboard Real-time**: Visualizzazione metriche veicolo (RPM, velocità, temperatura, batteria)
- 🔍 **Scansione DTC**: Lettura codici errore OBD-II con descrizioni dettagliate
- 🤖 **Assistente AI**: Chat intelligente per supporto tecnico automotive
- 🗺️ **Mappa Officine**: Trova meccanici nelle vicinanze tramite Google Maps
- 📜 **Cronologia**: Tracciamento storico degli errori rilevati
- 🎨 **UI Moderna**: Design dark con Material 3

## 🛠️ Tecnologie

- **Flutter** 3.4+ con Dart SDK
- **Riverpod** per state management
- **Google Generative AI (Gemini)** per descrizioni DTC e chat AI
- **Google Maps Flutter** per visualizzazione officine
- **Geolocator** per posizionamento GPS
- **SharedPreferences** per persistenza locale
- **flutter_dotenv** per gestione sicura API keys

## 📋 Prerequisiti

- Flutter SDK >= 3.4.0
- Dart SDK >= 3.4.0
- Account Google Cloud con API abilitati:
  - Gemini AI API
  - Places API
  - Maps SDK for Android/iOS

## 🚀 Setup Progetto

### 1. Clone del repository

```bash
git clone https://github.com/rickvr123456/carsense.git
cd carsense
```

### 2. Installazione dipendenze

```bash
flutter pub get
```

### 3. Configurazione API Keys

**⚠️ IMPORTANTE**: Non committare mai le API keys nel repository!

1. Copia il file di esempio:
```bash
cp .env.example .env
```

2. Modifica `.env` inserendo le tue chiavi:

```env
GEMINI_API_KEY=la_tua_chiave_gemini
AI_API_KEY=la_tua_chiave_ai  # opzionale, usa GEMINI_API_KEY se non specificato
PLACES_API_KEY=la_tua_chiave_google_places
```

3. Verifica che `.env` sia nel `.gitignore`

### 4. Ottieni le API Keys

#### Gemini AI API Key
1. Vai su [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Crea un nuovo API key
3. Copia e incolla in `GEMINI_API_KEY`

#### Google Places API Key
1. Vai su [Google Cloud Console](https://console.cloud.google.com/)
2. Crea un nuovo progetto o seleziona esistente
3. Abilita **Places API** e **Maps SDK**
4. Crea credenziali (API key)
5. Copia e incolla in `PLACES_API_KEY`

### 5. Esegui l'app

```bash
flutter run
```

## 📁 Struttura Progetto

```
lib/
├── core/
│   ├── constants/       # Costanti app (stringhe, configurazione)
│   ├── models/          # Modelli dati (Dtc)
│   ├── theme/           # Tema e colori
│   ├── utils/           # Utility (formattatori, helpers)
│   └── widgets/         # Widget riutilizzabili
├── features/
│   ├── ai/              # Chat AI
│   ├── dashboard/       # Dashboard principale
│   ├── history/         # Cronologia errori
│   ├── info/            # Informazioni app
│   ├── map/             # Mappa officine
│   └── problems/        # Gestione problemi/DTC
├── services/
│   ├── ai_chat_service.dart     # Servizio chat Gemini
│   ├── error_history_service.dart
│   ├── gemini_service.dart       # Servizio descrizioni DTC
│   ├── network_helper.dart
│   └── places_service.dart
├── app_shell.dart       # Navigation shell
├── app_state.dart       # State management
├── main.dart            # Entry point
└── riverpod_providers.dart
```

## 🏗️ Architettura

Il progetto segue i principi della **Clean Architecture**:

- **Separation of Concerns**: Features isolate, services riutilizzabili
- **State Management**: Riverpod con ChangeNotifier
- **Dependency Injection**: Providers centralizzati
- **Immutabilità**: Modelli immutabili con `copyWith`
- **Error Handling**: Try-catch specifici, gestione network errors
- **Theming**: Sistema centralizzato colori e tema

## Troubleshooting

### L'app si blocca al logo Flutter

**Causa**: Il file `.env` manca o non è configurato correttamente.

**Soluzione**:
1. Verifica che il file `.env` esista nella root del progetto:
```powershell
Test-Path .env
```

2. Se manca, copialo da `.env.example`:
```powershell
Copy-Item .env.example .env
```

3. Modifica `.env` con le tue chiavi API reali.

4. Assicurati che `.env` sia dichiarato negli assets in `pubspec.yaml`:
```yaml
flutter:
  assets:
    - .env
```

5. Esegui un clean e rebuild:
```powershell
flutter clean
flutter pub get
flutter run
```

### Errore di connessione API

Se l'app si avvia ma le funzionalità AI/Maps non funzionano, verifica che le chiavi in `.env` siano valide e abilitate per i servizi corretti (Gemini API, Google Maps Platform).

