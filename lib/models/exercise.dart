class Exercise {
  final String name;
  final String id;

  Exercise({required this.id, required this.name});

  bool equals(Exercise other) {
    return this.name == other.name;
  }

  void log() {
      print("EXERCISE >> ID: " + this.id + ", name: " + this.name);
  }
}
