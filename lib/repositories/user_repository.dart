import '../database/database_helper.dart';
import '../models/user_profile.dart';

class UserRepository {
  final DatabaseHelper _db;

  UserRepository(this._db);

  Future<UserProfile> createUser({
    required String name,
    required DateTime birthDate,
    required String birthTime,
    required String birthLocation,
    double? latitude,
    double? longitude,
  }) async {
    final user = UserProfile(
      name: name,
      birthDate: birthDate,
      birthTime: birthTime,
      birthLocation: birthLocation,
      latitude: latitude,
      longitude: longitude,
    );

    await _db.insertUserProfile(user);
    return user;
  }

  Future<UserProfile?> getUser(String id) async {
    return await _db.getUserProfile(id);
  }

  Future<UserProfile?> getDefaultUser() async {
    return await _db.getDefaultUserProfile();
  }

  Future<List<UserProfile>> getAllUsers() async {
    return await _db.getAllUserProfiles();
  }

  Future<void> updateUser(UserProfile user) async {
    await _db.updateUserProfile(user);
  }

  Future<void> deleteUser(String id) async {
    await _db.deleteUserProfile(id);
  }
}