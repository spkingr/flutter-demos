import 'package:flutter/material.dart';
import 'dart:async';

class TextFieldPage extends StatefulWidget{

  static const PAGE_NAME = "text_field";

  @override
  _TextFieldPageState createState() => _TextFieldPageState();
}

class PersonData{
  String name = "";
  String password = "";
  String email = "";
  String phone = "";
  String information = "";
  double salary = 0.0;

  @override
  String toString() => "${this.name}, your phone number: ${this.phone} and salary: ${this.salary}.";
}

class _TextFieldPageState extends State<TextFieldPage>{
  final _keyGlobal = GlobalKey<ScaffoldState>();

  var _isPasswordObscure = true;

  final _personData = PersonData();
  final _keyForm = GlobalKey<FormState>();
  var _isAutoValidate = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    key: this._keyGlobal,
    appBar: AppBar(title: Text("Text Fields"),),
    body: SafeArea(
      top: false,
      bottom: false,
      child: Form(
        key: this._keyForm,
        autovalidate: this._isAutoValidate,
        onWillPop: this._onFormWillPopWarning,
        child: SingleChildScrollView(padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: this._buildTextFields(),),),
      ),
    ),
  );

  List<Widget> _buildTextFields() => <Widget>[
    const SizedBox(height: 20.0,),
    TextFormField(
      onSaved: (text) => this._personData.name = text,
      validator: this._validateName,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        filled: true,
        icon: const Icon(Icons.person, color: Colors.red,),
        hintText: "Name...",
        labelText: "Name*",
        helperText: "*required",
      ),
    ),

    const SizedBox(height: 20.0,),
    TextFormField(
      onSaved: (text) => this._personData.phone = text,
      validator: this._validatePhone,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        filled: true,
        icon: const Icon(Icons.phone, color: Colors.red,),
        labelText: "Phone Number*",
        helperText: "*required",
        prefixText: "+86"
      ),
    ),

    const SizedBox(height: 20.0,),
    TextFormField(
      onSaved: (text) => this._personData.email = text,
      validator: this._validateEmail,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        filled: true,
        icon: const Icon(Icons.email, color: Colors.green,),
        labelText: "Email",
      ),
    ),

    const SizedBox(height: 20.0,),
    TextFormField(
      maxLines: 4,
      onSaved: (text) => this._personData.information = text,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Information",
      ),
    ),

    const SizedBox(height: 20.0,),
    TextFormField(
      onSaved: (text) => this._personData.salary = double.parse(text),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Salary",
        prefixText: "\$",
        prefixStyle: TextStyle(fontSize: 20.0, color: Colors.blue),
        suffixText: "USD",
        suffixStyle: TextStyle(fontSize: 20.0, color: Colors.purple),
      ),
    ),

    const SizedBox(height: 20.0,),
    TextFormField(
      onSaved: (text) => this._personData.password = text,
      validator: this._validatePassword,
      obscureText: this._isPasswordObscure,
      maxLength: 16,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Password",
        helperText: "*required",
        suffixIcon: GestureDetector(
          onTap: () => this.setState(() => this._isPasswordObscure = ! this._isPasswordObscure),
          child: Icon(this._isPasswordObscure ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    ),

    const SizedBox(height: 10.0,),
    Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
            margin: const EdgeInsets.only(right: 20.0),
            child: RaisedButton(
              textColor: Colors.green,
              child: const Text("Submit"),
              onPressed: this._onSubmit,
            ),
        ),
      ],),
    const SizedBox(height: 20.0,),
  ];

  Future<bool> _onFormWillPopWarning() async{
    if(this._keyForm.currentState == null || this._keyForm.currentState.validate()){
      return true;
    }
    var dialog = showDialog<bool>(
      context: this.context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Errors in form data"),
        content: const Text("Give up to leave this form?"),
        actions: <Widget>[
          FlatButton(onPressed: () => Navigator.of(this.context).pop(true), child: const Text("Give Up"),),
          FlatButton(onPressed: () => Navigator.of(this.context).pop(false), child: const Text("Stay Here"),),
        ],
      ),
    );
    return dialog ?? false;
  }

  void _onSubmit(){
    final formState = this._keyForm.currentState;
    if(! formState.validate()){
      this._isAutoValidate = true;
      this._keyGlobal.currentState.showSnackBar(SnackBar(content: const Text("Please fix all the errors before submit."),));
    }else{
      formState.save();
      this._keyGlobal.currentState.showSnackBar(SnackBar(content: Text(this._personData.toString()),));
    }
  }

  String _validateName(String text){
    if(text.isEmpty){
      return "Name is required!";
    }
    final reg = RegExp(r'^[A-Za-z ]+$');
    if(!reg.hasMatch(text)){
      return "Only letters can be used.";
    }
    return null;
  }
  String _validatePhone(String text){
    final reg = RegExp(r'^\d{11}$');
    if(!reg.hasMatch(text)){
      return "Requrie 11 digitals in phone number!";
    }
    return null;
  }
  String _validateEmail(String text){
    final reg = RegExp(r'^[A_Za-z._0-9]+@[A_Za-z._0-9]+\.[A_Za-z._0-9]+$');
    if(!reg.hasMatch(text)){
      return "Invalid email address!";
    }
    return null;
  }
  String _validatePassword(String text){
    if(text.isEmpty){
      return "Password requires!";
    }
    return null;
  }
}