class Login {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String authToken;

  const Login({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.authToken,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      id: json['id'],
      username: json['username'],
      email: json['emailId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      authToken: json['authToken'],
    );
  }

  List<Object> get props => [
        id,
        username,
        email,
        firstName,
        lastName,
        authToken,
      ];
}
