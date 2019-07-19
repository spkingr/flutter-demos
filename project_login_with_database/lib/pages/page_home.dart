import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'page_books.dart';
import '../navigation.dart';
import '../configurations.dart';
import '../database/data_class.dart';
import '../database/database_helper.dart';
import '../widgets/widget_login.dart';
import '../widgets/widget_register.dart';
import '../widgets/widget_loader.dart';
import '../widgets/widget_forgot.dart';

class HomePage extends StatefulWidget{
  static const PAGE_NAME = "/";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  final _preferences = SharedPreferences.getInstance();
  final _user = User.fromEmpty();
  final _database = DatabaseHelper();

  bool _isLoginOrRegister;
  bool _isUserForgot = false;

  @override
  void initState() {
    super.initState();

    this._preferences.then((data){
      var username = data.getString(UserNameKey);
      var email = data.getString(UserEmailKey);
      var lastLoginTime = data.getString(LastLoginTimeKey);

      if(username == null || email == null || lastLoginTime == null){
        Future.delayed(const Duration(seconds: 1)).then((_) => this.setState(() => this._isLoginOrRegister = true));
      }else{
        var date = DateTime.parse(lastLoginTime);
        var days = DateTime.now().difference(date).inDays;
        if(days >= ExpiredDaysDuration){
          this._user.userName = username;
          this._user.email = email;
          Future.delayed(const Duration(seconds: 1)).then((_) => this.setState(() => this._isLoginOrRegister = true));
        }else{
          Navigation.navigateTo(this.context, BooksPage.PAGE_NAME, replace: true);
        }
      }
    });
  }

  @override
  void deactivate() {
    this._isLoginOrRegister = true;
    super.deactivate();
  }

  @override
  Widget build(BuildContext context){
    if(this._isLoginOrRegister == null){
      return Material(color: Colors.white, child: SimpleLoader(),);
    }else if(this._isUserForgot){
      return ForgotWidget(onReturn: this._onReturn,);
    }else{
      return this._isLoginOrRegister ? LoginWidget(user: this._user, onLogin: this._onLogin, onRegister: this._onRegister, onForgot: this._onForgot)
          : RegisterWidget(onCancel: this._onCancel, onRegisterNew: this._onRegisterNew,);
    }
  }

  void _onLogin() async {
    final provider = await this._database.userProvider;
    final user = await provider.selectEmail(this._user.email);
    if(user == null){
      this._showErrorDialog(info: "Email is not existed, please retry or register as new.");
      return;
    }

    final password = this._encrypt(this._user.password);
    if(password != user.password){
      this._showErrorDialog(info: "Password is incorrect, please try agian.");
    }else{
      provider.close();

      Navigation.navigateTo(this.context, BooksPage.PAGE_NAME, replace: true);
    }
  }

  void _onRegister() => this.setState(() => this._isLoginOrRegister = false);

  void _onCancel() => this.setState(() => this._isLoginOrRegister = true);

  void _onForgot() => this.setState(() => this._isUserForgot = true);

  void _onReturn() => this.setState(() => this._isUserForgot = false);

  Future _onRegisterNew(User user) async {
    final provider = await this._database.userProvider;
    var isUsed = await provider.isEmailUsed(user.email);
    if(isUsed){
      this._showErrorDialog(info: "Email is used, please login or select another one.");
      return;
    }
    isUsed = await provider.isUserNameUsed(user.userName);
    if(isUsed){
      this._showErrorDialog(info: "User name is used, please login or select another one.");
      return;
    }

    user.creationTime = DateTime.now().toIso8601String();
    user.password = this._encrypt(user.password);
    final newUser = await provider.insert(user);
    if(newUser == null){
      this._showErrorDialog(info: "Register failed, plase try agian later.");
      return;
    }

    this._preferences.then((preferences){
      preferences.setString(UserNameKey, newUser.userName);
      preferences.setString(UserEmailKey, newUser.email);
      preferences.setString(LastLoginTimeKey, user.creationTime);
    });

    provider.close();
    Navigation.navigateTo(this.context, BooksPage.PAGE_NAME, replace: true);
  }

  String _encrypt(String password){
    final bytes = utf8.encode(password);
    return md5.convert(bytes).toString();
  }

  _showErrorDialog({String info = "Email or password is incorrect or not exsited!"}){
    showDialog(
        context: this.context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Error"),
          content: Text(info),
          actions: <Widget>[OutlineButton(child: const Text("Done"), color: Colors.red, textColor: Colors.green, onPressed: () => Navigator.of(context).pop(),),],)
    );
  }
}