class Dtc {
  const Dtc(
    this.code, {
    this.title,
    this.description,
    this.detail,
  });

  final String code;
  final String? title;
  final String? description;
  final String? detail;

  Dtc copyWith({
    String? code,
    String? title,
    String? description,
    String? detail,
  }) {
    return Dtc(
      code ?? this.code,
      title: title ?? this.title,
      description: description ?? this.description,
      detail: detail ?? this.detail,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Dtc && runtimeType == other.runtimeType && code == other.code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => 'Dtc(code: $code, title: $title)';
}
