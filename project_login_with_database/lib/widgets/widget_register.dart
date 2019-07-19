import 'dart:async';
import 'package:flutter/material.dart';
import '../database/data_class.dart';

typedef void SubmitCallback(User user);

class RegisterWidget extends StatefulWidget {
  RegisterWidget({this.onCancel, this.onRegisterNew});

  final VoidCallback onCancel;
  final SubmitCallback onRegisterNew;

  @override
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final _keyGlobal = GlobalKey<ScaffoldState>();
  final _keyForm = GlobalKey<FormState>();

  var _isAutoValidate = false;
  var _isPasswordObscure = false;

  final _user = User.fromEmpty();

  @override
  Widget build(BuildContext context) => Scaffold(
    key: this._keyGlobal,
    appBar: AppBar(title: const Text("Register Page"), leading: IconButton(onPressed: this._onCancel, icon: Icon(Icons.close, color: Colors.red.shade200,),),),
    body: SafeArea(
      top: false,
      bottom: false,
      child: Form(
        key: this._keyForm,
        autovalidate: this._isAutoValidate,
        onWillPop: this._onLeaveWithoutSave,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: this._buildRegisterTextFields(),
          ),
        ),
      ),
    ),
  );

  _buildRegisterTextFields() => <Widget>[
    TextFormField(
      autovalidate: this._isAutoValidate,
      onSaved: (text) => this._user.userName = text,
      validator: this._validateUsername,
      decoration: InputDecoration(
        icon: Icon(Icons.person, color: Colors.green,),
        border: OutlineInputBorder(),
        filled: true,
        labelText: "Username",
        helperText: "* requeired",
      ),
    ),

    const SizedBox(height: 10.0,),
    TextFormField(
      autovalidate: this._isAutoValidate,
      onSaved: (text) => this._user.email = text,
      validator: this._validateEmail,
      decoration: InputDecoration(
        icon: Icon(Icons.email, color: Colors.green,),
        border: OutlineInputBorder(),
        filled: true,
        labelText: "Email",
        helperText: "* requeired as account",
      ),
    ),

    const SizedBox(height: 10.0,),
    TextFormField(
      obscureText: this._isPasswordObscure,
      autovalidate: this._isAutoValidate,
      onSaved: (text) => this._user.password = text,
      validator: this._validatePassword,
      decoration: InputDecoration(
        icon: Icon(Icons.security, color: Colors.red,),
        border: OutlineInputBorder(),
        filled: true,
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
      maxLines: 4,
      onSaved: (text) => this._user.information = text,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Information",
        helperText: "Tell somthing about you",
      ),
    ),

    const SizedBox(height: 10.0,),
    Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        OutlineButton(child: const Text("Cancel"), color: Colors.grey.shade400, textColor: Colors.grey, onPressed: this._onCancel,),
        OutlineButton(child: const Text("Submit"), color: Colors.blue.shade300, textColor: Colors.green, onPressed: this._onRegister,),
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

  _onCancel() {
    this._closeKeyboard();

    this._onLeaveWithoutSave().then((leave) {
      if(leave){
        this.widget.onCancel();
      }
    });
  }

  _onRegister() {
    this._closeKeyboard();

    final formState = this._keyForm.currentState;
    if(formState.validate()){
      formState.save();

      this.widget.onRegisterNew(this._user);

    }else{
      this._isAutoValidate = false;
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
