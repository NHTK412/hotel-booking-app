enum UserRoleEnum {
  roleAdmin('ROLE_ADMIN'),
  roleUser('ROLE_USER'),
  roleHost('ROLE_HOST');

  final String apiValue;

  const UserRoleEnum(this.apiValue);


  static UserRoleEnum fromJson(String value) {
    return UserRoleEnum.values.firstWhere(
      (e) => e.apiValue == value,
      orElse: () =>
          throw ArgumentError('Không tìm thấy role nào khớp với: $value'),
    );
  }
}
