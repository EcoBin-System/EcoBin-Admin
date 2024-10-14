import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecobin_admin/models/pickup_request.dart';
import 'package:logger/logger.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  // Fetch all pickup requests
  Stream<List<PickupRequest>> getAllPickupRequests() {
    _logger.i('Fetching all pickup requests');
    return _firestore
        .collection('pickupRequests')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PickupRequest.fromFirestore(doc))
            .toList());
  }

  // Update pickup request status
  Future<void> updatePickupRequestStatus(
      String requestId, String newStatus) async {
    try {
      _logger.i('Updating status for request: $requestId to $newStatus');
      await _firestore.collection('pickupRequests').doc(requestId).update({
        'status': newStatus,
      });
      _logger.i('Status updated successfully for request: $requestId');
    } catch (e) {
      _logger.e('Error updating status for request: $requestId, Error: $e');
      throw Exception("Failed to update request status: $e");
    }
  }
}
