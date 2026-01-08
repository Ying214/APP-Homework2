import 'package:flutter/material.dart';

enum EventType { schedule, task }

class Event {
  final String title;
  final DateTime date;
  final EventType type;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;

  bool isDone;

  Event({
    required this.title,
    required this.date,
    required this.type,
    this.startTime,
    this.endTime,
    this.isDone = false,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'date': date.toIso8601String(),
    'type': type.index,
    'startHour': startTime?.hour,
    'startMinute': startTime?.minute,
    'endHour': endTime?.hour,
    'endMinute': endTime?.minute,
    'isDone': isDone,
  };

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'],
      date: DateTime.parse(json['date']),
      type: EventType.values[json['type']],
      startTime: json['startHour'] != null
          ? TimeOfDay(hour: json['startHour'], minute: json['startMinute'])
          : null,
      endTime: json['endHour'] != null
          ? TimeOfDay(hour: json['endHour'], minute: json['endMinute'])
          : null,
      isDone: json['isDone'] ?? false,
    );
  }
}

DateTime dateKey(DateTime date) => DateTime(date.year, date.month, date.day);
