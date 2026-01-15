
class Event{
  int id;
  int? organizerId;
  String title;
  String? description;
  String category;
  DateTime startTime;
  DateTime endTime;
  String location;
  double? latitude;
  double? longitude;
  int? maxAttendees;
  double? price;
  String imageUrl;
  bool? deleted;


  Event({
    required this.id,
    this.organizerId,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    required this.imageUrl,
    required this.category,
    required this.location,
   this.latitude,
    this.longitude,
    this.maxAttendees,
    this.price,
    this.deleted
  });

  factory Event.fromEventsJson (Map<String, dynamic> json) => Event(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    organizerId: json['organizer_id'],
    startTime: DateTime.parse(json['start_time']),
    endTime: DateTime.parse(json['end_time']),
    imageUrl: json['image_url'],
    category: json['category'] ?? json['category_name'],
    location: json['location'],
    latitude: json['latitude'],
    longitude: json['longitude']
  );

}

