import 'dart:io';
import 'package:chatting_app2/models/user_profile.dart';
import 'package:chatting_app2/services/alert_service.dart';
import 'package:chatting_app2/services/auth_service.dart';
import 'package:chatting_app2/services/database_service.dart';
import 'package:chatting_app2/services/storage_service.dart';
import 'package:chatting_app2/services/media_service.dart';
import 'package:chatting_app2/services/navigation_service.dart';
import 'package:chatting_app2/widgets/custom_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import '../consts.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GetIt _getIt= GetIt.instance;
  late MediaService _mediaService;
  late NavigationService _navigationService;
  late AuthService _authService;
  late StorageService _storageService;
  late DatabaseService _databaseService;
  late AlertService _alertService;

  File? selectedImage; //if user wants to give image
  String? email, pwd, name;
  bool isLoading=false;

  final GlobalKey<FormState> _signupFormKey= GlobalKey();

  @override
  void initState() {
    super.initState();
    _mediaService= _getIt.get<MediaService>();
    _navigationService=_getIt.get<NavigationService>();
    _authService=_getIt.get<AuthService>();
    _storageService=_getIt.get<StorageService>();
    _databaseService=_getIt.get<DatabaseService>();
    _alertService=_getIt.get<AlertService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 20.0,
        ),
        child: Column(
          children:[
            _headerText(),
            if (!isLoading) _signupForm(),
            if (!isLoading)_loginAccountLink(),
            if (isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height:30),
            Text(
              'Welcome!!',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.pink[500],
              ),
            ),
            Text(
              'Enter details to Sign Up:',
              style: TextStyle(
                fontSize: 22,
                color: Colors.pink[500],
              ),
            )
          ],
        )
    );
  }

  Widget _signupForm(){
    return Container(
      height: MediaQuery.sizeOf(context).height*0.60,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height*0.05,
      ),
      child: Form(
        key: _signupFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _pfpSelectionField(),
            CustomFormfield(
              labelText: "Name",
              hintText: "John Doe",
              height: MediaQuery.sizeOf(context).height * 0.1,
              regexp: NAME_VALIDATION_REGEX,
              onSaved: (value){
                setState(() {
                  name=value;
                });
              },
            ),
            CustomFormfield(
              labelText: "Email",
              hintText: "johndoe@gmail.com",
              height: MediaQuery.sizeOf(context).height * 0.1,
              regexp: EMAIL_VALIDATION_REGEX,
              onSaved: (value){
                setState(() {
                  email=value;
                });
              },
            ),
            CustomFormfield(
              labelText: "Password",
              hintText: "Johndoe123",
              height: MediaQuery.sizeOf(context).height * 0.1,
              regexp: PASSWORD_VALIDATION_REGEX,
              onSaved: (value){
                setState(() {
                  pwd=value;
                });
              },
              obscureText: true,
            ),
            _signupButton(),
          ],
        ),
      ),
    );
  }

  Widget _signupButton() {
    return SizedBox(
      width: 150,
      child: ElevatedButton(
        onPressed: () async{
          setState(() {
            isLoading=true;
          });
          try{
            if ((_signupFormKey.currentState?.validate() ?? false) && selectedImage!=null){
              _signupFormKey.currentState?.save();
              bool result = await _authService.signup(email!, pwd!);
              if(result) {
                String? pfpURL = await _storageService.uploadPfp(
                  file: selectedImage!,
                  uid: _authService.user!.uid,
                );
                if(pfpURL != null){
                  await _databaseService.createUserProfile(
                      userProfile: UserProfile( //passing a new instance of UserProfile
                          uid: _authService.user!.uid,
                          name: name,
                          pfpURL: pfpURL,
                      )
                  );
                  _alertService.showToast(
                    txt: "User registered successfully",
                    icon: Icons.check_circle_outline,
                  );
                  _navigationService.goBack();
                  _navigationService.pushReplacementNamed("/home");
                }else{
                  throw Exception("Unable to upload pfp");
                }
              }else{ //if result is false
                throw Exception("Unable to register user");
              }
            }
          }catch(e){
            print(e);
            _alertService.showToast(
              txt: "Registration failed! Please try again",
              icon: Icons.check_circle_outline,
            );
          }
          setState(() {
            isLoading=false;
          });
        },
        child: Text(
          'SignUp',
          style: TextStyle(
            fontSize: 20,
            color:Colors.pink,
          ),
        ),
      ),
    );
  }

  Widget _loginAccountLink(){
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            "Already an account?",
            style: TextStyle(
              color:Colors.pink,
              fontSize: 20,
            ),
          ),
          GestureDetector(
            onTap:(){
              _navigationService.goBack();
            },
            child: const Text(
              " Login",
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

  Widget _pfpSelectionField(){
    return GestureDetector(
      onTap: () async {
        File? file = await _mediaService.getImageFromGallery();
        if (file != null){
          setState(() {
            selectedImage = file;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.of(context).size.width * 0.15,
        backgroundImage: selectedImage != null
            ? FileImage(selectedImage!)
            : NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
      ),
    );
  }

}
