import 'user_model.dart';

enum ServiceStatus {
  submitted,
  scheduled,
  technician_assigned,
  in_progress,
  completed,
  cancelled,
}

class ServiceBookingModel {
  final String id;
  final String userId;
  final String customerName;
  final String customerPhone;
  final String serviceType;
  final String preferredDate;
  final String preferredTimeSlot;
  final AddressModel address;
  final String issueDescription;
  final ServiceStatus status;
  final String? technicianName;
  final String? technicianPhone;
  final String serviceNotes;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceBookingModel({
    required this.id,
    required this.userId,
    required this.customerName,
    required this.customerPhone,
    required this.serviceType,
    required this.preferredDate,
    required this.preferredTimeSlot,
    required this.address,
    this.issueDescription = '',
    required this.status,
    this.technicianName,
    this.technicianPhone,
    this.serviceNotes = '',
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceBookingModel.fromMap(Map<String, dynamic> map, String id) {
    return ServiceBookingModel(
      id: id,
      userId: map['userId'] ?? '',
      customerName: map['customerName'] ?? '',
      customerPhone: map['customerPhone'] ?? '',
      serviceType: map['serviceType'] ?? 'Routine Maintenance',
      preferredDate: map['preferredDate'] ?? '',
      preferredTimeSlot: map['preferredTimeSlot'] ?? 'Morning (9 AM - 12 PM)',
      address: AddressModel.fromMap(map['address'] ?? {}),
      issueDescription: map['issueDescription'] ?? '',
      status: ServiceStatus.values.firstWhere(
        (e) => e.name == (map['status'] ?? 'submitted'),
        orElse: () => ServiceStatus.submitted,
      ),
      technicianName: map['technicianName'],
      technicianPhone: map['technicianPhone'],
      serviceNotes: map['serviceNotes'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'serviceType': serviceType,
      'preferredDate': preferredDate,
      'preferredTimeSlot': preferredTimeSlot,
      'address': address.toMap(),
      'issueDescription': issueDescription,
      'status': status.name,
      'technicianName': technicianName,
      'technicianPhone': technicianPhone,
      'serviceNotes': serviceNotes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
