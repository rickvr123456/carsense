# 🚗 CarSense - OBD-II Diagnostic Application# 🚗 CarSense - OBD-II Diagnostic Application# CarSense - OBD-II Diagnostic Application# 🚗 CarSense



OBD-II diagnostic application built with Flutter and Google Generative AI. Interprets Diagnostic Trouble Codes (DTC) through AI analysis and provides mechanics locator using Google Maps.



## ✨ FeaturesOBD-II diagnostic application built with Flutter and Google Generative AI. Interprets Diagnostic Trouble Codes (DTC) through AI analysis and provides mechanics locator using Google Maps.



- 📊 **Dashboard Real-time**: Live vehicle metrics (RPM, speed, temperature, battery)

- 🔍 **OBD-II Scanning**: Read and interpret diagnostic trouble codes with AI

- 🤖 **AI Assistant**: Interactive chat for automotive support and diagnostics## ✨ FeaturesOBD-II diagnostic application built with Flutter and Google Generative AI. Interprets Diagnostic Trouble Codes (DTC) through AI analysis and provides mechanics locator using Google Maps.**CarSense** è un'applicazione Flutter moderna per la diagnostica automotive tramite OBD-II, con supporto di intelligenza artificiale per la comprensione degli errori del veicolo.

- 🗺️ **Mechanics Locator**: Find nearby repair shops via Google Maps

- 📜 **Error History**: Track and manage error codes with timestamps

- 🎨 **Modern UI**: Material Design 3 dark theme

- 📊 **Dashboard Real-time**: Live vehicle metrics (RPM, speed, temperature, battery)

## 🛠️ Technologies

- 🔍 **OBD-II Scanning**: Read and interpret diagnostic trouble codes with AI

- **Flutter** 3.4+ with Dart SDK

- **Riverpod** - State management- 🤖 **AI Assistant**: Interactive chat for automotive support and diagnostics## Table of Contents## ✨ Features

- **Google Generative AI (Gemini)** - DTC interpretation & chat AI

- **Google Maps Flutter** - Mechanics locator- 🗺️ **Mechanics Locator**: Find nearby repair shops via Google Maps

- **Geolocator** - GPS positioning

- **SharedPreferences** - Local data persistence- 📜 **Error History**: Track and manage error codes with timestamps

- **flutter_dotenv** - Secure API key management

- 🎨 **Modern UI**: Material Design 3 dark theme

## 📋 Prerequisites

