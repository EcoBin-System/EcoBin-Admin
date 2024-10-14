import 'package:flutter/material.dart';
import 'package:ecobin_admin/services/database1.dart'; // Adjust the import as necessary

class EditTaskPage extends StatefulWidget {
  final String taskId;

  const EditTaskPage({Key? key, required this.taskId}) : super(key: key);

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  String? taskType; // Stores the selected task type
  // Controllers to handle the form fields
  TextEditingController taskNameController = TextEditingController();
  TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTaskDetails();
  }

  // Fetch task details from the database
  Future<void> _fetchTaskDetails() async {
    try {
      final taskDetails =
          await DatabaseMethods().getTaskDetailById(widget.taskId);
      setState(() {
        taskNameController.text = taskDetails["Task Name"];
        taskController.text = taskDetails["Task"];
        taskType = taskDetails["Task Type"]; // Assign task type
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching task details: $error')),
      );
    }
  }

  // Update task details
  Future<void> _updateTask() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await DatabaseMethods().updateTaskDetails(
          widget.taskId,
          taskNameController.text,
          taskController.text,
          taskType!,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating task: $error')),
        );
      }
    }
  }

  // Radio button widget for task type
  Widget _buildTaskTypeRadio(String value, String title) {
    return RadioListTile(
      title: Text(title),
      value: value,
      groupValue: taskType,
      onChanged: (String? selectedValue) {
        setState(() {
          taskType = selectedValue;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Task",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF27AE60),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: taskNameController,
                    decoration: const InputDecoration(
                      labelText: 'Task Name',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      taskNameController.text = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a task name.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: taskController,
                    decoration: const InputDecoration(
                      labelText: 'Task',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      taskController.text = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a task description.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    "Task Type",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  _buildTaskTypeRadio("Weekly", "Weekly"),
                  _buildTaskTypeRadio("Monthly", "Monthly"),

                  const SizedBox(height: 20),

                  // Update button
                  TextButton(
                    onPressed: _updateTask,
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF27AE60), // Button color
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Update Task',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
