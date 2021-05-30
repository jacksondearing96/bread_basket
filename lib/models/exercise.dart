class Exercise {
  final String name;

  Exercise({required this.name});

  bool equals(Exercise other) {
    return this.name == other.name;
  }
}
