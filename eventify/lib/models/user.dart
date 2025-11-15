class User {
  int id;
  String name;
  String? email;
  DateTime? emailVerifiedAt;
  String? password;
  String role;
  String? profilePicture;
  bool? actived;
  bool? emailConfirmed;
  bool deleted;
  String? rememberToken;

  User({
    required this.id,
    required this.name,
    this.email,
    this.emailVerifiedAt,
    this.password,
    required this.role,
    this.profilePicture,
    this.actived,
    this.emailConfirmed,
    required this.deleted,
    this.rememberToken,
  });

  factory User.fromLoginJson(Map<String, dynamic> json) => User(
    rememberToken: json['token'],
    id: json['id'],
    name: json['name'],
    role: json['role'],
    deleted: json['deleted'] == 1, //bool
  );

  factory User.fromUsersJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    role: json['role'],
    emailVerifiedAt: json['email_verified_at'] != null
        ? DateTime.parse(json['email_verified_at'])
        : null,
    actived: json['actived'] == 1, //bool
    deleted: json['deleted'] == 1, //bool
  );
}
