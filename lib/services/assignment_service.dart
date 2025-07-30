import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_planner/Models/assignment.dart';
import 'package:study_planner/services/notification_service.dart';

class AssignmentService {
  final CollectionReference courseCollection = FirebaseFirestore.instance
      .collection("courses");

  Future<void> createAssignment(String courseId, Assignment assignment) async {
    try {
      final Map<String, dynamic> data = assignment.toJson();
      final CollectionReference assignmentCollection = FirebaseFirestore
          .instance
          .collection("courses")
          .doc(courseId)
          .collection("assignments");

      DocumentReference docRef = await assignmentCollection.add(data);
      await docRef.update({'id': docRef.id});

      print('assignment saved');
    } catch (error) {
      print(error);
    }
  }

  Stream<List<Assignment>> getAssigments(String courseId) {
    try {
      final CollectionReference assignmentCollection = courseCollection
          .doc(courseId)
          .collection('assignments');

      return assignmentCollection.snapshots().map((snapshot) {
        return snapshot.docs
            .map(
              (doc) => Assignment.fromJson(doc.data() as Map<String, dynamic>),
            )
            .toList();
      });
    } catch (error) {
      print(error);
      return Stream.empty();
    }
  }

  Future<Map<String, List<Assignment>>> getAssignmentsWithCourseName() async {
    try {
      final QuerySnapshot snapshot = await courseCollection.get();
      final Map assignmentsMap = <String, List<Assignment>>{};
      for (final doc in snapshot.docs) {
        final String courseId = doc.id;
        final List<Assignment> assignments = await getAssigments(
          courseId,
        ).first;

        assignmentsMap[doc['name']] = assignments;
        print('yello world');
      }

      return assignmentsMap as Map<String, List<Assignment>>;
    } catch (error) {
      print(error);
      return {};
    }
  }

  Future<void> deleteAssignment(String courseId, String id) async {
    try {
      final CollectionReference assignmentCollection = courseCollection
          .doc(courseId)
          .collection('assignments');
      await assignmentCollection.doc(id).delete();
    } catch (error) {
      print(error);
    }
  }

  Future<void> deleteAssigmentReference(String courseId) async {
    try {
      final CollectionReference assignmentCollection = courseCollection
          .doc(courseId)
          .collection('assignments');
      final QuerySnapshot snapshot = await assignmentCollection.get();
      for (final doc in snapshot.docs) {
        NotificationService().deleteNotification(doc.id);
        await doc.reference.delete();
      }
    } catch (error) {
      print(error);
    }
  }
}
