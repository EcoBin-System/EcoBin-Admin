import 'package:ecobin_admin/services/firebase_services.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF27AE60),
        title: Text(
          'User Pickup Records',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.calendar_today,
              color: const Color.fromARGB(255, 53, 53, 53),
            ),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_selectedDate != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Chip(
                label: Text(
                  'Filtered: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
                ),
                onDeleted: () {
                  setState(() {
                    _selectedDate = null;
                  });
                },
              ),
            ),
          Expanded(
            child: StreamBuilder<List<PickupRequest>>(
              stream: _firebaseService.getAllPickupRequests(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  _logger
                      .e('Error fetching pickup requests: ${snapshot.error}');
                  return _buildErrorMessage('Error fetching pickup requests.');
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildErrorMessage('No pickup requests found.');
                }

                List<PickupRequest> filteredRequests =
                    _filterRequests(snapshot.data!);

                return ListView.builder(
                  itemCount: filteredRequests.length,
                  itemBuilder: (context, index) {
                    PickupRequest request = filteredRequests[index];
                    return AdminPickupRecordCard(
                      request: request,
                      onStatusUpdate: (String newStatus) {
                        _updateRequestStatus(request.id!, newStatus);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<PickupRequest> _filterRequests(List<PickupRequest> requests) {
    if (_selectedDate == null) {
      return requests;
    }
    return requests.where((request) {
      return DateUtils.isSameDay(request.pickupDate, _selectedDate);
    }).toList();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _updateRequestStatus(String requestId, String newStatus) async {
    try {
      await _firebaseService.updatePickupRequestStatus(requestId, newStatus);
      _logger.i('Status updated successfully for request: $requestId');
    } catch (e) {
      _logger.e('Error updating status for request $requestId: $e');
      _showSnackBar('Error updating status. Please try again.');
    }
  }

  Widget _buildErrorMessage(String message) {
    return Center(
      child: Text(
        message,
        style: TextStyle(color: Colors.red, fontSize: 18),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class AdminPickupRecordCard extends StatelessWidget {
  final PickupRequest request;
  final Function(String) onStatusUpdate;

  const AdminPickupRecordCard({
    Key? key,
    required this.request,
    required this.onStatusUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildDateTimeRow(),
            const SizedBox(height: 16),
            _buildAddressRow(),
            const SizedBox(height: 16),
            _buildStatusDropdown(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            'Request ID: ${request.id}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _buildStatusChip(),
      ],
    );
  }

  Widget _buildStatusChip() {
    return Chip(
      label: Text(
        request.status,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: _getStatusColor(),
    );
  }

  Color _getStatusColor() {
    switch (request.status.toLowerCase()) {
      case 'completed':
        return const Color.fromARGB(255, 96, 112, 169);
      case 'pending':
        return const Color.fromARGB(255, 156, 208, 131);
      case 'cancelled':
        return const Color.fromARGB(255, 208, 128, 122);
      default:
        return const Color.fromARGB(255, 174, 174, 174);
    }
  }

  Widget _buildDateTimeRow() {
    String formattedDate =
        DateFormat.yMMMd().format(request.pickupDate.toLocal());
    String formattedTime = request.pickupTime ?? "N/A";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildInfoItem(Icons.calendar_today, 'Date', formattedDate),
        _buildInfoItem(Icons.access_time, 'Time', formattedTime),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text('$label: $value', style: TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildAddressRow() {
    return Text(
      'Address: ${request.userAddress}',
      style: TextStyle(fontSize: 14),
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButton<String>(
      value: request.status,
      items: ['pending', 'completed', 'cancelled'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          onStatusUpdate(newValue);
        }
      },
    );
  }
}
