class AuthLogin {
  final String? email;
  final String? password;

  AuthLogin({this.email, this.password});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}
