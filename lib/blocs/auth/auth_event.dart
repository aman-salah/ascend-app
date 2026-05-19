abstract class AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  AuthLoginEvent({required this.email, required this.password});
}

class AuthSignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;

  AuthSignUpEvent({
    required this.email,
    required this.password,
    required this.name,
  });
}

class AuthLogoutEvent extends AuthEvent {}

class AuthCheckSessionEvent extends AuthEvent {}
