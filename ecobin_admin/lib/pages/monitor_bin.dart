import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecobin_admin/pages/bin_web_add_bin.dart';
import 'package:ecobin_admin/services/database.dart';
import 'package:ecobin_admin/services/notification_service.dart';
import 'package:ecobin_admin/pages/notification.dart';

class MonitorBin extends StatefulWidget {
  @override
  _MonitorBinState createState() => _MonitorBinState();
}

class _MonitorBinState extends State<MonitorBin> {
  final DatabaseService _databaseService = DatabaseService();

  // Stream to retrieve bin details from Firestore
  Stream<QuerySnapshot> _getBinStream() {
    return FirebaseFirestore.instance.collection('public_bins').snapshots();
  }

  // Method to show update bin dialog
  void _showUpdateDialog(
      String binId,
      String currentType,
      String currentHeight,
      String currentPostalCode,
      String currentCity,
      String currentStatus,
      String currentCollectionFrequency) {
    final TextEditingController binTypeController =
        TextEditingController(text: currentType);
    final TextEditingController binHeightController =
        TextEditingController(text: currentHeight);
    final TextEditingController postalCodeController =
        TextEditingController(text: currentPostalCode);
    final TextEditingController cityController =
        TextEditingController(text: currentCity);
    final TextEditingController statusController =
        TextEditingController(text: currentStatus);
    final TextEditingController collectionFrequencyController =
        TextEditingController(text: currentCollectionFrequency);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Bin'),
          content: Container(
            width: 400.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                TextField(
                  controller: binTypeController,
                  decoration: const InputDecoration(labelText: 'Bin Type (Plastic, Organic, Recyclable, Other) :'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: binHeightController,
                  decoration: const InputDecoration(labelText: 'Bin Height (cm) :'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: postalCodeController,
                  decoration: const InputDecoration(labelText: 'Postal Code :'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: cityController,
                  decoration: const InputDecoration(labelText: 'City :'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: statusController,
                  decoration: const InputDecoration(labelText: 'Status (Active or Inactive) :'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: collectionFrequencyController,
                  decoration:
                      const InputDecoration(labelText: 'Collection Frequency (Daily, Weekly, Monthly) :'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _databaseService.updateBinDetails(
                  binId: binId,
                  binType: binTypeController.text,
                  binHeight: binHeightController.text,
                  postalCode: postalCodeController.text,
                  city: cityController.text,
                  status: statusController.text,
                  collectionFrequency: collectionFrequencyController.text,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4AA04B),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  // Method to delete a bin with confirmation
  void _deleteBin(String binId) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete Bin'),
        content: Container(
          width: 400.0,
          child: const Text('Are you sure you want to delete this bin?'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _databaseService.deleteBin(binId);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9F2D25),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'BIN',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Row(
        children: [
          // Sidebar menu
          Container(
            width: 250,
            color: Colors.green[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Dashboard',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Monitoring'),
                  onTap: () {
                    // Navigate to bin section
                  },
                ),
                ListTile(
                  title: const Text('Notifications'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationPage(
                          notificationService:
                              NotificationService(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // Main content area
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Fixed at the top)
                Container(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    left: 40.0,
                    right: 20.0,
                    bottom: 5.0,
                  ),
                  width: double.infinity,
                  child: const Text(
                    'Bin Selection & Add Details',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    left: 40.0,
                    right: 20.0,
                    bottom: 10.0,
                  ),
                  child: Text(
                    'Public bins in every city. In here you can Monitor bin status & details.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 30),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BinWebAddbin()),
                              );
                            },
                            child: const Text('Add Bin'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[800],
                              foregroundColor: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 50),
                          const Text(
                            'Public Bins',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Displaying bin data in a table with action buttons
                          StreamBuilder<QuerySnapshot>(
                            stream: _getBinStream(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              // Extract data from snapshot
                              var bins = snapshot.data!.docs;

                              return Center(
                                // Center the table
                                child: SingleChildScrollView(
                                  scrollDirection: Axis
                                      .horizontal, // Horizontal scrolling for the table
                                  child: DataTable(
                                    columns: const [
                                      DataColumn(
                                          label: Text('Bin Type',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17))),
                                      DataColumn(
                                          label: Text('Bin Height',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17))),
                                      DataColumn(
                                          label: Text('Postal Code',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17))),
                                      DataColumn(
                                          label: Text('City',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17))),
                                      DataColumn(
                                          label: Text('Status',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17))),
                                      DataColumn(
                                          label: Text('Availability',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17))),
                                      DataColumn(
                                          label: Text('collection Freq.',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17))),
                                      DataColumn(
                                          label: Text('Actions',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      17))),
                                    ],
                                    rows: bins.map((bin) {
                                      return DataRow(
                                        cells: [
                                          DataCell(
                                            SizedBox(
                                              width:
                                                  80, 
                                              child:
                                                  Text(bin['binType'] ?? 'N/A'),
                                            ),
                                          ),
                                          DataCell(
                                            SizedBox(
                                              width:
                                                  80,
                                              child: Text(
                                                  bin['binHeight'] ?? 'N/A'),
                                            ),
                                          ),
                                          DataCell(
                                            SizedBox(
                                              width:
                                                  80,
                                              child: Text(
                                                  bin['postalCode'] ?? 'N/A'),
                                            ),
                                          ),
                                          DataCell(
                                            SizedBox(
                                              width:
                                                  100,
                                              child: Text(bin['city'] ?? 'N/A'),
                                            ),
                                          ),
                                          DataCell(
                                            SizedBox(
                                              width:
                                                  80,
                                              child:
                                                  Text(bin['status'] ?? 'N/A'),
                                            ),
                                          ),
                                          DataCell(
                                            SizedBox(
                                              width:
                                                  80,
                                              child: Text(
                                                  bin['availability'] ?? 'N/A'),
                                            ),
                                          ),
                                          DataCell(
                                            SizedBox(
                                              width:
                                                  100,
                                              child: Text(
                                                  bin['collectionFrequency'] ??
                                                      'N/A'),
                                            ),
                                          ),
                                          DataCell(
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.edit),
                                                  onPressed: () {
                                                    _showUpdateDialog(
                                                      bin.id,
                                                      bin['binType'] ?? 'N/A',
                                                      bin['binHeight'] ?? 'N/A',
                                                      bin['postalCode'] ??
                                                          'N/A',
                                                      bin['city'] ?? 'N/A',
                                                      bin['status'] ?? 'N/A',
                                                      bin['collectionFrequency'] ??
                                                          'N/A',
                                                    );
                                                  },
                                                ),
                                                const SizedBox(width: 10),
                                                IconButton(
                                                  icon:
                                                      const Icon(Icons.delete),
                                                  onPressed: () {
                                                    _deleteBin(bin.id);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
