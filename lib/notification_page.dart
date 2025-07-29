import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:study_planner/Models/notification_model.dart';
import 'package:study_planner/constants/constant.dart';
import 'package:study_planner/services/notification_service.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  Future<List<NotificationModel>> _fetchNotifications() async {
    return await NotificationService().getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: _fetchNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No assignments available.'));
          }
          final notifications = snapshot.data!;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];

              return ListTile(
                title: Text(
                  notification.assignmentName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Course: ${notification.courseName}',
                          style: const TextStyle(color: Colors.black),
                        ),
                        Text(
                          'Assignment: ${notification.assignmentName}',
                          style: const TextStyle(color: Colors.black),
                        ),
                        Text(
                          'Due Date: ${DateFormat.yMMMd().format(notification.dueDate)}',
                          style: const TextStyle(color: Colors.black),
                        ),
                        Text(
                          'Time: ${(notification.dueDate.difference(DateTime.now()).inHours).toString()} hours',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
