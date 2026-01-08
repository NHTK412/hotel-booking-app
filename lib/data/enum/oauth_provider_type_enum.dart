enum OauthProviderTypeEnum {
  google, // đăng nhập bằng tài khoản Google
  facebook, // đăng nhập bằng tài khoản Facebook
  github; // đăng nhập bằng tài khoản GitHub

  String toJson() => name.toUpperCase();
}
