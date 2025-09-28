// import '../models/user.dart';



import '../models/user.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final User _validUser = User(username: 'Emily', password: 'password123');
  bool _isLoggedIn = false;

  bool login(String username, String password) {
    if (_validUser.authenticate(username, password)) {
      _isLoggedIn = true;
      return true;
    }
    return false;
  }

  void logout() {
    _isLoggedIn = false;
  }

  bool get isLoggedIn => _isLoggedIn;
}