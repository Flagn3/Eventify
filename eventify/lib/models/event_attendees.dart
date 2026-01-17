class EventAttendees {
  int? id;
  int eventId;
  int userId;
  String? status;
  DateTime? registeredAt;
  bool? deleted;


  EventAttendees ({
    this.id,
    required this.eventId,
    required this.userId,
    this.status,
    this.registeredAt,
    this.deleted
  });

  factory EventAttendees.fromEventsAttendeesJson (Map<String, dynamic> json) => EventAttendees(
    eventId: json['event_id'],
    userId: json['user_id']
  );

}