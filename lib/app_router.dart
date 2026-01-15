import 'package:go_router/go_router.dart';
import 'package:hotel_booking_app/app_state.dart';
import 'package:hotel_booking_app/screens/booking_screen.dart';
import 'package:hotel_booking_app/screens/calendar_detail_screen.dart';
import 'package:hotel_booking_app/screens/calendar_screen.dart';
import 'package:hotel_booking_app/screens/favorite_hotel_screen.dart';
import 'package:hotel_booking_app/screens/filter_hotel_screen.dart';
import 'package:hotel_booking_app/screens/home_screen.dart';
import 'package:hotel_booking_app/screens/hotel_list_screen.dart';
import 'package:hotel_booking_app/screens/locations_screen.dart';
import 'package:hotel_booking_app/screens/login_screen.dart';
import 'package:hotel_booking_app/screens/main_menu_screen.dart';
import 'package:hotel_booking_app/screens/otp_verification_screen.dart';
import 'package:hotel_booking_app/screens/payment_screen.dart';
import 'package:hotel_booking_app/screens/profile_screen.dart';
import 'package:hotel_booking_app/screens/register_screen.dart';
import 'package:hotel_booking_app/screens/room_detail_screen.dart';
import 'package:hotel_booking_app/screens/search_hotel_screen.dart';

class AppRouter {
  // final GoRouter router = GoRouter(initialLocation: '/', refreshListenable: ,routes: []);

  late final AppState appState;

  AppRouter({required this.appState});

  GoRouter get router => GoRouter(
    initialLocation: '/',
    refreshListenable: appState,
    routes: [
      // Login route (ngoài StatefulShellRoute)
      GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) {
          return const RegisterScreen();
        },
      ),
      GoRoute(
        path: "/password_reset",
        builder: (context, state) {
          final String email = state.uri.queryParameters['email'] ?? '';

          return OtpVerificationScreen(email: email); // Th
        },
      ),
      GoRoute(
        path: "/accommodation/:accommodationId",
        builder: (context, state) {
          final int accommodationId = int.parse(
            state.pathParameters['accommodationId']!,
          );

          return HotelListScreen(accommodationId: accommodationId);
        },
      ),

      GoRoute(
        path: "/room-type/:roomTypeId",
        builder: (context, state) {
          final int roomTypeId = int.parse(state.pathParameters['roomTypeId']!);

          return RoomDetailScreen(roomTypeId: roomTypeId);
        },
      ),

      GoRoute(
        path: "/filter",
        builder: (context, state) {
          return const FilterHotelScreen();
        },
      ),

      GoRoute(
        path: "/locations",
        builder: (context, state) {
          // return LocationsScreen();
          return const LocationsScreen();
        },
      ),

      GoRoute(
        path: "/search",
        builder: (context, state) {
          return const SearchHotelScreen();
        },
      ),

      GoRoute(
        path: "/payment",
        builder: (context, state) {
          // return PaymentScreen();
          final BookingParams params = state.extra as BookingParams;
          return PaymentScreen(bookingParams: params);
        },
      ),
      GoRoute(
        path: "/booking",
        builder: (context, state) {
          // return BookingScreen();
          // final BookingParams params = BookingParams.fromState(state);
          final BookingParams params = state.extra as BookingParams;
          return BookingScreen(
            // roomTypeId: params.roomTypeId,
            // originalPrice: params.originalPrice,
            // accommodationName: params.accommodationName,
            // roomTypeName: params.roomTypeName,
            bookingParams: params,
          );
        },
      ),

      GoRoute(
        path: "/calendar_detail",
        builder: (context, state) => CalendarDetailScreen(),
      ),

      // StatefulShellRoute cho bottom navigation
      // StatefulShellRoute.indexedStack(
      // Không dùng indexdStack
      ShellRoute(
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/calendar',
            builder: (context, state) => const CalendarScreen(),
          ),
          GoRoute(
            path: '/favorites',
            builder: (context, state) => const FavoriteHotelScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
        builder: (context, state, child) {
          // 'child' chính là nội dung của các Route con (Home, Calendar,...)
          return MainMenuScreen(child: child);
        },
      ),
    ],
    redirect: (context, state) {
      // if (!appState.initialized) return null;

      final bool isLoggedIn = appState.isLoggedIn;
      final String location = state.matchedLocation;

      // Nếu chưa login và không ở trang login -> redirect về login
      if (!isLoggedIn &&
          (location != '/' &&
              location != '/register' &&
              location != '/password_reset')) {
        return '/';
      }

      // Nếu đã login và đang ở trang login -> redirect về home
      if (isLoggedIn && location == '/') {
        return '/home';
      }

      // Không redirect
      return null;
    },
  );
}

class BookingParams {
  final int roomTypeId;
  final double originalPrice;
  final String accommodationName;
  final String roomTypeName;
  final String? customerName;
  final String? customerPhone;
  final String? customerEmail;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final String? checkInTime;
  final String? checkOutTime;

  BookingParams({
    required this.roomTypeId,
    required this.originalPrice,
    required this.accommodationName,
    required this.roomTypeName,
    this.customerName,
    this.customerPhone,
    this.customerEmail,
    this.checkInDate,
    this.checkOutDate,
    this.checkInTime,
    this.checkOutTime,
  });

  // Thay thế cho hàm updateCustomerInfo
  BookingParams copyWith({
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    String? checkInTime,
    String? checkOutTime,
  }) {
    return BookingParams(
      roomTypeId: roomTypeId,
      originalPrice: originalPrice,
      accommodationName: accommodationName,
      roomTypeName: roomTypeName,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
    );
  }

  factory BookingParams.fromState(GoRouterState state) {
    final qp = state.uri.queryParameters;

    if (state.extra is BookingParams) {
      return state.extra as BookingParams;
    }

    return BookingParams(
      roomTypeId: int.tryParse(qp['roomTypeId'] ?? '') ?? 0,
      originalPrice: double.tryParse(qp['originalPrice'] ?? '') ?? 0.0,
      accommodationName: qp['accommodationName'] ?? '',
      roomTypeName: qp['roomTypeName'] ?? '',
    );
  }
}
