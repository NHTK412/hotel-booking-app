import 'package:flutter/material.dart';
import 'package:hotel_booking_app/config/appConfig.dart';
import 'package:hotel_booking_app/data/enum/amenityEnum.dart';
import 'package:hotel_booking_app/data/model/apiResponse.dart';
import 'package:hotel_booking_app/data/model/roomtype/roomTypeDetail.dart';
import 'package:hotel_booking_app/data/repositories/RoomTypeRepository.dart';
import 'package:hotel_booking_app/data/service/roomTypeService.dart';
import 'package:hotel_booking_app/screens/bookUI.dart';
import 'package:readmore/readmore.dart';

class DetailCart extends StatefulWidget {
  final int roomTypeId;

  const DetailCart({Key? key, required this.roomTypeId}) : super(key: key);

  @override
  _DetailCartState createState() => _DetailCartState();
}

class _DetailCartState extends State<DetailCart> {
  String? _error;
  bool _isLoading = false;
  RoomTypeDetail? _roomTypeDetail;

  final RoomTypeRepository _roomTypeRepository = RoomTypeRepository(
    RoomTypeService(),
  );

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      setState(() => _isLoading = true);
      final ApiResponse<RoomTypeDetail> result = await _roomTypeRepository
          .getRoomTypeById(widget.roomTypeId);
      _roomTypeDetail = result.data;
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: (_isLoading)
            ? const Center(child: CircularProgressIndicator())
            : (_error != null)
            ? Center(child: Text("Lỗi: $_error"))
            : _createBody(_roomTypeDetail),
      ),
      bottomNavigationBar: _roomTypeDetail != null
          ? Padding(
              padding: EdgeInsets.all(20.0),
              child: BookingButton(
                roomTypeId: widget.roomTypeId,
                price: _roomTypeDetail!.price!,
                // accommodationName: _roomTypeDetail!.accommodationName!,
                accommodationName: "Demo Accommodation",
                roomTypeName: _roomTypeDetail!.name!,
              ),
            )
          : null,
    );
  }

  Widget _createBody(RoomTypeDetail? roomTypeDetail) {
    if (roomTypeDetail == null) return const SizedBox();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DetailHeader(),
          const SizedBox(height: 20),
          _createImageBanner(roomTypeDetail.image ?? ""),
          const SizedBox(height: 25),
          _createDetailTitle(
            title: roomTypeDetail.name ?? "N/A",
            location: roomTypeDetail.localtion ?? "Unknown",
            price: roomTypeDetail.getMinPricePerNightToString(),
            star: roomTypeDetail.star ?? 0,
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 10),
          const Text(
            "Tiện ích",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _createCategory(
            roomTypeDetail.amenities ?? [],
            roomTypeDetail.star ?? 0,
          ),
          const SizedBox(height: 25),
          const DetailDescription(),
          const SizedBox(height: 25),
          const DetailPreview(),
          const SizedBox(height: 25),

          // --- PHẦN NHẬN XÉT (REVIEWS) ---
          const Text(
            "Nhận xét từ khách hàng",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          _buildReviewItem(
            name: "Nguyễn Văn A",
            avatarUrl: "https://ui-avatars.com/api/?name=A&background=random",
            rating: 5,
            comment:
                "Phòng rất sạch sẽ và đầy đủ tiện nghi. Nhân viên phục vụ nhiệt tình, vị trí thuận lợi cho việc di chuyển.",
            date: "12/10/2025",
          ),
          _buildReviewItem(
            name: "Trần Thị B",
            avatarUrl: "https://ui-avatars.com/api/?name=B&background=random",
            rating: 4,
            comment: "View rất đẹp, đồ ăn sáng ngon. Sẽ quay lại lần sau.",
            date: "05/10/2025",
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _createDetailTitle({
    required String title,
    required String location,
    required String price,
    required int star,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < star ? Icons.star : Icons.star_border,
                        color: Colors.orange,
                        size: 18,
                      );
                    }),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "$price VNĐ",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF64BCE3),
                  ),
                ),
                const Text(
                  "mỗi đêm",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(
              Icons.location_on_rounded,
              color: Colors.redAccent,
              size: 18,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                location,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _createImageBanner(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        "${AppConfig.baseUrl}images/$imageUrl",
        fit: BoxFit.cover,
        height: 250,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 250,
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, size: 50),
        ),
      ),
    );
  }

  Widget _createCategory(List<AmenityEnum> amenities, int star) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: amenities
          .map(
            (item) =>
                _buildAmenityChip(item.iconData, item.amenityName, Colors.blue),
          )
          .toList(),
    );
  }

  Widget _buildAmenityChip(IconData icon, String label, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị từng dòng nhận xét
  Widget _buildReviewItem({
    required String name,
    required String avatarUrl,
    required int rating,
    required String comment,
    required String date,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(avatarUrl),
                radius: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      date,
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    Icons.star,
                    size: 14,
                    color: index < rating ? Colors.orange : Colors.grey[300],
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            comment,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// --- CÁC COMPONENT HỖ TRỢ ---

class DetailHeader extends StatelessWidget {
  const DetailHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildIconBox(
          context,
          Icons.arrow_back_ios_new,
          () => Navigator.pop(context),
        ),
        const Text(
          "Chi Tiết Phòng",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // _buildIconBox(context, Icons.favorite_border, () {}),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget _buildIconBox(
    BuildContext context,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, size: 18, color: Colors.black),
      ),
    );
  }
}

class DetailDescription extends StatelessWidget {
  const DetailDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Mô tả",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        ReadMoreText(
          "Khách sạn cung cấp không gian sang trọng với thiết kế hiện đại, đầy đủ tiện nghi cao cấp. Tọa lạc tại vị trí đắc địa, giúp quý khách dễ dàng di chuyển đến các địa điểm tham quan nổi tiếng. Dịch vụ tận tâm, chuyên nghiệp chắc chắn sẽ làm hài lòng quý khách trong suốt kỳ nghỉ.",
          textAlign: TextAlign.justify,
          trimMode: TrimMode.Line,
          trimLines: 3,
          colorClickableText: Colors.blue,
          trimCollapsedText: ' Xem thêm',
          trimExpandedText: ' Rút gọn',
          style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
        ),
      ],
    );
  }
}

class DetailPreview extends StatelessWidget {
  const DetailPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Hình ảnh xem trước",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  "https://picsum.photos/200/300?random=$index",
                  width: 130,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BookingButton extends StatelessWidget {
  final int roomTypeId;
  final double price;

  final String accommodationName;
  final String roomTypeName;

  const BookingButton({
    Key? key,
    required this.roomTypeId,
    required this.price,
    required this.accommodationName,
    required this.roomTypeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookUi(
                roomTypeId: roomTypeId,
                price: price,
                accommodationName: accommodationName,
                roomTypeName: roomTypeName,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: const Color(0xFF64BCE3),
          elevation: 0,
        ),
        child: const Text(
          "Đặt Phòng Ngay",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
