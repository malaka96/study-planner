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

  Stream<List<Note>> getNotes(String courseId) {
    try {
      final CollectionReference notesCollection = courseCollection
          .doc(courseId)
          .collection('note');
      return notesCollection.snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => Note.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (error) {
      print(error);
      return Stream.empty();
    }
  }

  Future<Map<String, List<Note>>> getNotesWithCourseName() async {
    try {
      final QuerySnapshot snapshot = await courseCollection.get();
      final Map<String, List<Note>> notesMap = {};

      for (final doc in snapshot.docs) {
        final String courseId = doc.id;
        final List<Note> notes = await getNotes(courseId).first;
        notesMap[doc['name']] = notes;
      }

      return notesMap;
    } catch (error) {
      print(error);
      return {};
    }
  }

  Future<void> deleteNote(String courseId, String id) async {
    try {
      final CollectionReference notesCollection = courseCollection
          .doc(courseId)
          .collection('note');

      await notesCollection.doc(id).delete();
    } catch (error) {
      print(error);
    }
  }

  Future<void> deleteNoteReference(String courseId) async {
    try {
      final CollectionReference notesCollection = courseCollection
          .doc(courseId)
          .collection('note');
      final QuerySnapshot snapshot = await notesCollection.get();
      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (error) {
      print(error);
    }
  }
}
