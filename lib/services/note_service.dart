import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_planner/Models/note.dart';

class NoteService {
  final CollectionReference courseCollection = FirebaseFirestore.instance
      .collection("courses");

  Future<void> createNote(String courseId, Note note) async {
    try {
      final Map<String, dynamic> data = note.toJson();
      final CollectionReference noteReference = FirebaseFirestore.instance
          .collection("courses")
          .doc(courseId)
          .collection("note");

      DocumentReference docRef = await noteReference.add(data);
      await docRef.update({'id': docRef.id});
      print('successfully added note');
    } catch (error) {
      print(error);
    }
  }
}
