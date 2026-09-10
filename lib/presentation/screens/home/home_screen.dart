import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/core/constants/app_theme.dart';
import 'package:restaurant_app/domain/entities/restaurant.dart';
import 'package:restaurant_app/presentation/providers/restaurant_provider.dart';
import 'package:restaurant_app/presentation/screens/resto/detail_resto_screen.dart';
import 'package:restaurant_app/presentation/widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _bannerController = PageController();
  int _currentBannerPage = 0;

  @override
  void initState() {
    Future.microtask(() {
      Provider.of<RestaurantProvider>(
        context,
        listen: false,
      ).getAllRestaurants();
      Provider.of<RestaurantProvider>(context, listen: false).getAllBanners();
    });
    super.initState();
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const Text(
                'Dashboard',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildBannerCarousel(),
              const SizedBox(height: 24),
              _buildRestaurantHeader(),
              const SizedBox(height: 8),
              _buildCityFilter(),
              const SizedBox(height: 16),
              _buildRestaurantList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerCarousel() {
    final banners = Provider.of<RestaurantProvider>(context).banners;

    return SizedBox(
      height: 180,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _bannerController,
              itemCount: banners.length,
              onPageChanged: (index) {
                setState(() {
                  _currentBannerPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      banners[index].image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              banners.length,
              (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentBannerPage == index
                      ? AppTheme.primayColor
                      : Colors.grey[300],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Restaurant",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
       
      ],
    );
  }

  Widget _buildRestaurantList() {
    return Consumer<RestaurantProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Expanded(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (provider.errorMessage.isNotEmpty) {
          return Expanded(
            child: Center(
              child: Text(
                provider.errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        List<Restaurant> filteredRestaurants = provider.restaurants;

        if (provider.searchQuery.isNotEmpty) {
          filteredRestaurants = filteredRestaurants
              .where(
                (restaurant) => restaurant.name.toLowerCase().contains(
                  provider.searchQuery.toLowerCase(),
                ),
              )
              .toList();
        }
        if (filteredRestaurants.isEmpty) {
          return const Expanded(
            child: Center(child: Text('No restaurants found')),
          );
        }

        return Expanded(
          child: ListView.builder(
            itemCount: filteredRestaurants.length,
            itemBuilder: (context, index) {
              final restaurant = filteredRestaurants[index];
              return _buildRestaurantTile(restaurant);
            },
          ),
        );
      },
    );
  }

  Widget _buildRestaurantTile(Restaurant restaurant) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
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

      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailRestoScreen(id: restaurant.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  restaurant.image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: AppTheme.lightGrey,
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 30,
                          color: AppTheme.darkGrey,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: AppTheme.primayColor,
                        ),
                        Expanded(
                          child: Text(
                            '${restaurant.address}, ${restaurant.city}',
                            style: const TextStyle(fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              CustomButton(
                text: "Check",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailRestoScreen(id: restaurant.id),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Consumer<RestaurantProvider>(
      builder: (context, provider, _) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.lightGrey.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextField(
            onChanged: (value) {
              provider.setSearchQuery(value);
            },
            decoration: const InputDecoration(
              hintText: 'search',
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCityFilter() {
    return Consumer<RestaurantProvider>(
      builder: (context, provider, _) {
        return Row(
          children: [
            Expanded(
              child: const Text(
                'Check menu at this restaurant',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                _showCityFilterDialog(context);
              },
              icon: const Icon(Icons.location_on_outlined, size: 16),
              label: Text(
                (provider.selectedCity.isEmpty) ? 'All' : provider.selectedCity,
                style: const TextStyle(fontSize: 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(color: Colors.grey[300]!),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () {
                provider.toggleSortType();
              },
              icon: Icon(
                provider.sortType == SortType.nameAsc
                    ? Icons.arrow_downward
                    : Icons.arrow_upward,
                size: 16,
              ),
              label: Text('Nama', style: TextStyle(fontSize: 14)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(color: Colors.grey[300]!),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCityFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CityFilterDialog(
          onCitySelected: (city) {
            if (city != null) {
              Provider.of<RestaurantProvider>(
                context,
                listen: false,
              ).getResturantsByCity(city);
            } else {
              Provider.of<RestaurantProvider>(
                context,
                listen: false,
              ).getAllRestaurants();
            }
            Navigator.pop(context);
          },
          selectedCity: Provider.of<RestaurantProvider>(
            context,
            listen: false,
          ).selectedCity,
        );
      },
    );
  }
}

class CityFilterDialog extends StatelessWidget {
  final Function(String?) onCitySelected;
  final String? selectedCity;

  const CityFilterDialog({
    super.key,
    required this.onCitySelected,
    this.selectedCity,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter by City'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCityTile(context, null, 'All Cities'),
            _buildCityTile(context, 'Jakarta', 'Jakarta'),
            _buildCityTile(context, 'Yogyakarta', 'Yogyakarta'),
            _buildCityTile(context, 'Bandung', 'Bandung'),
            _buildCityTile(context, 'Surabaya', 'Surabaya'),
            _buildCityTile(context, 'Bali', 'Bali'),
            _buildCityTile(context, 'Makassar', 'Makassar'),
            _buildCityTile(context, 'Medan', 'Medan'),
            _buildCityTile(context, 'Malang', 'Malang'),
          ],
        ),
      ),
    );
  }

  Widget _buildCityTile(BuildContext context, String? city, String label) {
    return ListTile(
      title: Text(label),
      onTap: () {
        onCitySelected(city);
      },
    );
  }
}
