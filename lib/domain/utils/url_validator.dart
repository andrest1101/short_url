class UrlValidator {
  static final RegExp _httpSchemeRegExp = RegExp(
    r'^https?:\/\/',
    caseSensitive: false,
  );
  static final RegExp _wwwRegExp = RegExp(
    r'^www\.',
    caseSensitive: false,
  );

  const UrlValidator();

  String? normalize(String input) {
    final String trimmed = input.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    String candidate = trimmed;
    if (!_httpSchemeRegExp.hasMatch(candidate)) {
      if (_wwwRegExp.hasMatch(candidate)) {
        candidate = 'https://$candidate';
      } else {
        return null;
      }
    }
    final Uri? uri = Uri.tryParse(candidate);
    if (uri == null ||
        (uri.scheme.toLowerCase() != 'http' &&
            uri.scheme.toLowerCase() != 'https') ||
        uri.host.isEmpty ||
        !uri.host.contains('.')) {
      return null;
    }
    return candidate;
  }
}
