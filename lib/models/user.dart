class User {
  final String firstName;
  final String lastName;
  final String phone;
  final String address;
  final String email;
  final String? password;
  final String? token;
  final String? profileImage;
  final DateTime? dateOfBirth;
  final String? gender;

  User({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
    required this.email,
    this.password,
    this.token,
    this.profileImage,
    this.dateOfBirth,
    this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'address': address,
      'email': email,
      if (token != null) 'token': token,
      if (profileImage != null) 'profileImage': profileImage,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth!.toIso8601String(),
      if (gender != null) 'gender': gender,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic> ? json['data'] : json;
    return User(
      firstName: data['first_name'] ?? '',
      lastName: data['last_name'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      email: data['email'] ?? '',
      password: data['password'],
      token: data['token'],
      profileImage: data['profileImage'],
      dateOfBirth: data['dateOfBirth'] != null
          ? DateTime.parse(data['dateOfBirth'])
          : null,
      gender: data['gender'],
    );
  }
}
