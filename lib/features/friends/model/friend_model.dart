class FriendModel {
  final String name;
  final String imageUrl;
  final bool isVerified;
  bool isFriend;

  FriendModel({
    required this.name,
    required this.imageUrl,
    this.isVerified = false,
    this.isFriend = false,
  });
}
