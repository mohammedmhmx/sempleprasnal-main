class User {
  final String username;
  final String password;

  User({required this.username, required this.password});

  bool authenticate(String inputUsername, String inputPassword) {
    return username == inputUsername && password == inputPassword;
  }
}