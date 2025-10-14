class Dtc {
  final String code;
  String? description; // mutabile per aggiornamento da AI
  String? detail; // opzionale per testo più lungo

  Dtc(this.code, {this.description, this.detail});
}
