import '../models/user_model.dart';
import '../mock_data/mock_healthcare_data.dart';

abstract class IAuthRepository {
  Future<UserModel?> login(String email, String password);
  Future<UserModel?> loginWithBiometrics();
  Future<UserModel?> register(String name, String email, String password);
  Future<void> logout();
  UserModel getCurrentUser();
  Future<UserModel> updateProfile(UserModel user);
}

class AuthRepository implements IAuthRepository {
  UserModel _currentUser = MockHealthcareData.currentUser;

  @override
  UserModel getCurrentUser() => _currentUser;

  @override
  Future<UserModel?> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));
    _currentUser = _currentUser.copyWith(email: email);
    return _currentUser;
  }

  @override
  Future<UserModel?> loginWithBiometrics() async {
    // Simulate biometric sensor hardware scan (Face ID / Fingerprint)
    await Future.delayed(const Duration(milliseconds: 700));
    return _currentUser;
  }

  @override
  Future<UserModel?> register(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _currentUser = _currentUser.copyWith(name: name, email: email);
    return _currentUser;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<UserModel> updateProfile(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _currentUser = user;
    return _currentUser;
  }
}
