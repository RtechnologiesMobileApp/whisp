class UserModel {
  final String? id;
  final String name;
  final String email;
  final String? profilePic;
  final String? dob;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.profilePic,
    this.dob,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "profilePic": profilePic ?? "",
      "dob": dob ?? "",
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      profilePic: json["profilePic"],
      dob: json["dob"],
    );
  }
}
