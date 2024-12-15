import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddCollaborativeGoalPage extends StatefulWidget {
  const AddCollaborativeGoalPage({super.key});

  @override
  _AddCollaborativeGoalPageState createState() => _AddCollaborativeGoalPageState();
}

class _AddCollaborativeGoalPageState extends State<AddCollaborativeGoalPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  List<String> _selectedCollaborators = [];

  void _selectDate(BuildContext context, bool isStart) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != (isStart ? _startDate : _endDate)) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _openCollaboratorDialog() async {
    List<String> tempSelectedCollaborators = List.from(_selectedCollaborators);
    TextEditingController emailController = TextEditingController();
    String emailError = "";

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: const Text("Add Collaborators"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Enter Collaborator Email",
                      errorText: emailError.isNotEmpty ? emailError : null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      String email = emailController.text.trim();
                      if (email.isEmpty) {
                        setDialogState(() {
                          emailError = "Please enter an email address.";
                        });
                      // } else if (!isValidEmail(email)) {
                      //   setDialogState(() {
                      //     emailError = "Invalid email format.";
                      //   });
                      } else {
                        setDialogState(() {
                          if (!tempSelectedCollaborators.contains(email)) {
                            tempSelectedCollaborators.add(email);
                            emailController.clear();
                            emailError = "";
                          } else {
                            emailError = "Email already added.";
                          }
                        });
                      }
                    },
                    child: const Text("Add Email"),
                  ),
                  const Divider(),
                  Wrap(
                    spacing: 8.0,
                    children: tempSelectedCollaborators.map((email) {
                      return Chip(
                        label: Text(email),
                        onDeleted: () {
                          setDialogState(() {
                            tempSelectedCollaborators.remove(email);
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedCollaborators = tempSelectedCollaborators;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // bool isValidEmail(String email) {
  //   final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\$');
  //   return regex.hasMatch(email);
  // }

  Future<void> saveGoal() async {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _startDate != null &&
        _endDate != null) {
      try {
        await FirebaseFirestore.instance.collection('collaborativeGoals').add({
          'name': _titleController.text,
          'description': _descriptionController.text,
          'createdAt': _startDate,
          //'end_date': _endDate,
          'createdBy': FirebaseAuth.instance.currentUser?.uid,
          'collaborators': _selectedCollaborators,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Goal added successfully!")),
        );

        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add goal: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all the fields.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Collaborative Goal"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Goal Title"),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text("Start Date: "),
                  TextButton(
                    onPressed: () => _selectDate(context, true),
                    child: Text(
                      _startDate == null
                          ? "Select Start Date"
                          : _startDate!.toString().split(" ")[0],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text("End Date: "),
                  TextButton(
                    onPressed: () => _selectDate(context, false),
                    child: Text(
                      _endDate == null
                          ? "Select End Date"
                          : _endDate!.toString().split(" ")[0],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _openCollaboratorDialog,
                child: Text("Add Collaborators (${_selectedCollaborators.length})"),
              ),
              Wrap(
                children: _selectedCollaborators.map((collaborator) {
                  return Chip(label: Text(collaborator));
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveGoal,
                child: const Text("Save Goal"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
