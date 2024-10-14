import 'package:ecobin_admin/pages/admin_pickup_records.dart';
import 'package:ecobin_admin/pages/monitor_bin.dart';
import 'package:ecobin_admin/user_management/services/auth.dart';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //create a obj form Authservice
  final AuthServices _auth = AuthServices();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0XffE7EBE8),
        appBar: AppBar(
          title: const Text(
            'Home',
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
          backgroundColor: const Color(0Xff27AE60),
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
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                const Text(
                  "HOME",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 30),
                const SizedBox(height: 60),
                Center(
                  child: Image.asset(
                    "assets/images/man.png",
                    height: 200,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminPickupRecordsPage()),
                    );
                  },
                  child: const Text("Pickup records"),
                ),
                const SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MonitorBin()),
                    );
                  },
                  child: const Text("Monitor Bin"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
