# CarSense

CarSense è un'applicazione Android per la diagnostica automotive. Legge i codici di errore OBD-II dai veicoli, li interpreta utilizzando intelligenza artificiale con anche la possibilità di interazione e ti aiuta a trovare meccanici nelle vicinanze.

## A cosa serve

L'app ti permette di:
- Visualizzare i dati in tempo reale del tuo veicolo (RPM, velocità, temperatura, batteria)
- Leggere e interpretare i codici di errore OBD-II con l'aiuto dell'IA
- Chattare con un assistente AI per chiarimenti sulla diagnostica
- Trovare officine e meccanici vicini a te con Google Maps
- Consultare la cronologia degli errori rilevati

## Come usarla

### Setup locale

1. Clona il repository:
```bash
git clone https://github.com/rickvr123456/carsense.git
cd carsense
```

2. Installa le dipendenze:
```bash
flutter pub get
```

3. Crea un file `.env` nella cartella radice (come il `.env.example`):
```env
GEMINI_API_KEY=la_tua_chiave_gemini
PLACES_API_KEY=la_tua_chiave_google_maps
```

4. Avvia l'app:
```bash
flutter run
```

### Come ottenere le API Key

**Gemini API Key:**
- Vai su https://makersuite.google.com/app/apikey
- Clicca "Create API Key"
- Copia la chiave nel file .env

**Google Maps API Key:**
- Vai su https://console.cloud.google.com/
- Crea un nuovo progetto
- Abilita "Places API" e "Maps SDK"
- Crea una credenziale di tipo "API Key"
- Copia la chiave nel file .env

## Sezioni dell'app

- **Dashboard**: Metriche in tempo reale del veicolo e scansione per errori della centralina
- **Problemi**: Sfoglia e leggi i codici di errore OBD-II
- **AI**: Conversazione con l'assistente per la diagnostica
- **Mappa**: Localizzazione di officine e meccanici
- **Cronologia**: Registro di tutti gli errori rilevati

## Requisiti

- Flutter SDK 3.4.0 o superiore
- Android SDK minimo API 21
- Due API Key da Google Cloud: Gemini API e Google Maps API
