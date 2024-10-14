import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to add bin details to Firestore and return the document ID
  Future<String> addBinDetails({
    required String binType,
    required String binHeight,
    required String postalCode,
    required String city,
    required String status,
    required String collectionFrequency,

    String availability = '100%', // Default value
  }) async {
    try {
      DocumentReference docRef = await _firestore.collection('public_bins').add({
        'binType': binType,
        'binHeight': binHeight,
        'availability': availability,
        'postalCode': postalCode,
        'city': city,
        'status': status,
        'collectionFrequency': collectionFrequency
      });
      return docRef.id; // Return the document ID for QR code generation
    } catch (e) {
      print('Error adding bin details: $e');
      throw Exception('Failed to add bin details');
    }
  }

  // Method to retrieve all bin details
  Future<List<DocumentSnapshot>> getBins() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('public_bins').get();
      return querySnapshot.docs; // Return list of all bin documents
    } catch (e) {
      print('Error retrieving bin details: $e');
      throw Exception('Failed to retrieve bin details');
    }
  }

  // Method to retrieve bin details by ID
  Future<DocumentSnapshot> getBinDetailsById(String binId) async {
    try {
      DocumentSnapshot binDoc = await _firestore.collection('public_bins').doc(binId).get();
      return binDoc;
    } catch (e) {
      print('Error retrieving bin details: $e');
      throw Exception('Failed to retrieve bin details');
    }
  }

  // Method to update bin availability
  Future<void> updateBinAvailability(String binType, String newAvailability) async {
    try {
      // You might want to specify which bin to update based on binType
      QuerySnapshot querySnapshot = await _firestore.collection('public_bins')
          .where('binType', isEqualTo: binType)
          .get();

      for (var binDoc in querySnapshot.docs) {
        await binDoc.reference.update({
          'availability': newAvailability,
        });
      }
    } catch (e) {
      print('Error updating bin availability: $e');
      throw Exception('Failed to update bin availability');
    }
  }

  // Method to update bin details
  Future<void> updateBinDetails({
    required String binId,
    required String binType,
    required String binHeight,
    required String postalCode,
    required String city,
    required String status,
    required String collectionFrequency,

  }) async {
    try {
      await _firestore.collection('public_bins').doc(binId).update({
        'binType': binType,
        'binHeight': binHeight,
        'postalCode': postalCode,
        'city': city,
        'status': status,
        'collectionFrequency': collectionFrequency
      });
    } catch (e) {
      print('Error updating bin details: $e');
      throw Exception('Failed to update bin details');
    }
  }

  // Method to delete bin
  Future<void> deleteBin(String binId) async {
    try {
      await _firestore.collection('public_bins').doc(binId).delete();
    } catch (e) {
      print('Error deleting bin: $e');
      throw Exception('Failed to delete bin');
    }
  }
}
