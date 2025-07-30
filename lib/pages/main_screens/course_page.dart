import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:study_planner/Models/assignment.dart';
import 'package:study_planner/Models/course.dart';
import 'package:study_planner/Models/note.dart';
import 'package:study_planner/constants/constant.dart';
import 'package:study_planner/services/assignment_service.dart';
import 'package:study_planner/services/course_service.dart';
import 'package:study_planner/services/note_service.dart';
import 'package:study_planner/utils/util_fuctions.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  Future<Map<String, dynamic>> _fetchData() async {
    try {
      final courses = await CourseService().getCourses();
      final assignmentsMap = await AssignmentService()
          .getAssignmentsWithCourseName();
      final notesMap = await NoteService().getNotesWithCourseName();

      return {
        'courses': courses,
        'assignments': assignmentsMap,
        'notes': notesMap,
      };
    } catch (error) {
      print('Error fetching data: $error');
      return {'courses': [], 'assignments': {}, 'notes': {}};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Courses',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data available.'));
          }

          final courses = snapshot.data!['courses'] as List<Course>? ?? [];
          final assignmentsMap =
              snapshot.data!['assignments'] as Map<String, List<Assignment>>? ??
              {};

          final notesMap =
              snapshot.data!['notes'] as Map<String, List<Note>>? ?? {};

          return ListView.builder(
            padding: EdgeInsets.all(15),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              final courseAssignments = assignmentsMap[course.name] ?? [];
              final courseNotes = notesMap[course.name] ?? [];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Description: ${course.description}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white60,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Duration: ${course.duration}',
                      style: TextStyle(fontSize: 14, color: lightGreen),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Schedule: ${course.schedule}',
                      style: TextStyle(fontSize: 14, color: lightGreen),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Instructor: ${course.instructor}',
                      style: TextStyle(fontSize: 14, color: lightGreen),
                    ),
                    const SizedBox(height: 20),
                    if (courseAssignments.isNotEmpty) ...[
                      Text(
                        'Assignments',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: courseAssignments.map((assignment) {
                          return GestureDetector(
                            onLongPress: () {
                              showDialogBox(
                                context: context,
                                title: 'Delete Assigment',
                                text: 'Are you sure?',
                                buttonText: 'Delete',
                                onConfirm: () async {
                                  await AssignmentService().deleteAssignment(course.id, assignment.id);
                                },
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 5),
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: ListTile(
                                title: Text(
                                  assignment.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'Due Date: ${DateFormat.yMMMd().format(assignment.dueDate)}',
                                ),
                                onTap: () => GoRouter.of(
                                  context,
                                ).push("/single-assignment", extra: assignment),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    if (courseNotes.isNotEmpty) ...[
                      Text(
                        'Notes',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: courseNotes.map((note) {
                          return GestureDetector(
                             onLongPress: () {
                              showDialogBox(
                                context: context,
                                title: 'Delete Note',
                                text: 'Are you sure?',
                                buttonText: 'Delete',
                                onConfirm: () async {
                                  await NoteService().deleteNote(course.id, note.id);
                                },
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 5),
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: ListTile(
                                title: Text(
                                  note.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text('Section: ${note.section}'),
                                onTap: () => GoRouter.of(
                                  context,
                                ).push("/single-note", extra: note),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
