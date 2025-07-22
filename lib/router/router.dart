import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study_planner/Models/course.dart';
import 'package:study_planner/pages/add_new_assignment_page.dart';
import 'package:study_planner/pages/add_new_course_page.dart';
import 'package:study_planner/pages/add_new_note_page.dart';
import 'package:study_planner/pages/homepage.dart';
import 'package:study_planner/pages/single_course_page.dart';

class RouterClass {
  final router = GoRouter(
    initialLocation: "/",
    errorPageBuilder: (context, state) {
      return MaterialPage(
        child: Scaffold(
          body: Center(child: Text("this page is not avaliable")),
        ),
      );
    },
    routes: [
      //home page
      GoRoute(path: "/", name: "home", builder: (context, state) => Homepage()),

      // add new course
      GoRoute(
        path: "/add-course",
        name: "add course",
        builder: (context, state) => AddNewCoursePage(),
      ),

      GoRoute(
        path: "/single-course",
        name: "single course",
        builder: (context, state) {
          final Course course = state.extra as Course;
          return(
            SingleCoursePage(course: course,)
          );
        },
      ),

      GoRoute(
        path: "/add-new-assignment",
        name: "add new assignment",
        builder: (context, state) {
          final Course course = state.extra as Course;
          return(
            AddNewNotePage(course: course,)
            
          );
        },
      ),

      GoRoute(
        path: "/add-new-note",
        name: "add new note",
        builder: (context, state) {
          final Course course = state.extra as Course;
          return(
            AddNewAssignmentPage(course: course,)
          );
        },
      ),
    ],
  );
}
