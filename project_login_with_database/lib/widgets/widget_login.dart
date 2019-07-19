import 'dart:async';
import 'package:flutter/material.dart';
import '../database/data_class.dart';

class LoginWidget extends StatefulWidget{
  LoginWidget({this.user, this.onLogin, this.onRegister, this.onForgot});

  final User user;
  final VoidCallback onLogin;
  final VoidCallback onRegister;
  final VoidCallback onForgot;

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget>{
  final _keyGlobal = GlobalKey<ScaffoldState>();
  final _keyForm = GlobalKey<FormState>();

  var _isPasswordObscure = true;
  var _isAutoValidate = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    key: this._keyGlobal,
    body: SafeArea(
      top: false,
      bottom: false,
      child: Center(
        child: Form(
          key: this._keyForm,
          autovalidate: this._isAutoValidate,
          onWillPop: this._onLeaveWithoutSave,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: this._buildLoginTextFields(),
            ),
          ),
        ),
      ),
    ),
  );

  _buildLoginTextFields() => <Widget>[
    TextFormField(
      initialValue: this.widget.user.email,
      autovalidate: this._isAutoValidate,
      onSaved: (text) => this.widget.user.email = text,
      validator: this._validateEmail,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Email",
      ),
    ),

    const SizedBox(height: 10.0,),
    TextFormField(
      initialValue: this.widget.user.password,
      obscureText: this._isPasswordObscure,
      autovalidate: this._isAutoValidate,
      onSaved: (text) => this.widget.user.password = text,
      validator: this._validatePassword,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(child: OutlineButton(child: const Text("Forgot"), textColor: Colors.black38, onPressed: this._onForgot,)),
        Expanded(child: OutlineButton(child: const Text("Register"), textColor: Colors.green.shade200, onPressed: this._onRegister,)),
        Expanded(child: OutlineButton(child: const Text("Login"), textColor: Colors.orange, onPressed: this._onSubmit,)),
      ],
    ),
  ];

  Future<bool> _onLeaveWithoutSave() async{
    if(this._keyForm.currentState == null){
      return true;
    }
    final dialog = showDialog<bool>(
      context: this.context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Warning"),
        content: const Text("Leave without saving, are you sure?"),
        actions: <Widget>[
          FlatButton(onPressed: () => Navigator.of(this.context).pop(true), child: const Text("Give Up"),),
          FlatButton(onPressed: () => Navigator.of(this.context).pop(false), child: const Text("Stay Here"),),
        ],
      ),
    );
    return dialog ?? false;
  }

  _onSubmit() {
    this._closeKeyboard();

    final formState = this._keyForm.currentState;
    if(formState.validate()){
      formState.save();
      print("_______________________________________________${this.widget.user}");

      this.widget.onLogin();

    }else{
      this._isAutoValidate = true;
      this._keyGlobal.currentState.showSnackBar(SnackBar(content: const Text("Please fix all the errors before submit."),));
    }
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

  String _validatePassword(String text) {
    if(text.isEmpty){
      return "Password should not be empty!";
    }
    if(text.length < 6){
      return "Password is too short!";
    }
    return null;
  }

  _onRegister(){
    this._closeKeyboard();

    this.widget.onRegister();
  }

  _onForgot(){
    this._closeKeyboard();

    this.widget.onForgot();
  }

  _closeKeyboard() => FocusScope.of(this.context).requestFocus(FocusNode());
}