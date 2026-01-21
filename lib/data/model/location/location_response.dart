class LocationResponse {
  String? districtName;
  String? provinceName; // province: renamed to provinceName

  LocationResponse({this.districtName, this.provinceName});

  factory LocationResponse.fromJson(Map<String, dynamic> json) {
    return LocationResponse(
      districtName: json['districtName'] as String?,
      provinceName: json['provinceName'] as String?, // province renamed to city
    );
  }
}
