class User {
  const User(
      {required this.id,
      required this.name,
      required this.email,
      this.emailVerifiedAt,
      this.job,
      required this.password,
      this.token});

  final int id;
  final String name;
  final String email;
  final DateTime? emailVerifiedAt;
  final String password;
  final String? job;
  final String? token;
}
