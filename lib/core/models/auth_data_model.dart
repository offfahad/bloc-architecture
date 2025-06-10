import 'user_model.dart';
import 'token_model.dart';

class AuthDataModel {
  final UserModel user;
  final TokenModel? tokens;

  AuthDataModel({required this.user, this.tokens});

  factory AuthDataModel.fromJson(Map<String, dynamic> json) {
    return AuthDataModel(
      user: UserModel.fromJson(json['user']),
      tokens:
          json['tokens'] != null ? TokenModel.fromJson(json['tokens']) : null,
    );
  }
}
