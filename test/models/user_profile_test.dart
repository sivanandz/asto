import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/user_profile.dart';

void main() {
  group('UserProfile.copyWith', () {
    test('updates provided fields correctly', () {
      final original = UserProfile(
        name: 'Original Name',
        birthDate: DateTime(2000, 1, 1),
        birthTime: '12:00 PM',
        birthLocation: 'Original Location',
        latitude: 10.0,
        longitude: 20.0,
      );

      final updated = original.copyWith(
        name: 'New Name',
        birthDate: DateTime(2005, 5, 5),
        birthTime: '01:00 AM',
        birthLocation: 'New Location',
        latitude: 30.0,
        longitude: 40.0,
      );

      expect(updated.name, 'New Name');
      expect(updated.birthDate, DateTime(2005, 5, 5));
      expect(updated.birthTime, '01:00 AM');
      expect(updated.birthLocation, 'New Location');
      expect(updated.latitude, 30.0);
      expect(updated.longitude, 40.0);
    });

    test('preserves unprovided fields (null arguments)', () {
      final original = UserProfile(
        name: 'Original Name',
        birthDate: DateTime(2000, 1, 1),
        birthTime: '12:00 PM',
        birthLocation: 'Original Location',
        latitude: 10.0,
        longitude: 20.0,
      );

      final updated = original.copyWith();

      expect(updated.name, original.name);
      expect(updated.birthDate, original.birthDate);
      expect(updated.birthTime, original.birthTime);
      expect(updated.birthLocation, original.birthLocation);
      expect(updated.latitude, original.latitude);
      expect(updated.longitude, original.longitude);
    });

    test('preserves id and createdAt, and updates updatedAt', () async {
      final original = UserProfile(
        name: 'Original Name',
        birthDate: DateTime(2000, 1, 1),
        birthTime: '12:00 PM',
        birthLocation: 'Original Location',
      );

      final originalUpdatedAt = original.updatedAt;

      // Small delay to ensure updatedAt is demonstrably different if it uses DateTime.now()
      await Future.delayed(const Duration(milliseconds: 10));

      final updated = original.copyWith(name: 'Updated Name');

      expect(updated.id, original.id);
      expect(updated.createdAt, original.createdAt);
      expect(updated.updatedAt.isAfter(originalUpdatedAt), isTrue);
    });
  });
}
