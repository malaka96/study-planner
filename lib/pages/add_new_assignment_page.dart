import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study_planner/Models/course.dart';
import 'package:study_planner/Models/note.dart';
import 'package:study_planner/pages/widgets/custom_button.dart';
import 'package:study_planner/pages/widgets/user_input.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_planner/services/note_service.dart';
import 'package:study_planner/utils/util_fuctions.dart';

class AddNewAssignmentPage extends StatefulWidget {
  final Course course;

  const AddNewAssignmentPage({super.key, required this.course});

  @override
  State<AddNewAssignmentPage> createState() => _AddNewAssignmentPageState();
}

class _AddNewAssignmentPageState extends State<AddNewAssignmentPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _sectionController = TextEditingController();

  final TextEditingController _referenceController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  XFile? _selectedImage;

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _selectedImage = image;
    });
  }

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      try {
        Note note = Note(
          id: "",
          title: _titleController.text,
          description: _descriptionController.text,
          section: _sectionController.text,
          reference: _referenceController.text,
        );

        NoteService().createNote(widget.course.id, note);
        showSnackBars(context: context, text: 'successfully added note');
        await Future.delayed(Duration(seconds: 2));

        GoRouter.of(context).go("/");
      } catch (error) {
        showSnackBars(context: context, text: 'failed adding note');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Note For Your Course',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),

              //description
              const Text(
                'Fill in the details below to add a new note. And start managing your study planner.',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserInput(
                      controller: _titleController,
                      labelText: 'Note title',
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter note title';
                        }
                        return null;
                      },
                    ),
                    UserInput(
                      controller: _descriptionController,
                      labelText: 'Note Description',
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter note description';
                        }
                        return null;
                      },
                    ),
                    UserInput(
                      controller: _sectionController,
                      labelText: 'Note section',
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter note section';
                        }
                        return null;
                      },
                    ),
                    UserInput(
                      controller: _referenceController,
                      labelText: 'Note reference',
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter note reference';
                        }
                        return null;
                      },
                    ),
                    const Divider(),
                    const Text(
                      'Upload Note Image , for better understanding and quick revision',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: 'Upload Note Image',
                      onPressed: _pickImage,
                    ),
                    const SizedBox(height: 20),
                    _selectedImage != null
                        ? Column(
                            children: [
                              const Text(
                                'Selected Image:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ClipRect(
                                child: Image.file(
                                  File(_selectedImage!.path),
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            'No image selected.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: 'Submit Note',
                      onPressed: () => _submitForm(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
