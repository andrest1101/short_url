class InvalidUrlException implements Exception {
  final String input;

  const InvalidUrlException(this.input);

  @override
  String toString() => 'InvalidUrlException: "$input" bukan URL yang valid';
}
