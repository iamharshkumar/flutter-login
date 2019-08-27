class LoginModel {
  String username;
  String password;

  LoginModel.fromJson(parsedJson){
    username = parsedJson['username'];
    password = parsedJson['password'];
  }
}