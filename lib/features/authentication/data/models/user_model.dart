class UserModel {
  final String id, name, password, phoneNumber, username, location;
  final double? rating;

  const UserModel({
    required this.id,
    required this.name,
    required this.password,
    required this.phoneNumber,
    required this.username,
    required this.location,
    this.rating,
  });
  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        password = json['password'],
        phoneNumber = json['phoneNumber'],
        username = json['username'],
        location = json['location'],
        rating = json['rating'];

  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
        'password': password,
        'phoneNumber': phoneNumber,
        'username': username,
        'location': location,
        'rating': rating,
      };
}
