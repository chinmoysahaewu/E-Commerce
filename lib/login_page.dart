import 'package:e_commerce/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'custom_button.dart';
import 'custom_input.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Container(
              child: Text(error),
            ),
            actions: [
              TextButton(
                child: Text("Close Dialog"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  Future<String> _loginAccount() async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: _loginEmail, password: _loginPassword);
      return null;
    }
    on FirebaseAuthException catch(e){
      if(e.code == "weak-password"){
        return "The password provided is too weak.";
      }else if(e.code == "email-already-in-use"){
        return "The account already exist for that email";
      }
      return e.message;
    }catch(e){
      return e.toString();
    }
  }

  void _submitForm() async{
    setState(() {
      _loginFormLoading = true;
    });
    String _logInFeedback = await _loginAccount();
    if(_logInFeedback != null){
      _alertDialogBuilder(_logInFeedback);

      setState(() {
        _loginFormLoading = false;
      });
    }
  }

  bool _loginFormLoading = false;
  String _loginEmail = "";
  String _loginPassword = "";

  FocusNode _passwordFocusNode;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }


  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    padding: EdgeInsets.only(top: 24.0),
                    child: Text(
                      "Welcome user,\nLogin to your account",
                      textAlign: TextAlign.center,
                      style: Constants.boldHeading,
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 50.0,
                  ),
                  child: Column(
                    children: [
                      CustomInput(
                        hintText: "Email...",
                        onChanged: (value) {
                          _loginEmail = value;
                        },
                        onSubmitted: (value) {
                          _passwordFocusNode.requestFocus();
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      CustomInput(
                        hintText: "Password...",
                        onChanged: (value) {
                          _loginPassword = value;
                        },
                        focusNode: _passwordFocusNode,
                        isPasswordField: true,
                        onSubmitted: (value){
                          _submitForm();
                        },
                      ),
                      CustomButton(
                        text: "Login",
                        onPressed: () {
                          _submitForm();
                        },
                        isLoading: _loginFormLoading,
                      ),
                    ],
                  ),
                ),
                CustomButton(
                  text: "Create New Account",
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context){
                          return RegisterPage();
                        }
                    )
                    );
                  },
                  outlineBtn: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
