class UserProfile {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? address;
  final String? avatarUrl;
  final String? gender;
  final DateTime? birthday;
  final String? status;
  final String? identityCard;
  final List<String>? roles;

  UserProfile({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.address,
    this.avatarUrl,
    this.gender,
    this.birthday,
    this.status,
    this.identityCard,
    this.roles,
  });
}
