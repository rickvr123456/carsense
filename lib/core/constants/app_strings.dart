/// UI-related string constants
class AppStrings {
  AppStrings._();

  // Navigation
  static const String navDashboard = 'Dashboard';
  static const String navProblems = 'Problemi';
  static const String navAi = 'AI';
  static const String navMap = 'Mappa';
  static const String navHistory = 'Cronologia';

  // Dashboard
  static const String connect = 'Connetti e scansiona';
  static const String scan = 'Scansiona';
  static const String connected = 'CONNESSO';
  static const String disconnected = 'NON CONNESSO';
  static const String noErrorsDetected = 'Nessun errore rilevato';
  static String errorsDetected(int count) => '$count errori rilevati';

  // Errors
  static const String noInternet = 'Nessuna connessione a Internet';
  static const String aiError = 'Errore nella comunicazione con l\'AI';
  static const String genericError = 'Si è verificato un errore. Riprova.';
  static const String loadingMapError = 'Errore caricamento mappa';
  static const String locationPermissionDenied = 'Permesso posizione negato';
  static const String locationServiceDisabled = 'Servizi di localizzazione disabilitati';

  // AI Chat
  static const String aiSupport = 'Supporto IA';
  static const String newConversation = 'Nuova conversazione';
  static const String askAnything = 'Chiedi qualsiasi cosa…';
  static const String send = 'Invia';
  static const String typing = 'Sta scrivendo...';
  static const String askAi = 'Chiedi all\'IA';

  // Problems
  static const String deleteErrors = 'Cancella errori';
  static const String deleteSelected = 'Cancella selezionati';
  static const String confirmDelete = 'Conferma cancellazione';
  static String confirmDeleteMessage(int count) => 
      'Sei sicuro di voler cancellare $count errore(i)?';
  static const String yes = 'Sì';
  static const String no = 'No';
  static const String loadingDescription = 'Descrizione in caricamento…';

  // History
  static const String errorHistory = 'Cronologia Errori';
  static const String clearAllHistory = 'Cancella tutta la cronologia';
  static const String confirmClearHistory = 'Sei sicuro di voler cancellare tutti i record?';
  static const String noErrorsRecorded = 'Nessun errore registrato';

  // Map
  static const String nearbyMechanics = 'Meccanici vicino a te';
  static const String reloadMechanics = 'Ricarica officine';
  static const String myLocation = 'La mia posizione';

  // Info
  static const String info = 'Informazioni';
  static const String infoDescription1 = 
      'CarSense è un\'applicazione pensata per tutti gli appassionati di motori che intendono approcciarsi al mondo della meccanica in maniera semplice ma non superficiale.';
  static const String infoDescription2 = 
      'Attraverso la scansione della centralina tramite presa OBD2, CarHealth restituirà una panoramica completa di tutti gli errori riportati dalla centralina della propria autovettura, con una spiegazione dettagliata dell\'errore, delle probabili cause e delle possibili soluzioni.';
  static const String infoDescription3 = 
      'Inoltre, è integrata un\'intelligenza artificiale che aiuta l\'utente nella comprensione del problema, e che è in grado di rispondere alle richieste dell\'utente riguardo eventuali dubbi sul proprio veicolo';
}
