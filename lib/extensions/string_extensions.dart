extension StringExtensions on String {
  bool get isValidEmail {
    return RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}\$').hasMatch(this);
  }

  String capitalize() {
    if (this.isEmpty) return '';
    return this[0].toUpperCase() + substring(1);
  }
}