- [Overview](#overview)- 📊 **Dashboard Real-time**: Visualizzazione metriche veicolo (RPM, velocità, temperatura, batteria)

- Flutter SDK >= 3.4.0

- Dart SDK >= 3.4.0## 🛠️ Technologies

- Google Cloud Account with APIs enabled:

  - Gemini AI API- [Features](#features)- 🔍 **Scansione DTC**: Lettura codici errore OBD-II con descrizioni dettagliate

  - Google Places API

  - Google Maps SDK for Android/iOS- **Flutter** 3.4+ with Dart SDK



## 🚀 Quick Start- **Riverpod** - State management- [Project Structure](#project-structure)- 🤖 **Assistente AI**: Chat intelligente per supporto tecnico automotive



### 1. Clone Repository- **Google Generative AI (Gemini)** - DTC interpretation & chat AI



```bash- **Google Maps Flutter** - Mechanics locator- [Setup Instructions](#setup-instructions)- 🗺️ **Mappa Officine**: Trova meccanici nelle vicinanze tramite Google Maps

git clone https://github.com/rickvr123456/carsense.git

cd carsense- **Geolocator** - GPS positioning

```

- **SharedPreferences** - Local data persistence- [Technologies](#technologies)- 📜 **Cronologia**: Tracciamento storico degli errori rilevati

### 2. Install Dependencies

- **flutter_dotenv** - Secure API key management

```bash

flutter pub get- [Troubleshooting](#troubleshooting)- 🎨 **UI Moderna**: Design dark con Material 3

```

## 📋 Prerequisites

### 3. Configure API Keys



Create `.env` file in project root:

- Flutter SDK >= 3.4.0

```env

GEMINI_API_KEY=your_gemini_api_key_here- Dart SDK >= 3.4.0## Overview## 🛠️ Tecnologie

PLACES_API_KEY=your_google_places_api_key_here

```- Google Cloud Account with APIs enabled:



⚠️ **Important**: `.env` is in `.gitignore` - never commit API keys!  - Gemini AI API



**Get your API keys:**  - Google Places API

- [Gemini AI](https://makersuite.google.com/app/apikey)

- [Google Cloud Console](https://console.cloud.google.com/)  - Google Maps SDK for Android/iOSCarSense is a Flutter-based diagnostic application for vehicle owners. It reads OBD-II error codes, provides AI-powered interpretations via Google Gemini, and helps locate nearby repair mechanics through Google Maps integration. The application maintains error history and provides interactive chat support for vehicle diagnostics.- **Flutter** 3.4+ con Dart SDK



### 4. Run Application



```bash## 🚀 Quick Start- **Riverpod** per state management

flutter run

```



## 📁 Project Structure### 1. Clone Repository## Features- **Google Generative AI (Gemini)** per descrizioni DTC e chat AI



```

lib/

├── core/```bash- **Google Maps Flutter** per visualizzazione officine

│   ├── constants/       # App configuration & constants

│   ├── models/          # Data models (Dtc, etc.)git clone https://github.com/rickvr123456/carsense.git

│   ├── theme/           # Theming & colors

│   ├── utils/           # Error handling, formatterscd carsense- Live vehicle metrics dashboard (RPM, Speed, Battery Voltage, Coolant Temperature)- **Geolocator** per posizionamento GPS

│   └── widgets/         # Reusable UI components

├── features/```

│   ├── ai/              # Chat AI interface

│   ├── dashboard/       # Main dashboard- OBD-II diagnostic code detection and interpretation- **SharedPreferences** per persistenza locale

│   ├── history/         # Error history view

│   ├── info/            # App information### 2. Install Dependencies

│   ├── map/             # Mechanics locator

│   └── problems/        # DTC management- AI-powered error code analysis via Google Gemini- **flutter_dotenv** per gestione sicura API keys

├── services/

│   ├── ai_chat_service.dart        # Chat integration```bash

│   ├── error_history_service.dart  # History persistence

│   ├── gemini_service.dart         # DTC AI interpretationflutter pub get- Problem management with expandable details

│   ├── network_helper.dart         # Network utilities

│   └── places_service.dart         # Location services```

├── app_shell.dart       # Main navigation

├── app_state.dart       # Global state- Mechanics locator with Google Maps integration## 📋 Prerequisiti

├── main.dart            # Entry point

└── riverpod_providers.dart  # Provider configuration### 3. Configure API Keys

```

- Interactive AI chat for vehicle diagnostics

## 🏗️ Architecture

Create `.env` file in project root:

- **Clean Architecture**: Separation of concerns with feature-based structure

- **State Management**: Riverpod with ChangeNotifier for complex state- Error history tracking with timestamps- Flutter SDK >= 3.4.0

- **Dependency Injection**: Centralized providers

- **Error Handling**: Comprehensive error dialogs and recovery```env

- **Theming**: Centralized Material Design 3 dark theme

GEMINI_API_KEY=your_gemini_api_key_here- Material Design 3 implementation with dark theme- Dart SDK >= 3.4.0

## 🚀 Building APK

PLACES_API_KEY=your_google_places_api_key_here

### Automatic Build (GitHub Actions)

```- Account Google Cloud con API abilitati:

The CI/CD workflow automatically builds and releases on push to `main`:



1. **Configure GitHub Secrets** (Settings → Secrets and variables → Actions):

   - `GEMINI_API_KEY`⚠️ **Important**: `.env` is in `.gitignore` - never commit API keys!## Project Structure  - Gemini AI API

   - `PLACES_API_KEY`



2. **Push to main branch** - Build starts automatically

**Get your API keys:**  - Places API

3. **Download APK/Bundle** from Release page

- [Gemini AI](https://makersuite.google.com/app/apikey)

### Local Development

- [Google Cloud Console](https://console.cloud.google.com/)```  - Maps SDK for Android/iOS

```bash

flutter run              # Uses .env automatically

```

### 4. Run Applicationlib/

**For detailed build instructions:** See [BUILD_AUTOMATICO.md](BUILD_AUTOMATICO.md)



## 🆘 Troubleshooting

```bash├── core/## 🚀 Setup Progetto

### App crashes at startup

flutter run

**Issue**: `.env` file not found or improperly configured

```│   ├── constants/       Application constants and configuration

**Solution**:

1. Verify `.env` exists in project root

2. Ensure it contains both required keys

3. Run `flutter clean && flutter pub get`## 📁 Project Structure│   ├── models/          Data models (Dtc, etc.)### 1. Clone del repository



### Features not working (Maps, AI, Chat)



**Issue**: Invalid or missing API keys```│   ├── theme/           Theme configuration, colors



**Solution**:lib/

1. Verify keys in `.env` are correct

2. Check that APIs are enabled in Google Cloud Console├── core/│   ├── utils/           Error handling, formatters```bash

3. Ensure API quotas haven't been exceeded

│   ├── constants/       # App configuration & constants

### Build fails with dependency errors

│   ├── models/          # Data models (Dtc, etc.)│   └── widgets/         Reusable UI componentsgit clone https://github.com/rickvr123456/carsense.git

**Solution**:

```bash│   ├── theme/           # Theming & colors

flutter clean

flutter pub get│   ├── utils/           # Error handling, formatters├── features/cd carsense

flutter pub upgrade

```│   └── widgets/         # Reusable UI components



## 📚 Additional Documentation├── features/│   ├── ai/              Chat interface```



- [BUILD_AUTOMATICO.md](BUILD_AUTOMATICO.md) - Automated build guide│   ├── ai/              # Chat AI interface

- [CLEANUP_REPORT.md](CLEANUP_REPORT.md) - Code cleanup report

│   ├── dashboard/       # Main dashboard│   ├── dashboard/       Main dashboard view

## 📝 License

│   ├── history/         # Error history view

This project is private. All rights reserved.

│   ├── info/            # App information│   ├── history/         Error history view### 2. Installazione dipendenze

---

│   ├── map/             # Mechanics locator

**Last Updated**: November 2025

│   └── problems/        # DTC management│   ├── info/            Application information

├── services/

│   ├── ai_chat_service.dart        # Chat integration│   ├── map/             Mechanics locator```bash

│   ├── error_history_service.dart  # History persistence

│   ├── gemini_service.dart         # DTC AI interpretation│   └── problems/        DTC managementflutter pub get

│   ├── network_helper.dart         # Network utilities

│   └── places_service.dart         # Location services├── services/```

├── app_shell.dart       # Main navigation

├── app_state.dart       # Global state│   ├── ai_chat_service.dart        Chat API integration

├── main.dart            # Entry point

└── riverpod_providers.dart  # Provider configuration│   ├── error_history_service.dart  History persistence### 3. Configurazione API Keys

```

│   ├── gemini_service.dart         DTC interpretation

## 🏗️ Architecture

│   ├── network_helper.dart         Network utilities**⚠️ IMPORTANTE**: Non committare mai le API keys nel repository!

- **Clean Architecture**: Separation of concerns with feature-based structure

- **State Management**: Riverpod with ChangeNotifier for complex state│   └── places_service.dart         Location services

- **Dependency Injection**: Centralized providers

- **Error Handling**: Comprehensive error dialogs and recovery├── app_shell.dart          Main application shell1. Copia il file di esempio:

- **Theming**: Centralized Material Design 3 dark theme

├── app_state.dart          Global application state```bash

## 🚀 Building APK

├── main.dart               Application entry pointcp .env.example .env

### Automatic Build (GitHub Actions)

└── riverpod_providers.dart Provider configuration```

The CI/CD workflow automatically builds and releases on push to `main`:

```

1. **Configure GitHub Secrets** (Settings → Secrets and variables → Actions):

   - `GEMINI_API_KEY`2. Modifica `.env` inserendo le tue chiavi:

   - `PLACES_API_KEY`

## Setup Instructions

2. **Push to main branch** - Build starts automatically

```env

3. **Download APK/Bundle** from Release page

### PrerequisitesGEMINI_API_KEY=la_tua_chiave_gemini

### Manual Build

AI_API_KEY=la_tua_chiave_ai  # opzionale, usa GEMINI_API_KEY se non specificato

```bash

# Build APK Release- Flutter SDK 3.4.0 or higherPLACES_API_KEY=la_tua_chiave_google_places

flutter build apk --release \

  --dart-define=GEMINI_API_KEY=$YOUR_GEMINI_KEY \- Dart 3.4.0 or higher```

  --dart-define=PLACES_API_KEY=$YOUR_PLACES_KEY

- Android Studio or Xcode

# Build App Bundle (Google Play)

flutter build appbundle --release \- Git3. Verifica che `.env` sia nel `.gitignore`

  --dart-define=GEMINI_API_KEY=$YOUR_GEMINI_KEY \

  --dart-define=PLACES_API_KEY=$YOUR_PLACES_KEY

```

### Installation Steps### 4. Ottieni le API Keys

**For detailed build instructions:** See [BUILD_AUTOMATICO.md](BUILD_AUTOMATICO.md)



## 🆘 Troubleshooting

1. Clone the repository#### Gemini AI API Key

### App crashes at startup

1. Vai su [Google AI Studio](https://makersuite.google.com/app/apikey)

**Issue**: `.env` file not found or improperly configured

```bash2. Crea un nuovo API key

**Solution**:

1. Verify `.env` exists in project rootgit clone <repository-url>3. Copia e incolla in `GEMINI_API_KEY`

2. Ensure it contains both required keys

3. Run `flutter clean && flutter pub get`cd carsense



### Features not working (Maps, AI, Chat)```#### Google Places API Key



**Issue**: Invalid or missing API keys1. Vai su [Google Cloud Console](https://console.cloud.google.com/)



**Solution**:2. Install dependencies2. Crea un nuovo progetto o seleziona esistente

1. Verify keys in `.env` are correct

2. Check that APIs are enabled in Google Cloud Console3. Abilita **Places API** e **Maps SDK**

3. Ensure API quotas haven't been exceeded

```bash4. Crea credenziali (API key)

### Build fails with dependency errors

flutter pub get5. Copia e incolla in `PLACES_API_KEY`

**Solution**:

```bash```

flutter clean

flutter pub get### 5. Esegui l'app

flutter pub upgrade

```3. Configure API Keys



## 📚 Additional Documentation```bash



- [BUILD_AUTOMATICO.md](BUILD_AUTOMATICO.md) - Automated build guideVisit the following services to obtain API keys:flutter run

- [DEAD_CODE_REMOVAL_COMPLETE.md](DEAD_CODE_REMOVAL_COMPLETE.md) - Code cleanup report

```

## 📝 License

- Google AI Studio: https://makersuite.google.com/app/apikey

This project is private. All rights reserved.

- Google Cloud Console: https://console.cloud.google.com/## 📁 Struttura Progetto

---



**Last Updated**: November 2025

Create a `.env` file in the project root with:```

lib/

```├── core/

GEMINI_API_KEY=your_gemini_api_key│   ├── constants/       # Costanti app (stringhe, configurazione)

PLACES_API_KEY=your_google_places_key│   ├── models/          # Modelli dati (Dtc)

```│   ├── theme/           # Tema e colori

│   ├── utils/           # Utility (formattatori, helpers)

4. Run the application│   └── widgets/         # Widget riutilizzabili

├── features/

```bash│   ├── ai/              # Chat AI

flutter run│   ├── dashboard/       # Dashboard principale

```│   ├── history/         # Cronologia errori

│   ├── info/            # Informazioni app

## Technologies│   ├── map/             # Mappa officine

│   └── problems/        # Gestione problemi/DTC

### Core Framework├── services/

- Flutter 3.4.0 or higher│   ├── ai_chat_service.dart     # Servizio chat Gemini

- Dart 3.4.0 or higher│   ├── error_history_service.dart

│   ├── gemini_service.dart       # Servizio descrizioni DTC

### State Management│   ├── network_helper.dart

- flutter_riverpod: ^2.3.6│   └── places_service.dart

├── app_shell.dart       # Navigation shell

### API Integration├── app_state.dart       # State management

- google_generative_ai: ^0.4.7 (AI interpretation)├── main.dart            # Entry point

- google_maps_flutter: ^2.6.0 (Maps integration)└── riverpod_providers.dart

- http: ^1.2.3 (HTTP requests)```

- geolocator: ^10.1.0 (Location services)

## 🏗️ Architettura

### Data & Storage

- shared_preferences: ^2.1.1 (Local storage)Il progetto segue i principi della **Clean Architecture**:

- intl: ^0.20.2 (Localization)

- **Separation of Concerns**: Features isolate, services riutilizzabili

### Development- **State Management**: Riverpod con ChangeNotifier

- flutter_test- **Dependency Injection**: Providers centralizzati

- flutter_lints: ^4.0.0- **Immutabilità**: Modelli immutabili con `copyWith`

- **Error Handling**: Try-catch specifici, gestione network errors

## Troubleshooting- **Theming**: Sistema centralizzato colori e tema



### API Key Issues## Troubleshooting



Verify the following if features are not working:### L'app si blocca al logo Flutter

- `.env` file is present in project root

- API keys are valid and active**Causa**: Il file `.env` manca o non è configurato correttamente.

- Services are enabled in Google Cloud Console

- API quotas have not been exceeded**Soluzione**:

1. Verifica che il file `.env` esista nella root del progetto:

### Location Permissions```powershell

Test-Path .env

For map and location features:```

- Grant location permissions in device settings

- Check application permissions in Android/iOS settings2. Se manca, copialo da `.env.example`:

- Ensure location services are enabled on device```powershell

Copy-Item .env.example .env

### Build Problems```



Clean and rebuild:3. Modifica `.env` con le tue chiavi API reali.



```bash4. Assicurati che `.env` sia dichiarato negli assets in `pubspec.yaml`:

flutter clean```yaml

flutter pub getflutter:

flutter run  assets:

```    - .env

```

For web deployment:

5. Esegui un clean e rebuild:

```bash```powershell

flutter run -d web-chromeflutter clean

```flutter pub get

flutter run

---```



Last Updated: November 2025### Errore di connessione API


Se l'app si avvia ma le funzionalità AI/Maps non funzionano, verifica che le chiavi in `.env` siano valide e abilitate per i servizi corretti (Gemini API, Google Maps Platform).

