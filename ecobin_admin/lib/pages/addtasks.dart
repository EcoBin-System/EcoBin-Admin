import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider package
import 'package:random_string/random_string.dart';
import 'package:ecobin_admin/services/database1.dart';
import 'package:ecobin_admin/user_management/models/UserModel.dart';

class AddTasks extends StatefulWidget {
  const AddTasks({super.key});

  @override
  State<AddTasks> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTasks> {
  TextEditingController taskNameController = TextEditingController();
  TextEditingController taskController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? selectedTaskType; // Variable to store selected task type

  // Function to validate inputs
  bool validateInput() {
    if (taskNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a task name'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    if (taskController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a task description'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    if (selectedTaskType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a task type (Weekly or Monthly)'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }

  // Function to handle task submission
  Future<void> submitTask() async {
    if (validateInput()) {
      try {
        UserModel? user = Provider.of<UserModel?>(context, listen: false);
        String? userId = user?.uid;

        if (userId == null || userId.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User not logged in'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        String id = randomAlphaNumeric(10);

        Map<String, dynamic> taskInfoMap = {
          "Task Name": taskNameController.text,
          "Task": taskController.text,
          "Task Type": selectedTaskType, // Save task type
          "UserID": userId,
          "Id": id,
        };

        await DatabaseMethods().addTaskDetails(taskInfoMap, id);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task has been added successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Clear inputs after submission
        taskNameController.clear();
        taskController.clear();
        setState(() {
          selectedTaskType = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add task: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Function to handle task type selection
  void _handleTaskTypeSelection(String? value) {
    setState(() {
      selectedTaskType = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF27AE60),
        title: const Text(
          "Tasks",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(20.0),
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Task Name",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: taskNameController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Enter Task Name",
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Task",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: taskController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Enter Your Task",
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Task Type",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Radio<String>(
                    value: 'Weekly',
                    groupValue: selectedTaskType,
                    onChanged: _handleTaskTypeSelection,
                  ),
                  const Text('Weekly'),
                  Radio<String>(
                    value: 'Monthly',
                    groupValue: selectedTaskType,
                    onChanged: _handleTaskTypeSelection,
                  ),
                  const Text('Monthly'),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: submitTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF27AE60),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Submit Task'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
