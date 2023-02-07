class UserModel {
  final String id, name, password, phoneNumber, location;
  final List<int> ratings;
  final bool status;

  const UserModel({
    required this.id,
    required this.name,
    required this.password,
    required this.phoneNumber,
    required this.location,
    this.ratings = const [],
    this.status = true,
  });
  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        password = json['password'],
        phoneNumber = json['phoneNumber'],
        location = json['location'],
        ratings = json['Ratings'] != null ? List.from(json['Ratings']) : [],
        status = json['Status'];

  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
        'password': password,
        'phoneNumber': phoneNumber,
        'location': location,
        'Ratings': ratings,
        'Status': status,
      };
}
