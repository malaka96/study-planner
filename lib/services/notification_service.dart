import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_planner/Models/notification_model.dart';
import 'package:study_planner/services/assignment_service.dart';

class NotificationService {
  final CollectionReference notificationCollection = FirebaseFirestore.instance
      .collection("notifications");

  Future<void> storeOverdueAssignments() async {
    try {
      final assignmentsMap = await AssignmentService()
          .getAssignmentsWithCourseName();

      for (final entry in assignmentsMap.entries) {
        final courseName = entry.key;
        final assingments = entry.value;

        for (final assignment in assingments) {
          final QuerySnapshot snapshot = await notificationCollection
              .where('assignmentId', isEqualTo: assignment.id)
              .get();

          if (snapshot.docs.isEmpty) {
            if (DateTime.now().isAfter(assignment.dueDate)) {
              final NotificationModel notification = NotificationModel(
                assignmentId: assignment.id,
                assignmentName: assignment.name,
                courseName: courseName,
                description: assignment.description,
                dueDate: assignment.dueDate,
                timePassed: "Overdue",
              );

              await notificationCollection.add(notification.toJson());
            }
          }
        }
      }
    } catch (error) {
      print(error);
    }
  }

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final QuerySnapshot snapshot = await notificationCollection.get();
      return snapshot.docs
          .map(
            (doc) =>
                NotificationModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<void> deleteNotification(String assigmentId) async {
    try {
      final QuerySnapshot snapshot = await notificationCollection
          .where('assignmentId', isEqualTo: assigmentId)
          .get();

      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (error) {
      print(error);
    }
  }
}
