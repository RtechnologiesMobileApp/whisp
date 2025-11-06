class UserModel {
  final String? id;
  final String name;
  final String email;
  final String? profilePic;
  final String? dob;
   final String? gender;
   final String? token;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.profilePic,
    this.dob,
    this.gender = "Not Specified",
    this.token,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "profilePic": profilePic ?? "",
      "dob": dob ?? "",
      "gender": gender,
      "token": token,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['fullName'] ?? json["name"] ?? "",
      email: json["email"] ?? "",
      profilePic: json["profilePic"] ?? json["avatar"],
      dob: json["dob"] ?? json['dateOfBirth'],
      gender: json["gender"] ?? "Not specified",
    );
  }
    UserModel copyWith({
    String? name,
    String? email,
    String? profilePic,
    String? dob,
    String? gender,
    String? token,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      token: token ?? this.token,
    );
  }
}
