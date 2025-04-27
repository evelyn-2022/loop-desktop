class User {
  final int id;
  final String email;
  final String username;
  final bool admin;
  final String? profileUrl;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.admin,
    this.profileUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        email: json['email'],
        username: json['username'],
        admin: json['admin'],
        profileUrl: json['profileUrl'],
      );

  factory User.empty() => User(
        id: -1,
        email: '',
        username: '',
        admin: false,
        profileUrl: null,
      );
}
