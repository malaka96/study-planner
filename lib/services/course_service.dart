import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_planner/Models/course.dart';

class CourseService {
  final CollectionReference courseCollection = FirebaseFirestore.instance
      .collection("courses");

  Future<void> addCourse(Course course) async {
    try {
      final Map<String, dynamic> data = course.toJson();

      final DocumentReference docRef = await courseCollection.add(data);
      await docRef.update({'id': docRef.id});
    } catch (error) {
      print('error adding course $error');
    }
  }

  Stream<List<Course>> get courses {
    try {
      return courseCollection.snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => Course.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (error) {
      print('error get courses $error');
      return Stream.empty();
    }
  }

}
