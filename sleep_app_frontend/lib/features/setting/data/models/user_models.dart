class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String sex;
  final String dateOfBirth;
  final String phoneNumber;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.sex,
    required this.dateOfBirth,
    required this.phoneNumber,
  });

  // Hàm chuyển đổi từ JSON/Map (Supabase) sang Object UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      sex: json['sex'] ?? '',
      dateOfBirth: json['birth_day'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
    );
  }

  // Hàm chuyển đổi từ Object UserModel ngược lại JSON để insert/update nếu cần
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'sex': sex,
      'birth_day': dateOfBirth,
      'phone': phoneNumber,
    };
  }
}
