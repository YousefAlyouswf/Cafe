class UserInfo {
  final String name;
  final String phone;
  final String password;
  final String id;
  final String booked;
  bool isFavorite;
  final List<int> reviewsCount;
  final List<int> starsAvrage;

  UserInfo({
    this.booked,
    this.name,
    this.phone,
    this.password,
    this.id,
    this.isFavorite = false,
    this.reviewsCount,
    this.starsAvrage,
  });


  
}
