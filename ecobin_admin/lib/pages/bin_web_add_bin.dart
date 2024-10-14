import 'package:flutter/material.dart';
import 'package:ecobin_admin/pages/notification.dart';
import 'package:ecobin_admin/services/database.dart';
import 'package:ecobin_admin/pages/monitor_bin.dart';
import 'package:ecobin_admin/pages/bin_web_qr.dart';
import 'package:ecobin_admin/services/notification_service.dart';

class BinWebAddbin extends StatefulWidget {
  @override
  _BinWebAddbinState createState() => _BinWebAddbinState();
}

class _BinWebAddbinState extends State<BinWebAddbin> {
  // TextEditingControllers for the form fields
  final TextEditingController binHeightController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  String selectedBinType = 'Select Bin Type';
  String selectedStatus = 'Select Status';
  String selectedCollectionFrequency = 'Select Collection Frequency';

  // Instance of DatabaseService
  final DatabaseService _databaseService = DatabaseService();

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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MonitorBin()),
                    );
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Move title to the top
                    const Padding(
                      padding: EdgeInsets.only(
                          bottom:
                              50.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bin Selection & Add Details',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Add Public Bin Details.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),

                    // Form
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Column(
                        children: [
                          _buildDropdown(
                              'Bin Type :', selectedBinType, _binTypeOptions(),
                              (value) {
                            setState(() {
                              selectedBinType = value!;
                            });
                          }),
                          const SizedBox(height: 30),
                          _buildTextField('Bin Height (cm) :', binHeightController),
                          const SizedBox(height: 30),
                          _buildTextField('Postal Code :', postalCodeController),
                          const SizedBox(height: 30),
                          _buildTextField('City :', cityController),
                          const SizedBox(height: 30),
                          _buildDropdown(
                              'Status :', selectedStatus, _statusOptions(),
                              (value) {
                            setState(() {
                              selectedStatus = value!;
                            });
                          }),
                          const SizedBox(height: 30),
                          _buildDropdown(
                              'Collection Frequency :',
                              selectedCollectionFrequency,
                              _collectionFrequencyOptions(), (value) {
                            setState(() {
                              selectedCollectionFrequency = value!;
                            });
                          }),
                          const SizedBox(height: 50),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                _submitForm();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[800],
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 15.0),
                              ),
                              child: const Text(
                                'Generate QR & Submit',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true, // Reduces height of TextField
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String value,
      List<DropdownMenuItem<String>> options, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: options,
          onChanged: onChanged,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> _binTypeOptions() {
    return const [
      DropdownMenuItem(
          value: 'Select Bin Type', child: Text('Select Bin Type')),
      DropdownMenuItem(value: 'Recyclable', child: Text('Recyclable')),
      DropdownMenuItem(value: 'Plastic', child: Text('Plastic')),
      DropdownMenuItem(value: 'Organic', child: Text('Organic')),
      DropdownMenuItem(value: 'Other', child: Text('Other')),
    ];
  }

  List<DropdownMenuItem<String>> _statusOptions() {
    return const [
      DropdownMenuItem(value: 'Select Status', child: Text('Select Status')),
      DropdownMenuItem(value: 'Active', child: Text('Active')),
      DropdownMenuItem(value: 'Inactive', child: Text('Inactive')),
    ];
  }

  List<DropdownMenuItem<String>> _collectionFrequencyOptions() {
    return const [
      DropdownMenuItem(
          value: 'Select Collection Frequency',
          child: Text('Select Collection Frequency')),
      DropdownMenuItem(value: 'Daily', child: Text('Daily')),
      DropdownMenuItem(value: 'Weekly', child: Text('Weekly')),
      DropdownMenuItem(value: 'Bi-weekly', child: Text('Bi-weekly')),
      DropdownMenuItem(value: 'Monthly', child: Text('Monthly')),
    ];
  }

  // Function to submit the form and save the data to Firestore via the database service
  Future<void> _submitForm() async {
    // Validate fields
    if (selectedBinType == 'Select Bin Type' ||
        binHeightController.text.isEmpty ||
        postalCodeController.text.isEmpty ||
        cityController.text.isEmpty ||
        selectedStatus == 'Select Status' ||
        selectedCollectionFrequency == 'Select Collection Frequency') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    // Call the method in DatabaseService to add bin details
    try {
      String binId = await _databaseService.addBinDetails(
        binType: selectedBinType,
        binHeight: binHeightController.text,
        postalCode: postalCodeController.text,
        city: cityController.text,
        status: selectedStatus,
        collectionFrequency: selectedCollectionFrequency,
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bin details successfully added!')));

      // Clear form
      binHeightController.clear();
      postalCodeController.clear();
      cityController.clear();
      setState(() {
        selectedBinType = 'Select Bin Type';
        selectedStatus = 'Select Status';
        selectedCollectionFrequency = 'Select Collection Frequency';
      });

      // Navigate to BinWebQr page with the bin ID
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BinWebQr(binId: binId)),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add bin details: $e')),
      );
    }
  }
}
