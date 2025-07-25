import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study_planner/Models/assignment.dart';
import 'package:study_planner/Models/course.dart';
import 'package:study_planner/pages/widgets/custom_button.dart';
import 'package:study_planner/pages/widgets/user_input.dart';
import 'package:study_planner/services/assignment_service.dart';
import 'package:study_planner/utils/util_fuctions.dart';

class AddNewNotePage extends StatelessWidget {
  final Course course;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _assignmentNameController =
      TextEditingController();
  final TextEditingController _assignmentDescriptionController =
      TextEditingController();
  final TextEditingController _assignmentDurationController =
      TextEditingController();

  final ValueNotifier<DateTime> _selectedDate = ValueNotifier<DateTime>(
    DateTime.now(),
  );
  final ValueNotifier<TimeOfDay> _selectedTime = ValueNotifier<TimeOfDay>(
    TimeOfDay.now(),
  );

  AddNewNotePage({super.key, required this.course}) {
    // Initialize ValueNotifiers with current date and time
    _selectedDate.value = DateTime.now();
    _selectedTime.value = TimeOfDay.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    print('select date is called');
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2026),
      initialDate: _selectedDate.value,
    );

    if (picked != null && picked != _selectedDate.value) {
      _selectedDate.value = picked;
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime.value,
    );

    if (picked != null && picked != _selectedTime.value) {
      _selectedTime.value = picked;
    }
  }

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      try {
        Assignment assignment = Assignment(
          id: "",
          name: _assignmentNameController.text,
          description: _assignmentDescriptionController.text,
          duration: _assignmentDurationController.text,
          dueDate: _selectedDate.value,
          dueTime: _selectedTime.value,
        );

        AssignmentService().createAssignment(course.id, assignment);
        showSnackBars(context: context, text: "Assingment added successfully");
        await Future.delayed(Duration(seconds: 2));

        GoRouter.of(context).go("/");
      } catch (error) {
        showSnackBars(context: context, text: "Failed to add assignment");
        print(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add New Assignment',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Fill in the details below to add a new assignment. And start managing your study planner.',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 20),
                UserInput(
                  controller: _assignmentNameController,
                  labelText: "Assignment Name",
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter the assignment name';
                    }
                    return null;
                  },
                ),
                UserInput(
                  controller: _assignmentDescriptionController,
                  labelText: "Assignment Description",
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter the assignment description';
                    }
                    return null;
                  },
                ),
                UserInput(
                  controller: _assignmentDurationController,
                  labelText: 'Duration (e.g., 1 hour)',
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter the assignment duration';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Divider(),
                const Text(
                  'Due Date and Time',
                  style: TextStyle(fontSize: 16, color: Colors.white60),
                ),
                ValueListenableBuilder<DateTime>(
                  valueListenable: _selectedDate,
                  builder: (context, date, child) {
                    return Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Date: ${date.toLocal().toString().split(' ')[0]}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
                        ),
                      ],
                    );
                  },
                ),
                ValueListenableBuilder<TimeOfDay>(
                  valueListenable: _selectedTime,
                  builder: (context, time, child) {
                    return Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Time: ${time.format(context)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.access_time),
                          onPressed: () => _selectTime(context),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Add Assignment',
                  onPressed: () => _submitForm(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
