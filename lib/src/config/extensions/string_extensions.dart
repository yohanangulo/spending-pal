extension StringExtensions on String {
  String? get sanitized {
    if (isEmpty || trim().isEmpty) return null;

    return trim();
  }
}
