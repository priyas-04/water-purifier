enum UserRole { customer, dealer, admin }

enum DealerStatus { none, pending, approved, rejected }

class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final String phone;
  final UserRole role;
  final DealerStatus dealerStatus;
  final String? companyName;
  final String? gstNumber;
  final String? businessAddress;
  final String referralCode;
  final String? referredBy;
  final List<AddressModel> addresses;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.role,
    this.dealerStatus = DealerStatus.none,
    this.companyName,
    this.gstNumber,
    this.businessAddress,
    required this.referralCode,
    this.referredBy,
    this.addresses = const [],
    required this.createdAt,
  });

  bool get isApprovedDealer => role == UserRole.dealer && dealerStatus == DealerStatus.approved;
  bool get isPendingDealer => role == UserRole.dealer && dealerStatus == DealerStatus.pending;
  bool get isRejectedDealer => role == UserRole.dealer && dealerStatus == DealerStatus.rejected;

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      uid: id,
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      phone: map['phone'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.name == (map['role'] ?? 'customer'),
        orElse: () => UserRole.customer,
      ),
      dealerStatus: DealerStatus.values.firstWhere(
        (e) => e.name == (map['dealerStatus'] ?? 'none'),
        orElse: () => DealerStatus.none,
      ),
      companyName: map['companyName'],
      gstNumber: map['gstNumber'],
      businessAddress: map['businessAddress'],
      referralCode: map['referralCode'] ?? 'AQ-${id.substring(0, 5).toUpperCase()}',
      referredBy: map['referredBy'],
      addresses: (map['addresses'] as List<dynamic>?)
              ?.map((a) => AddressModel.fromMap(a as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'role': role.name,
      'dealerStatus': dealerStatus.name,
      'companyName': companyName,
      'gstNumber': gstNumber,
      'businessAddress': businessAddress,
      'referralCode': referralCode,
      'referredBy': referredBy,
      'addresses': addresses.map((a) => a.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? fullName,
    String? phone,
    UserRole? role,
    DealerStatus? dealerStatus,
    String? companyName,
    String? gstNumber,
    String? businessAddress,
    List<AddressModel>? addresses,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      dealerStatus: dealerStatus ?? this.dealerStatus,
      companyName: companyName ?? this.companyName,
      gstNumber: gstNumber ?? this.gstNumber,
      businessAddress: businessAddress ?? this.businessAddress,
      referralCode: referralCode,
      referredBy: referredBy,
      addresses: addresses ?? this.addresses,
      createdAt: createdAt,
    );
  }
}

class AddressModel {
  final String id;
  final String label; // Home, Office, Warehouse
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final double? latitude;
  final double? longitude;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.label,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    this.latitude,
    this.longitude,
    this.isDefault = false,
  });

  String get fullAddress => '$street, $city, $state - $postalCode';

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      label: map['label'] ?? 'Home',
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      postalCode: map['postalCode'] ?? '',
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      isDefault: map['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'street': street,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'latitude': latitude,
      'longitude': longitude,
      'isDefault': isDefault,
    };
  }
}
