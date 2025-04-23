extension ListUtils<T> on List<T> {
  bool get isNullOrEmpty => this == null || this.isEmpty;
  T? get safeFirst => this.isEmpty ? null : this.first;
}
