import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_planner/Models/assignment.dart';

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
}
