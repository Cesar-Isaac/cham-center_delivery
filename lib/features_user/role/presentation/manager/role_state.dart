import 'package:equatable/equatable.dart';

enum UserRole {
  none,
  customer,
  driver,
}

class RoleState extends Equatable {
  final UserRole selectedRole;

  const RoleState({
    this.selectedRole = UserRole.none,
  });

  RoleState copyWith({
    UserRole? selectedRole,
  }) {
    return RoleState(
      selectedRole: selectedRole ?? this.selectedRole,
    );
  }

  @override
  List<Object?> get props => [
    selectedRole,
  ];
}