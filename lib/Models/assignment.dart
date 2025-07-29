import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Assignment {
  final String id;
  final String name;
  final String description;
  final String duration;
  final DateTime dueDate;
  final TimeOfDay dueTime;

  Assignment({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.dueDate,
    required this.dueTime,
  });

factory Assignment.fromJson(Map<String, dynamic> data) {
  final Timestamp defaultTimestamp = Timestamp.fromDate(DateTime.now());

  return Assignment(
    id: data['id'] ?? '',
    name: data['name'] ?? '',
    description: data['description'] ?? '',
    duration: data['duration'] ?? '',
    dueDate: (data['dueDate'] ?? defaultTimestamp).toDate(),
    dueTime: TimeOfDay.fromDateTime(
      (data['dueTime'] ?? defaultTimestamp).toDate(),
    ),
  );
}

   Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'duration': duration,
      'dueDate': Timestamp.fromDate(dueDate),
      'dueTime': Timestamp.fromDate(DateTime(
        dueDate.year,
        dueDate.month,
        dueDate.day,
        dueTime.hour,
        dueTime.minute,
      )),
    };
  }

}

