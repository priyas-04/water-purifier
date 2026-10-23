import 'package:flutter_test/flutter_test.dart';
import 'package:water_purifier_app/models/user_model.dart';

void main() {
  group('User Role & Dealer Approval Status Tests', () {
    test('Customer role defaults to none dealerStatus', () {
      final user = UserModel(
        uid: 'user-1',
        email: 'customer@example.com',
        fullName: 'Test Customer',
        phone: '9876543210',
        role: UserRole.customer,
        referralCode: 'AQ-TEST',
        createdAt: DateTime.now(),
      );

      expect(user.role, UserRole.customer);
      expect(user.dealerStatus, DealerStatus.none);
      expect(user.isApprovedDealer, false);
      expect(user.isPendingDealer, false);
    });

    test('Dealer with pending status cannot access approved wholesale tier', () {
      final pendingDealer = UserModel(
        uid: 'dealer-1',
        email: 'dealer@example.com',
        fullName: 'Pending Dealer',
        phone: '9876543210',
        role: UserRole.dealer,
        dealerStatus: DealerStatus.pending,
        companyName: 'Acme Traders',
        gstNumber: '29AAAAA0000A1Z5',
        referralCode: 'AQ-DLR',
        createdAt: DateTime.now(),
      );

      expect(pendingDealer.role, UserRole.dealer);
      expect(pendingDealer.dealerStatus, DealerStatus.pending);
      expect(pendingDealer.isPendingDealer, true);
      expect(pendingDealer.isApprovedDealer, false); // Crucial security invariant
    });

    test('Dealer with approved status unlocks wholesale permissions', () {
      final approvedDealer = UserModel(
        uid: 'dealer-2',
        email: 'approved@example.com',
        fullName: 'Approved Dealer',
        phone: '9876543210',
        role: UserRole.dealer,
        dealerStatus: DealerStatus.approved,
        companyName: 'Apex Water Systems',
        gstNumber: '29BBBBB0000B1Z5',
        referralCode: 'AQ-DLR2',
        createdAt: DateTime.now(),
      );

      expect(approvedDealer.isApprovedDealer, true);
      expect(approvedDealer.isPendingDealer, false);
    });
  });
}
