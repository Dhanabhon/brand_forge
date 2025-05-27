class BrandForgeException implements Exception {
  final String message;
  final String? solution;

  const BrandForgeException(this.message, [this.solution]);

  @override
  String toString() {
    if (solution != null) {
      return '$message\nSolution: $solution';
    }
    return message;
  }
}
