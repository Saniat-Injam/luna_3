

import 'package:barbell/core/models/UserModel.dart';

class LoginResponseModel {
  String? message;
  String? accessMessage;
  String? approvalToken;
  String? refreshToken;
  UserModel? user;

  LoginResponseModel({
    this.message,
    this.accessMessage,
    this.approvalToken,
    this.refreshToken,
    this.user,
  });

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    accessMessage = json['access_Message'];
    approvalToken = json['approvalToken'];
    refreshToken = json['refreshToken'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
  }
}
