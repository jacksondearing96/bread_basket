class PerformedSet {
  int reps = 0;
  final String id;

  PerformedSet({ required this.id, required this.reps});

  void log() {
    print("PERFORMED SET >> Set ID: " +
        this.id +
        ", reps: " +
        this.reps.toString());
  }
}
