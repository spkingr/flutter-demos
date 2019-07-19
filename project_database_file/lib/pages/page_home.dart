import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../navigation.dart';
import 'page_books.dart';
import 'dart:async';
import '../database/data_class.dart';
import '../configurations.dart';
import '../database/database_helper.dart';

class HomePage extends StatefulWidget{
  static const PAGE_NAME = "/";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  Future<SharedPreferences> _preferences = SharedPreferences.getInstance();

  final _keyGlobal = GlobalKey<ScaffoldState>();
  final _keyLoginForm = GlobalKey<FormState>();
  final _keyRegisterForm = GlobalKey<FormState>();

  /// 1. username = null, creationTime = null, first login, or register
  /// 2. username != null, creationTime != null, but expired = true, login
  /// 3. username != null, creationTime != null, not expired, go to main page
  /// 4. login page to register page
  final _user = User.fromEmpty();
  bool _isLoginOrRegister;

  var _isAutoValidate = false;
  var _isPasswordObscure = true;

  @override
  void initState() {
    super.initState();

    this._preferences.then((data){
      var username = data.getString(UserNameKey);
      var lastLoginTime = data.getString(LastLoginTimeKey);

      if(username == null || lastLoginTime == null){
        Future.delayed(const Duration(seconds: 3)).then((_) => this.setState(() => this._isLoginOrRegister = true));
      }else{
        var date = DateTime.parse(lastLoginTime);
        var days = DateTime.now().difference(date).inDays;
        if(days > ExpiredDaysDuration - 8){
          this._user.userName = username;
          Future.delayed(const Duration(seconds: 3)).then((_) => this.setState(() => this._isLoginOrRegister = true));
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
  Widget build(BuildContext context) => Scaffold(
    key: this._keyGlobal,
    appBar: this._isLoginOrRegister == null ? null : (AppBar(title: Text(this._isLoginOrRegister ? "Login" : "Register"))),
    body: this._isLoginOrRegister == null ? Center(child: CircularProgressIndicator()) : SafeArea(
      top: false,
      bottom: false,
      child: Center(
        child: Form(
          key: this._isLoginOrRegister ? this._keyLoginForm : this._keyRegisterForm,
          autovalidate: this._isAutoValidate,
          onWillPop: this._onLeaveWithoutSave,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: this._isLoginOrRegister ? this._buildLoginTextFields() : this._buildRegisterTextFields(),
            ),
          ),
        ),
      ),
    ),
  );

  _buildLoginTextFields() => <Widget>[
    TextFormField(
      initialValue: this._user.email,
      autovalidate: this._isAutoValidate,
      onSaved: (text) => this._user.email = text,
      validator: this._validateEmail,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Your email",
        labelText: "Email",
      ),
    ),

    const SizedBox(height: 10.0,),
    TextFormField(
      initialValue: this._user.password,
      obscureText: this._isPasswordObscure,
      autovalidate: this._isAutoValidate,
      onSaved: (text) => this._user.password = text,
      validator: this._validatePassword,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Your password",
        labelText: "Password",
        suffixIcon: GestureDetector(
          onTap: () => this.setState(() => this._isPasswordObscure = !this._isPasswordObscure),
          child: Icon(this._isPasswordObscure ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    ),

    const SizedBox(height: 10.0,),
    Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        OutlineButton(child: const Text("Register"), color: Colors.green.shade200, textColor: Colors.green, onPressed: this._onRegister,),
        OutlineButton(child: const Text("Login"), color: Colors.orange, textColor: Colors.orange, onPressed: this._onSubmit,),
      ],
    ),
  ];

  _buildRegisterTextFields() => <Widget>[
    TextFormField(
      initialValue: this._user.userName,
      autovalidate: this._isAutoValidate,
      onSaved: (text) => this._user.userName = text,
      validator: this._validateUsername,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Username",
        labelText: "Your label name",
        helperText: "* requeired",
      ),
    ),

    const SizedBox(height: 10.0,),
    TextFormField(
      initialValue: this._user.email,
      autovalidate: this._isAutoValidate,
      onSaved: (text) => this._user.email = text,
      validator: this._validateEmail,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Email",
        labelText: "Your email",
        helperText: "* requeired",
      ),
    ),

    const SizedBox(height: 10.0,),
    TextFormField(
      initialValue: this._user.password,
      obscureText: this._isPasswordObscure,
      autovalidate: this._isAutoValidate,
      onSaved: (text) => this._user.password = text,
      validator: this._validatePassword,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Password",
        helperText: "* requeired and lenght >= 6",
        suffixIcon: GestureDetector(
          onTap: () => this.setState(() => this._isPasswordObscure = !this._isPasswordObscure),
          child: Icon(this._isPasswordObscure ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    ),

    const SizedBox(height: 10.0,),
    TextFormField(
      initialValue: this._user.information,
      maxLines: 4,
      onSaved: (text) => this._user.information = text,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Information",
        helperText: "Tell somthing about you.",
      ),
    ),

    const SizedBox(height: 10.0,),
    Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        OutlineButton(child: const Text("Cancel"), color: Colors.grey.shade400, textColor: Colors.grey, onPressed: this._onCancelRegister,),
        OutlineButton(child: const Text("Submit"), color: Colors.blue.shade300, textColor: Colors.green, onPressed: this._onSubmit,),
      ],
    ),
  ];

  Future<bool> _onLeaveWithoutSave() async{
    if(this._keyLoginForm.currentState == null && this._isLoginOrRegister){
      return true;
    }else if(this._keyRegisterForm.currentState == null && ! this._isLoginOrRegister){
      this.setState(() => this._isLoginOrRegister = true);
    }

    final dialog = showDialog<bool>(
      context: this.context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Warning"),
        content: const Text("Leave without saving, are you sure?"),
        actions: <Widget>[
          FlatButton(onPressed: () => this._leaveWithLoginPage(), child: const Text("Give Up"),),
          FlatButton(onPressed: () => Navigator.of(this.context).pop(false), child: const Text("Stay Here"),),
        ],
      ),
    );
    return dialog ?? false;
  }

  _leaveWithLoginPage() {
    if(! this._isLoginOrRegister){
      this.setState(() => this._isLoginOrRegister = true);
    }
    Navigator.of(this.context).pop(false);
  }

  _onRegister(){
    this._closeKeyboard();

    this.setState(() => this._isLoginOrRegister = false);
  }

  _onCancelRegister() {
    this._closeKeyboard();

    this.setState(() => this._isLoginOrRegister = true);
  }

  _onSubmit() async{
    this._closeKeyboard();

    final formState = this._isLoginOrRegister ? this._keyLoginForm.currentState : this._keyRegisterForm.currentState;
    if(formState.validate()){
      formState.save();

      final database = DatabaseHelper();
      await database.createAndOpenDatabase();
      if(this._isLoginOrRegister){
        final user = await database.selectUser(this._user.email, this._user.password);
        if(user == null){
          this._showErrorDialog();
        }else{
          Navigation.navigateTo(this.context, BooksPage.PAGE_NAME, replace: true);
        }
      }else{
        final id = await database.register(userName: this._user.userName, password: this._user.password, email: this._user.email, information: this._user.information);

        final loginTime = DateTime.now().toIso8601String();
        this._preferences.then((preferences){
          preferences.setString(UserNameKey, this._user.userName);
          preferences.setString(LastLoginTimeKey, loginTime);
        });

        Navigation.navigateTo(this.context, BooksPage.PAGE_NAME, replace: true);
      }
    }else{
      this._isAutoValidate = true;
      this._keyGlobal.currentState.showSnackBar(SnackBar(content: const Text("Please fix all the errors before submit."),));
    }
  }

  _showErrorDialog(){
    showDialog(
        context: this.context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Error"),
          content: const Text("Email or password is incorrect or not exsited!"),
          actions: <Widget>[OutlineButton(child: const Text("Done"), color: Colors.red, textColor: Colors.green, onPressed: () => Navigator.of(context).pop(),),],)
    );
  }

  String _validateEmail(String text) {
    if(text.isEmpty){
      return "Email should not be empty!";
    }
    final reg = RegExp(r'^[A_Za-z._0-9]+@[A_Za-z._0-9]+\.[A_Za-z._0-9]+$');
    if(! reg.hasMatch(text)){
      return "Invalidate email address!";
    }
    return null;
  }

  String _validateUsername(String text) {
    if(text.isEmpty){
      return "User name should not be empty!";
    }
    final reg = RegExp(r'^[A-Za-z ]+\d*$');
    if(! reg.hasMatch(text)){
      return "Invalidate user name!";
    }
    return null;
  }

  String _validatePassword(String text) {
    if(text.isEmpty){
      return "Password should not be empty!";
    }
    if(text.length < 6){
      return "Password is too short!";
    }
    return null;
  }

  _closeKeyboard() => FocusScope.of(this.context).requestFocus(FocusNode());
}