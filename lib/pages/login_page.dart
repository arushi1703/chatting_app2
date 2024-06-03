import 'package:chatting_app2/consts.dart';
import 'package:chatting_app2/services/alert_service.dart';
import 'package:chatting_app2/services/auth_service.dart';
import 'package:chatting_app2/services/navigation_service.dart';
import 'package:chatting_app2/widgets/custom_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GetIt _getIt= GetIt.instance;
  final GlobalKey<FormState> _loginformKey = GlobalKey();
  late AuthService _authService;
  late NavigationService _navigationService;
  late AlertService _alertService;

  String? email, password;

  @override
  void initState() {
    super.initState();
    _authService= _getIt.get<AuthService>();
    _navigationService=_getIt.get<NavigationService>();
    _alertService=_getIt.get<AlertService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUI(),
    );
  }

  Widget _buildUI(){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 20.0,
        ),
        child: Column(
          children: [
            _headerText(),
            _loginForm(),
          ],
        ),
      ),
    );
  }

  Widget _headerText() {
    return SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child:Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height:30),
            Text(
              'Welcome Back',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.pink[500],
              ),
            ),
            Text(
              'Enter details to login',
              style: TextStyle(
                fontSize: 22,
                color: Colors.pink[500],
              ),
            )
          ],
        )
    );
  }

  Widget _loginForm(){
    return Container(
      height: MediaQuery.sizeOf(context).height*0.40,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height*0.05,
      ),
      child: Form(
        key: _loginformKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomFormfield(
              labelText:"Email",
              hintText: "example@gmail.com",
              height: MediaQuery.sizeOf(context).height*0.10,
              regexp: EMAIL_VALIDATION_REGEX,
              onSaved: (value){
                setState(() {
                  email=value;
                });
              },
            ),
            SizedBox(height:20),
            CustomFormfield(
              labelText:"Password",
              hintText: "",
              height: MediaQuery.sizeOf(context).height*0.10,
              regexp: PASSWORD_VALIDATION_REGEX,
              obscureText: true,
              onSaved: (value){
                setState(() {
                  password=value;
                });
              },
            ),
            _loginButton(),
            _createAccountLink(),
          ],
        ),
      ),
    );
  }

  Widget _loginButton(){
    return SizedBox(
      width: 150,
      child: ElevatedButton(
        onPressed: () async {
          if(_loginformKey.currentState?.validate() ?? false){ //if this value is null it will default to false
            _loginformKey.currentState?.save();
            bool result = await _authService.login(email!, password!);
            if (result){
              _navigationService.pushReplacementNamed("/home");
            }else{
              _alertService.showToast(
                  txt: 'Login Failed',
                  icon: Icons.error_outline_rounded
              );
            }
          }
        },
        child: Text(
          'Login',
          style: TextStyle(
            fontSize: 20,
            color:Colors.pink,
          ),
        ),
      ),
    );
  }

  Widget _createAccountLink(){
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            "Don't have an account?",
            style: TextStyle(
              color:Colors.pink,
              fontSize: 20,
            ),
          ),
          GestureDetector(
            onTap:(){
              _navigationService.pushNamed("/signUp");
            },
            child: const Text(
              " Sign Up",
              style: TextStyle(
                color:Colors.pink,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
