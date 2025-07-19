import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study_planner/pages/add_new_course_page.dart';
import 'package:study_planner/pages/homepage.dart';

class RouterClass {
  final router = GoRouter(
    initialLocation: "/",
    errorPageBuilder: (context, state) {
      return MaterialPage(
        child: Scaffold(
          body: Center(
            child: Text("this page is not avaliable"),
          ),
        )
      );
    },
    routes: [
      //home page
      GoRoute(
        path: "/",
        name: "home",
        builder: (context, state) => Homepage(),
      ),

      // add new course
      GoRoute(
        path: "/add-course",
        name: "add course",
        builder: (context, state) => AddNewCoursePage(),
      ),
    ],
  );
}
