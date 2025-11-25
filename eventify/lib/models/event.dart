import 'dart:ffi';

class Event{
  int id;
  int? organizerId;
  String title;
  String? description;
  String categoryId;
  DateTime startTime;
  DateTime endTime;
  String location;
  Float latitude;
  Float longitude;
  int? maxAttendees;
  Float? price;
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
    required this.categoryId,
    required this.location,
    required this.latitude,
    required this.longitude,
    this.maxAttendees,
    this.price,
    this.deleted
  });

  factory Event.fromEventsJson (Map<String, dynamic> json) => Event(
    id: json['id'],
    title: json['title'],
    startTime: json['start_time'],
    endTime: json['end_time'],
    imageUrl: json['image_url'],
    categoryId: json['category'],
    location: json['location'],
    latitude: json['latitude'],
    longitude: json['longitude']
    
  );

}

