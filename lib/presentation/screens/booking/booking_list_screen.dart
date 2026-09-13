import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:restaurant_app/core/constants/app_theme.dart';
import 'package:restaurant_app/domain/entities/booking.dart';
import 'package:restaurant_app/domain/entities/restaurant.dart';
import 'package:restaurant_app/presentation/providers/booking_provider.dart';
import 'package:restaurant_app/presentation/providers/restaurant_provider.dart';
import 'package:restaurant_app/presentation/screens/home/main_screen.dart';

class BookingListScreen extends StatefulWidget {
  const BookingListScreen({super.key});

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    Future.microtask(() {
      context.read<BookingProvider>().getBookings();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Booking History",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Consumer<BookingProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage.isNotEmpty) {
            return Center(
              child: Text(
                provider.errorMessage,
                style: TextStyle(color: AppTheme.error),
              ),
            );
          }

          if (provider.bookings.isEmpty) {
            return const Center(child: Text("No booking found"));
          }

          return SmartRefresher(
            controller: _refreshController,
            onRefresh: () async {
              await context.read<BookingProvider>().getBookings();
            },
            child: ListView.builder(
              itemCount: provider.bookings.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final booking = provider.bookings[index];

                try {
                  final restaurantId = int.tryParse(booking.restaurantId) ?? 0;
                  if (restaurantId > 0) {
                    Future.microtask(() {
                      context.read<RestaurantProvider>().getAllRestaurants();
                    });
                  }
                } catch (e) {
                  print('Error parsing restaurant ID : $e');
                }

                return Consumer<RestaurantProvider>(
                  builder: (context, restoProvider, _) {
                    final restaurant = restoProvider.restaurants.firstWhere(
                      (element) =>
                          element.id == int.parse(booking.restaurantId),
                    );

                    return Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          imageResto(restaurant),
                          const SizedBox(width: 16),
                          restoDetail(restaurant, booking),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: Container(
        width: 180,
        height: 45,
        margin: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          },
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          elevation: 1.4,
          
          icon:  Icon(Icons.add, color: AppTheme.primayColor),
          label:  Text(
            "Booking more",
            style: TextStyle(color: AppTheme.primayColor),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Container timeBadge(Booking booking) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primayColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        DateFormat('HH:mm').format(booking.dateTime),
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Expanded restoDetail(Restaurant? restaurant, Booking booking) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            restaurant?.name ?? '-',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: AppTheme.primayColor),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  restaurant != null
                      ? '${restaurant.address}, ${restaurant.city}'
                      : 'Location',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                DateFormat('dd MMM yyyy').format(booking.dateTime),
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(width: 10),
              Expanded(child: timeBadge(booking))
            ],
          ),
        ],
      ),
    );
  }

  ClipRRect imageResto(Restaurant? restaurant) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        restaurant?.image ?? '',
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.restaurant, size: 100, color: Colors.grey);
        },
      ),
    );
  }
}
