// {
//   "provider": "LOCAL",
//   "accessToken": "string",
//   "idToken": "string",
//   "name": "string"
// }

import 'package:hotel_booking_app/data/enum/oauth_provider_type_enum.dart';

class OAuthLogin {
  final OauthProviderTypeEnum provider;
  final String accessToken;
  final String idToken;
  final String name;

  OAuthLogin({
    required this.provider,
    required this.accessToken,
    required this.idToken,
    required this.name,
  });

  // factory OAuthLogin.fromJson(Map<String, dynamic> json) {
  //   return OAuthLogin(
  //     provider: OauthProviderTypeEnum.values.firstWhere(
  //       (e) => e.toJson() == json['provider'],
  //     ),
  //     accessToken: json['accessToken'],
  //     idToken: json['idToken'],
  //     name: json['name'],
  //   );
  // }

  Map<String, dynamic> toJson() {
    return {
      'provider': provider.toJson(),
      'accessToken': accessToken,
      'idToken': idToken,
      'name': name,
    };
  }
}
