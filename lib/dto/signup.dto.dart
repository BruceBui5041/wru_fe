class SignUpDto {
  final String username;
  final String password;
  final String confirmPassword;

  SignUpDto(
      {required this.username,
      required this.password,
      required this.confirmPassword});
}
