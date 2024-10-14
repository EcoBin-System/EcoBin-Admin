import 'package:cloud_firestore/cloud_firestore.dart';

class PickupRequest {
  final String? id;
  final String userId;
  final String userName;
  final String userAddress;
  final DateTime pickupDate;
  final String pickupTime;
  final List<Map<String, dynamic>> garbageBinDetails;
  final double totalPayment;
  final String paymentMethod;
  final String status;
  final DateTime createdAt;

  PickupRequest({
    this.id,
    required this.userId,
    required this.userName,
    required this.userAddress,
    required this.pickupDate,
    required this.pickupTime,
    required this.garbageBinDetails,
    required this.totalPayment,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
  });

  factory PickupRequest.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PickupRequest(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userAddress: data['userAddress'] ?? '',
      pickupDate: (data['pickupDate'] as Timestamp).toDate(),
      pickupTime: data['pickupTime'] ?? '',
      garbageBinDetails:
          List<Map<String, dynamic>>.from(data['garbageBinDetails'] ?? []),
      totalPayment: (data['totalPayment'] ?? 0).toDouble(),
      paymentMethod: data['paymentMethod'] ?? '',
      status: data['status'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
