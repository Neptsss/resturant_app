import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/core/constants/app_theme.dart';
import 'package:restaurant_app/domain/entities/restaurant.dart';
import 'package:restaurant_app/presentation/providers/restaurant_provider.dart';
import 'package:restaurant_app/presentation/screens/resto/booking_screen.dart';
import 'package:restaurant_app/presentation/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DetailRestoScreen extends StatefulWidget {
  final int id;
  const DetailRestoScreen({super.key, required this.id});

  @override
  State<DetailRestoScreen> createState() => _DetailRestoScreenState();
}

class _DetailRestoScreenState extends State<DetailRestoScreen> {
  @override
  void initState() {
    Future.microtask(() {
      Provider.of<RestaurantProvider>(
        context,
        listen: false,
      ).getRestaurantById(widget.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Details Restaurant',
          style: TextStyle(
            color: AppTheme.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<RestaurantProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage.isNotEmpty) {
            return Center(
              child: Text(
                provider.errorMessage,
                style: TextStyle(color: AppTheme.error),
              ),
            );
          }

          final restaurant = provider.selectedRestaurant;

          if (restaurant == null) {
            return const Center(child: Text("Restaurant not found"));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      _buildRestaurantHeader(restaurant),
                      _buildRestaurantImage(restaurant),
                      _buildScheduleAndVisit(restaurant),
                      _buildMap(restaurant),
                    ],
                  ),
                ),
                _buildMenuList(restaurant),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
      bottomSheet: _buildBookingButton(),
    );
  }

  Widget _buildRestaurantHeader(Restaurant restaurant) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Text(
            restaurant.name,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, size: 20, color: AppTheme.primayColor),
              const SizedBox(width: 4),
              Text(
                '${restaurant.address} ${restaurant.city}',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantImage(Restaurant restaurant) {
    return Container(
      width: double.infinity,
      height: 200,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          restaurant.image,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stactTrace) {
            return Container(
              color: Colors.grey[300],
              child: const Center(
                child: Icon(Icons.restaurant, size: 64, color: Colors.grey),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildScheduleAndVisit(Restaurant restaurant) {
    final now = DateTime.now();
    final currentDay = _getCurrentDay(now.weekday);

    OpeningHour? todaySchedule;
    if (restaurant.openingHours.isNotEmpty) {
      try {
        todaySchedule = restaurant.openingHours.firstWhere(
          (hour) => hour.day.toLowerCase() == currentDay.toLowerCase(),
        );
      } catch (_) {
        todaySchedule = OpeningHour(day: currentDay, hours: 'Closed');
      }
    }

    return Container(
      color: AppTheme.white,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primayColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.access_time, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Open today",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                todaySchedule!.hours,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),

          const Spacer(),
          TextButton.icon(
            onPressed: () => _openMaps(restaurant),
            icon: const Icon(Icons.directions, color: Colors.blue),
            label: const Text(
              'Visit Resto',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap(Restaurant restaurant) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      height: 200,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(restaurant.latitude, restaurant.longtitude),
            initialZoom: 15,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.resto_book',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(restaurant.latitude, restaurant.longtitude),
                  width: 80,
                  height: 80,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 50,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuList(Restaurant restaurant) {
    return Container(
                margin: const EdgeInsets.symmetric(vertical: 10),

      padding: const EdgeInsets.all( 16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
             crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Menu on this restaurant',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Check the menu at this restaurant',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            itemCount: restaurant.menu.length,
            itemBuilder: (context, index) {
              final menuItem = restaurant.menu[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.grey.withValues(alpha: 0.5),
                      blurRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        menuItem.image,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80,
                            height: 80,
                            color: AppTheme.lightGrey,
                            child: Icon(
                              Icons.restaurant_menu,
                              color: AppTheme.grey,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            menuItem.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            menuItem.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.grey,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBookingButton() {
    return Consumer<RestaurantProvider>(
      builder: (context, provider, _) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.5),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: CustomButton(
            text: 'Booking',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookingScreen()),
              );
            },
          ),
        );
      },
    );
  }

  String _getCurrentDay(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Monday';
    }
  }

  void _openMaps(Restaurant restaurant) {
    final googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=${restaurant.latitude},${restaurant.longtitude}';

    try {
      launchUrlString(googleMapsUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening maps : ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
