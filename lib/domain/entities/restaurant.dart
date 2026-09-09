class Restaurant {
  final int id;
  final String name;
  final String image;
  final double latitude;
  final double longtitude;
  final String address;
  final String city;
  final String description;
  final List<OpeningHour> openingHours;
  final List<MenuItem> menu;

  Restaurant({
    required this.id,
    required this.name,
    required this.image,
    required this.latitude,
    required this.longtitude,
    required this.address,
    required this.city,
    required this.description,
    required this.openingHours,
    required this.menu,
  });
}

class OpeningHour {
  final String day;
  final String hours;
  OpeningHour({required this.day, required this.hours});
}

class MenuItem {
  final String name;
  final String image;
  final String description;

  MenuItem({
    required this.name,
    required this.image,
    required this.description,
  });
}
