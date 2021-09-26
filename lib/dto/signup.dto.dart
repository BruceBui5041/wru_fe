class SignUpDto {
  SignUpDto(
      {required this.username,
      required this.password,
      required this.confirmPassword});

  final String username;
  final String password;
  final String confirmPassword;
}
