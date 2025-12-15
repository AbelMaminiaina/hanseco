import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? phone;
  final String? avatar;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    this.name,
    this.phone,
    this.avatar,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, email, name, phone, avatar, createdAt];
}
