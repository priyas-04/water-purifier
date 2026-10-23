import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/mock_data_service.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get isCustomer => _user?.role == UserRole.customer;
  bool get isDealer => _user?.role == UserRole.dealer;
  bool get isApprovedDealer => _user?.isApprovedDealer ?? false;
  bool get isPendingDealer => _user?.isPendingDealer ?? false;

  AuthProvider() {
    _initializeUser();
  }

  void _initializeUser() {
    // Default initial mock user for instant testing
    MockDataService.initializeDemoUser(role: UserRole.customer);
    _user = MockDataService.currentUser;
  }

  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 700));

    if (email.trim().isEmpty || password.isEmpty) {
      _errorMessage = 'Please enter both email and password.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (email.contains('dealer')) {
      MockDataService.initializeDemoUser(role: UserRole.dealer, dealerStatus: DealerStatus.approved);
      _user = MockDataService.currentUser;
    } else if (email.contains('pending')) {
      MockDataService.initializeDemoUser(role: UserRole.dealer, dealerStatus: DealerStatus.pending);
      _user = MockDataService.currentUser;
    } else {
      MockDataService.initializeDemoUser(role: UserRole.customer);
      _user = MockDataService.currentUser;
    }

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> registerCustomer({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    String? referralCode,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    _user = UserModel(
      uid: 'user-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      fullName: fullName,
      phone: phone,
      role: UserRole.customer,
      dealerStatus: DealerStatus.none,
      referralCode: 'AQ-${fullName.split(' ').first.toUpperCase()}${DateTime.now().millisecond}',
      referredBy: referralCode?.trim().isNotEmpty == true ? referralCode : null,
      addresses: [
        AddressModel(
          id: 'addr-default',
          label: 'Home',
          street: '102 Lakeview Residency',
          city: 'Bangalore',
          state: 'Karnataka',
          postalCode: '560037',
          isDefault: true,
        ),
      ],
      createdAt: DateTime.now(),
    );
    MockDataService.currentUser = _user;

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> registerDealer({
    required String fullName,
    required String companyName,
    required String email,
    required String phone,
    required String gstNumber,
    required String businessAddress,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 900));

    // Dealers ALWAYS begin with dealerStatus = pending per requirement
    _user = UserModel(
      uid: 'dealer-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      fullName: fullName,
      phone: phone,
      role: UserRole.dealer,
      dealerStatus: DealerStatus.pending,
      companyName: companyName,
      gstNumber: gstNumber,
      businessAddress: businessAddress,
      referralCode: 'AQ-DLR${DateTime.now().millisecond}',
      addresses: [
        AddressModel(
          id: 'addr-dealer',
          label: 'Business Warehouse',
          street: businessAddress,
          city: 'Bangalore',
          state: 'Karnataka',
          postalCode: '560048',
          isDefault: true,
        ),
      ],
      createdAt: DateTime.now(),
    );
    MockDataService.currentUser = _user;

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> switchDemoRole(UserRole role, {DealerStatus dealerStatus = DealerStatus.none}) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 300));
    MockDataService.initializeDemoUser(role: role, dealerStatus: dealerStatus);
    _user = MockDataService.currentUser;
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 700));
    _isLoading = false;
    notifyListeners();
    return true;
  }

  void addAddress(AddressModel address) {
    if (_user == null) return;
    final updatedList = List<AddressModel>.from(_user!.addresses)..add(address);
    _user = _user!.copyWith(addresses: updatedList);
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
