import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study_planner/constants/constant.dart';
import 'package:study_planner/services/course_service.dart';
import 'package:study_planner/utils/util_fuctions.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Study Planner',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        GoRouter.of(context).push('/add-course');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: EdgeInsets.all(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.add, color: Colors.white),
                          Text(
                            'Add Course',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  'Your study planner helps you to keep track of your study progress and manage your time effectively.',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 20),
                // StreamBuilder to show list of courses
                const Text(
                  'Courses',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Your running subjects',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 10),
                StreamBuilder(
                  stream: CourseService().courses,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error ${snapshot.error}'));
                    } else if (!snapshot.hasData && snapshot.data!.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height / 5,
                          ),
                          child: Column(
                            children: [
                              Image.asset('assets/course.png', width: 200),
                              const SizedBox(height: 10),
                              const Text(
                                'No courses available.Feel free to add a course!',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      final courses = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: courses.length,
                        itemBuilder: (context, index) {
                          final course = courses[index];

                          return GestureDetector(
                            onLongPress: () {
                              showDialogBox(
                                context: context,
                                title: 'Delete Course',
                                text: 'Are you sure?',
                                buttonText: 'Delete',
                                onConfirm: () async {
                                  await CourseService().deleteCourse(course.id);
                                },
                              );
                            },
                            child: Card(
                              elevation: 0,
                              color: lightGreen,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: ListTile(
                                  title: Text(
                                    course.name,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                  subtitle: Text(
                                    course.description,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 12,
                                    ),
                                  ),
                                  onTap: () {
                                    GoRouter.of(
                                      context,
                                    ).push("/single-course", extra: course);
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
