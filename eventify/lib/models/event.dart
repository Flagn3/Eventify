
class Event{
  int id;
  int? organizerId;

  int? categoryId;        // 👈 for backend
  String category;       // 👈 for UI

  String title;
  String? description;
  DateTime startTime;
  DateTime endTime;
  String location;
  int? latitude;
  int? longitude;
  int? maxAttendees;
  int? price;
  String imageUrl;
  int? deleted;

  Event({
    required this.id,
    this.organizerId,
    this.categoryId,
    required this.category,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    required this.imageUrl,
    required this.location,
    this.latitude,
    this.longitude,
    this.maxAttendees,
    this.price,
    this.deleted,
  });

factory Event.fromEventsJson(Map<String, dynamic> json) => Event(
  id: json['id'] ?? 0,
  title: json['title'] ?? '',
  description: json['description'],              // nullable
  organizerId: json['organizer_id'],
  categoryId: json['category_id'],              // nullable
  category: json['category'] ?? json['category_name'] ?? '',
  startTime: DateTime.parse(json['start_time'] ?? DateTime.now().toIso8601String()),
  endTime: DateTime.parse(json['end_time'] ?? DateTime.now().toIso8601String()),
  imageUrl: json['image_url'] ?? '',
  location: json['location'] ?? '',
  latitude: json['latitude'],
  longitude: json['longitude'],
  price: json['price'] ?? 0,
  deleted: json['deleted'] ?? 0,
  maxAttendees: json['max_attendees'],
);

}

