class LocationResponse {
  int? locationId;
  String? districtName;
  String? provinceName; // province: renamed to provinceName

  LocationResponse({this.districtName, this.provinceName, this.locationId});

  factory LocationResponse.fromJson(Map<String, dynamic> json) {
    return LocationResponse(
      locationId: json['locationId'] as int?,
      districtName: json['districtName'] as String?,
      provinceName: json['provinceName'] as String?, // province renamed to city
    );
  }
}
