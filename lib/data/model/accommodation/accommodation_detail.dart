// private Long accommodationId;
// private String accommodationName;
// private String description;
// private String address;
// private String city;
// private Double latitude;
// private Double longitude;
// private AccommodationTypeEnum type;
// private List<RoomTypeSummaryDTO> roomTypes;
// private Double starRating;

import 'package:hotel_booking_app/data/model/roomtype/room_type_summary.dart';

class AccommodationDetail {
  final int? accommodationId;
  final String? accommodationName;
  final String? description;
  final String? address;
  final String? city;
  final double? latitude;
  final double? longitude;
  final String? type;
  final List<RoomTypeSummary>? roomTypes;
  final double? starRating;
  final String? image;
  final bool? isFavorite;

  AccommodationDetail({
    required this.accommodationId,
    required this.accommodationName,
    required this.description,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.roomTypes,
    required this.starRating,
    required this.image,
    required this.isFavorite,
  });

  factory AccommodationDetail.fromJson(Map<String, dynamic> json) {
    List<dynamic> roomTypesDynamic = json['roomTypes'] as List<dynamic>;
    List<RoomTypeSummary>? roomTypes = roomTypesDynamic.map((roomTypeDynamic) {
      return RoomTypeSummary.fromJson(roomTypeDynamic as Map<String, dynamic>);
    }).toList();

    return AccommodationDetail(
      accommodationId: json['accommodationId'] as int?,
      accommodationName: json['accommodationName'] as String?,
      description: json['description'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      type: json['type'] as String?,
      roomTypes: roomTypes,
      starRating: json['starRating'] as double?,
      image: json['image'] as String?,
      isFavorite: json['isFavorite'] as bool?,
    );
  }

  @override
  String toString() {
    return 'AccommodationDetail{accommodationId: $accommodationId, accommodationName: $accommodationName, description: $description, address: $address, city: $city, latitude: $latitude, longitude: $longitude, type: $type, roomTypes: $roomTypes, starRating: $starRating} , image: $image}';
  }
}
