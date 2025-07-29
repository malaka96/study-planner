import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:study_planner/Models/assignment.dart';
import 'package:study_planner/constants/constant.dart';
import 'package:study_planner/pages/widgets/count_down_timer.dart';
import 'package:study_planner/services/assignment_service.dart';
import 'package:study_planner/services/notification_service.dart';

class AssignmentPage extends StatelessWidget {
  const AssignmentPage({super.key});

  Future<Map<String, List<Assignment>>> _fetchAssignments() async {
    return await AssignmentService().getAssignmentsWithCourseName();
  }

  Future<void> _checkAndStoreOverdueAssignments() async {
    await NotificationService().storeOverdueAssignments();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndStoreOverdueAssignments();
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Assignments',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              GoRouter.of(context).push("/notification");
            },
            icon: Icon(Icons.notifications),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _fetchAssignments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No assignments available.'));
          }

          final assignmentMap = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.all(15),
            itemCount: assignmentMap.keys.length,
            itemBuilder: (context, index) {
              final courseName = assignmentMap.keys.elementAt(index);
              final assignments = assignmentMap[courseName]!;

              return ExpansionTile(
                title: Text(
                  courseName,
                  style: TextStyle(fontSize: 18, color: darkGreen),
                ),
                children: assignments.map((assignment) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    title: Text(
                      assignment.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Due Date: ${DateFormat.yMMMd().format(assignment.dueDate)},',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white38,
                          ),
                        ),
                        Text(
                          'Description: ${assignment.description}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white38,
                          ),
                        ),
                        CountDownTimer(dueDate: assignment.dueDate),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
