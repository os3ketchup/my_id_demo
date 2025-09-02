import 'package:equatable/equatable.dart';
import 'package:my_id/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.firstName,
    required super.lastName,
    super.middleName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json['profile']['common_data']['first_name'].toString(),
      lastName: json['profile']['common_data']['last_name'].toString(),
      middleName: json['profile']['common_data']['middle_name'].toString(),
    );
  }
}
