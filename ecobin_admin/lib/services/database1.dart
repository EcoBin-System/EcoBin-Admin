import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to add goal details
  Future<void> addGoalDetails(
      Map<String, dynamic> goalInfoMap, String id) async {
    await _firestore.collection('goals').doc(id).set(goalInfoMap);
  }

  // Method to add task details
  Future<void> addTaskDetails(
      Map<String, dynamic> taskInfoMap, String id) async {
    await _firestore.collection('tasks').doc(id).set(taskInfoMap);
  }

  // Method to fetch task details from Firestore
  Future<List<Map<String, dynamic>>> getTaskDetails() async {
    List<Map<String, dynamic>> taskList = [];
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('tasks').get();

      for (var doc in snapshot.docs) {
        taskList.add({
          "Task Name": doc['Task Name'],
          "Task": doc['Task'],
          "Task Type": doc['Task Type'],
          "UserID": doc['UserID'],
          "Id": doc['Id'],
        });
      }
    } catch (e) {
      print("Error fetching tasks: $e");
      throw e;
    }
    return taskList;
  }

  // Function to delete task details
  Future<void> deleteTaskDetails(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
    } catch (e) {
      throw Exception("Error deleting task: $e");
    }
  }

  // Function to get task details by ID
  Future<Map<String, dynamic>> getTaskDetailById(String taskId) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('tasks').doc(taskId).get();
      return snapshot.data() as Map<String, dynamic>;
    } catch (e) {
      throw Exception("Error fetching task details: $e");
    }
  }

  // Function to update task details
  Future<void> updateTaskDetails(
      String taskId, String taskName, String task, String taskType) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update({
        "Task Name": taskName,
        "Task": task,
        "Task Type": taskType,
      });
    } catch (e) {
      throw Exception("Error updating task: $e");
    }
  }
}
