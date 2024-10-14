import 'package:ecobin_admin/pages/addtasks.dart';
import 'package:ecobin_admin/pages/admin_pickup_records.dart';
import 'package:ecobin_admin/pages/monitor_bin.dart';
import 'package:ecobin_admin/pages/tasks.dart';
import 'package:ecobin_admin/user_management/services/auth.dart';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Create an AuthService instance
  final AuthServices _auth = AuthServices();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0XffE7EBE8),
        appBar: AppBar(
          title: const Text(
            'Home',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0Xff27AE60),
          centerTitle: true, // This centers the title
          actions: [
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Color(0Xff27AE60)),
              ),
              onPressed: () async {
                await _auth.signOut();
              },
              child: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                // First Card: Pickup Records
                Card(
                  color: const Color(0Xff27AE60),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminPickupRecordsPage()),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Icon(Icons.list_alt, color: Colors.white, size: 40),
                          SizedBox(width: 20),
                          Text(
                            "Pickup Records",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),

                // Second Card: Monitor Bin
                Card(
                  color: const Color(0Xff27AE60),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MonitorBin()),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Icon(Icons.delete_outline,
                              color: Colors.white, size: 40),
                          SizedBox(width: 20),
                          Text(
                            "Monitor Bin",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Card(
                  color: const Color(0Xff27AE60),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TaskListPage()),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Icon(Icons.task_alt, color: Colors.white, size: 40),
                          SizedBox(width: 20),
                          Text(
                            "Tasks",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),

                // Third Card: Analytics
                Card(
                  color: const Color(0Xff27AE60),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: InkWell(
                    onTap: () {
                      // No action defined for Analytics yet
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Icon(Icons.analytics_outlined,
                              color: Colors.white, size: 40),
                          SizedBox(width: 20),
                          Text(
                            "Analytics",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
