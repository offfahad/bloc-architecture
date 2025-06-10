class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final String profilePicture;
  final bool isVerified;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.profilePicture,
    required this.isVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      mobile: json['mobile'],
      profilePicture: json['profilePicture'],
      isVerified: json['isVerified'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'mobile': mobile,
    'profilePicture': profilePicture,
    'isVerified': isVerified,
  };
}
