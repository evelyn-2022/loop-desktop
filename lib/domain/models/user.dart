class User {
  final int id;
  final String email;
  final String username;
  final bool admin;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.admin,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        email: json['email'],
        username: json['username'],
        admin: json['admin'],
      );

  factory User.empty() => User(
        id: -1,
        email: '',
        username: '',
        admin: false,
      );
}
