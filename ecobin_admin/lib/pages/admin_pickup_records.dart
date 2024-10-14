import 'package:flutter/material.dart';
import 'package:ecobin_admin/services/firebase_services.dart';
import 'package:ecobin_admin/models/pickup_request.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';

class AdminPickupRecordsPage extends StatefulWidget {
  @override
  _AdminPickupRecordsPageState createState() => _AdminPickupRecordsPageState();
}

class _AdminPickupRecordsPageState extends State<AdminPickupRecordsPage> {
  final FirebaseService _firebaseService = FirebaseService();
  final Logger _logger = Logger();
  DateTime? _selectedDate;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF27AE60),
        elevation: 0,
        title: const Text(
          'User Pickup Requests',
          style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today,
                color: Color.fromARGB(255, 255, 255, 255)),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          if (_selectedDate != null) _buildDateFilter(),
          Expanded(
            child: _buildTable(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
            _logger.i('Search query updated: $_searchQuery');
          });
        },
        decoration: InputDecoration(
          hintText: 'Search requests',
          iconColor: Colors.white,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  Widget _buildDateFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          const Text('Filtered by: ',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Chip(
            label: Text(
              DateFormat('yyyy-MM-dd').format(_selectedDate!),
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color.fromARGB(255, 65, 189, 116),
            deleteIcon: const Icon(Icons.close, color: Colors.white),
            onDeleted: () {
              setState(() {
                _logger.i('Date filter cleared');
                _selectedDate = null;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTable() {
    return StreamBuilder<List<PickupRequest>>(
      stream: _firebaseService.getAllPickupRequests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          _logger.e('Error fetching pickup requests: ${snapshot.error}');
          return _buildErrorMessage('Error fetching pickup requests.');
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          _logger.w('No pickup requests found');
          return _buildErrorMessage('No pickup requests found.');
        }

        List<PickupRequest> filteredRequests = _filterRequests(snapshot.data!);
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.grey[50]),
              dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(0.08);
                }
                return null;
              }),
              columnSpacing: 20,
              horizontalMargin: 20,
              columns: [
                DataColumn(label: _buildColumnHeader('ID')),
                DataColumn(label: _buildColumnHeader('Date')),
                DataColumn(label: _buildColumnHeader('Time')),
                DataColumn(label: _buildColumnHeader('Address')),
                DataColumn(label: _buildColumnHeader('Garbage Bins')),
                DataColumn(label: _buildColumnHeader('Total Payment')),
                DataColumn(label: _buildColumnHeader('Status')),
                DataColumn(label: _buildColumnHeader('Actions')),
              ],
              rows: filteredRequests
                  .map((request) => _buildDataRow(request))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildColumnHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  DataRow _buildDataRow(PickupRequest request) {
    return DataRow(
      cells: [
        DataCell(Text(request.id ?? '',
            style: const TextStyle(
                color: Colors.blue, fontWeight: FontWeight.w500))),
        DataCell(Text(DateFormat.yMMMd().format(request.pickupDate.toLocal()))),
        DataCell(Text(request.pickupTime ?? 'N/A')),
        DataCell(Text(request.userAddress)),
        DataCell(Text(request.garbageBinDetails
            .map((bin) => "${bin['type']}: ${bin['percentage']}%")
            .join(', '))),
        DataCell(Text(
          'LKR ${request.totalPayment.toStringAsFixed(2)}',
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
        )),
        DataCell(_buildStatusDropdown(request)),
        DataCell(
          IconButton(
            icon: const Icon(Icons.delete,
                color: Color.fromARGB(255, 176, 27, 16)),
            onPressed: () => _showDeleteConfirmation(request),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusDropdown(PickupRequest request) {
    List<String> statusOptions = ['Pending', 'Completed', 'Cancelled'];

    // Ensure the status is valid and not null.
    String currentStatus =
        statusOptions.contains(request.status) ? request.status : 'Pending';

    return DropdownButton<String>(
      value: currentStatus,
      isExpanded: true,
      items: statusOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Row(
            children: [
              _buildStatusChip(value),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        );
      }).toList(),
      onChanged: (String? newStatus) {
        if (newStatus != null && newStatus != currentStatus) {
          _updateRequestStatus(request.id!, newStatus);
        }
      },
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    IconData iconData;
    switch (status.toLowerCase()) {
      case 'completed':
        chipColor = const Color.fromARGB(255, 117, 159, 226);
        iconData = Icons.check_circle;
        break;
      case 'pending':
        chipColor = const Color.fromARGB(255, 126, 233, 142);
        iconData = Icons.access_time;
        break;
      case 'cancelled':
        chipColor = const Color.fromARGB(255, 231, 134, 127);
        iconData = Icons.cancel;
        break;
      default:
        chipColor = Colors.grey;
        iconData = Icons.help;
    }

    return Chip(
      label: Text(status,
          style: const TextStyle(color: Colors.white, fontSize: 12)),
      backgroundColor: chipColor,
      avatar: Icon(iconData, color: Colors.white, size: 16),
    );
  }

  List<PickupRequest> _filterRequests(List<PickupRequest> requests) {
    return requests.where((request) {
      bool dateMatches = _selectedDate == null ||
          DateUtils.isSameDay(request.pickupDate, _selectedDate);
      bool searchMatches = _searchQuery.isEmpty ||
          request.userAddress
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          request.id!.toLowerCase().contains(_searchQuery.toLowerCase());
      return dateMatches && searchMatches;
    }).toList();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _logger.i('Date selected: ${picked.toIso8601String()}');
        _selectedDate = picked;
      });
    }
  }

  void _updateRequestStatus(String requestId, String newStatus) async {
    try {
      await _firebaseService.updatePickupRequestStatus(requestId, newStatus);
      _logger.i(
          'Pickup request status updated to $newStatus for request ID: $requestId');
    } catch (e) {
      _logger.e('Error updating pickup request status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error updating status.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showDeleteConfirmation(PickupRequest request) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this request?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                _deletePickupRequest(request.id!);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deletePickupRequest(String requestId) async {
    try {
      await _firebaseService.deletePickupRequest(requestId);
      _logger.i('Pickup request deleted successfully: $requestId');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pickup request deleted successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      _logger.e('Error deleting pickup request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error deleting request.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildErrorMessage(String message) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
    );
  }
}
