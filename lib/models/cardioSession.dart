import 'package:flutter/material.dart';

class CardioSession {
  String id = UniqueKey().toString();
  int timestamp = DateTime.now().millisecondsSinceEpoch;
  Duration? duration = Duration();
  double distanceInMetres = 0;

  CardioSession({this.duration, this.distanceInMetres = 0}) {
    if (this.duration == null) this.duration = Duration();
  }

  static CardioSession from(CardioSession from) {
    CardioSession session = CardioSession(
        duration: from.duration, distanceInMetres: from.distanceInMetres);
    session.id = from.id;
    session.timestamp = from.timestamp;
    return session;
  }

  bool equals(CardioSession other) {
    return id == other.id &&
        timestamp == other.timestamp &&
        duration == other.duration &&
        distanceInMetres == other.distanceInMetres;
  }

  static CardioSession fromJson(Map<String, dynamic> json) {
    CardioSession session = CardioSession();
    session.id = json['id'];
    session.duration = Duration(seconds: json['durationInSeconds']! as int);
    session.distanceInMetres = json['distanceInMetres']! as double;
    session.timestamp = json['timestamp']! as int;
    return session;
  }

  String getDurationString() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration!.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration!.inSeconds.remainder(60));
    return "${twoDigits(duration!.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String getDistanceString() {
    if (distanceInMetres >= 1000)
      return '${(distanceInMetres / 1000).toStringAsFixed(1)} km';
    return '${distanceInMetres.round()} m';
  }

  double volume() {
    return distanceInMetres;
  }

  Map<String, Object> toJson() {
    return {
      'durationInSeconds': duration!.inSeconds,
      'distanceInMetres': distanceInMetres,
      'timestamp': timestamp,
      'id': id,
    };
  }

  void log() {
    print(
        "CARDIO SESSION >> duration: ${getDurationString()}, distance: ${this.distanceInMetres.toString()}");
  }
}
