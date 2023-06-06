class RegistrationRequest {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  RegistrationRequest(
      {required this.name,
      required this.email,
      required this.password,
      required this.confirmPassword});
}
