class FriendModel {
  String id;          // unique id from server
  String name;
  String imageUrl;
  bool isVerified;
  bool isFriend;

  FriendModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.isVerified = false,
    this.isFriend = false,
  });

  // ✅ fromJson helper
  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['fullName'] ?? 'Unknown',
      imageUrl: json['avatar'] ?? '', 
      isVerified: json['premium'] ?? false,
      isFriend: json['isFriend'] ?? false,
    );
  }

  // Optional: toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': imageUrl,
      'isVerified': isVerified,
      'isFriend': isFriend,
    };
  }
}
