import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_booking_app/config/app_config.dart';
import 'package:hotel_booking_app/data/model/api_response.dart';
import 'package:hotel_booking_app/data/model/review/review_summary.dart';
import 'package:hotel_booking_app/data/repositories/review_repository.dart';
import 'package:hotel_booking_app/data/service/review_service.dart';
import 'package:intl/intl.dart';

class ReviewDetailScreen extends StatefulWidget {
  final int roomTypeId;

  const ReviewDetailScreen({Key? key, required this.roomTypeId})
    : super(key: key);

  @override
  State<ReviewDetailScreen> createState() => _ReviewDetailScreenState();
}

class _ReviewDetailScreenState extends State<ReviewDetailScreen> {
  late Future<ApiResponse<List<ReviewSummary>>> _reviewsFuture;
  final ReviewRepository _reviewRepository = ReviewRepository(
    reviewService: ReviewService(),
  );
  late ScrollController _scrollController;
  int _currentPage = 0;
  List<ReviewSummary> _allReviews = [];
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _loadReviews();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.8 &&
        !_isLoadingMore) {
      _loadMoreReviews();
    }
  }

  void _loadReviews() {
    _reviewsFuture = _reviewRepository.fetchReviews(
      roomType: widget.roomTypeId,
      page: _currentPage,
      size: 10,
    );
  }

  Future<void> _loadMoreReviews() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final response = await _reviewRepository.fetchReviews(
        roomType: widget.roomTypeId,
        page: _currentPage + 1,
        size: 10,
      );

      if (response.data != null && response.data!.isNotEmpty) {
        setState(() {
          _currentPage++;
          _allReviews.addAll(response.data!);
          _isLoadingMore = false;
        });
      } else {
        setState(() {
          _isLoadingMore = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Hết nhận xét rồi')));
        }
      }
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: const Text(
          "Tất Cả Nhận Xét",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: FutureBuilder<ApiResponse<List<ReviewSummary>>>(
        future: _reviewsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              _allReviews.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data?.data != null) {
            if (_allReviews.isEmpty) {
              _allReviews = snapshot.data!.data!;
            }

            if (_allReviews.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.rate_review_outlined,
                      size: 80,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Chưa có nhận xét nào',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              controller: _scrollController,
              itemCount: _allReviews.length + (_isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _allReviews.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blueAccent,
                        ),
                      ),
                    ),
                  );
                }

                final review = _allReviews[index];
                return _buildReviewCard(review);
              },
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Không có dữ liệu',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildReviewCard(ReviewSummary review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage:
                    review.userImage != null && review.userImage!.isNotEmpty
                    ? NetworkImage(
                        '${AppConfig.baseUrl}images/${review.userImage}',
                      )
                    : null,
                radius: 24,
                backgroundColor: Colors.grey[300],
                child: review.userImage == null || review.userImage!.isEmpty
                    ? const Icon(Icons.person, color: Colors.grey)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userFullName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy').format(review.createdAt),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      '${review.rating}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.comment,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
