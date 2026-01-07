class UserResponse {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;

  final DateTime? birthday;
  final String? gender;
  final String? address;

  final String? avatarUrl;

  UserResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.birthday,
    required this.gender,
    required this.address,
    required this.avatarUrl,
  });

  String getBirthdayFormatted() {
    if (birthday == null) return '';
    return '${birthday!.day.toString().padLeft(2, '0')}/'
        '${birthday!.month.toString().padLeft(2, '0')}/'
        '${birthday!.year}';
  }

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] as int?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      birthday: json['birthday'] != null
          ? DateTime.parse(json['birthday'])
          : null,
      gender: json['gender'] as String?,
      address: json['address'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }
}
