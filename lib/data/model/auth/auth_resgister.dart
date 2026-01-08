class AuthRegister {
  String name;
  String email;
  String phone;
  String password;

  AuthRegister({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'phone': phone, 'password': password};
  }
}
