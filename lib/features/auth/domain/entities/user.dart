import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String firstName;
  final String lastName;
  final String? middleName;

  const User({
    required this.firstName,
    required this.lastName,
    this.middleName,
  });

  @override
  List<Object?> get props => [firstName, lastName, middleName];
}
