import 'package:chatting_app2/pages/signUp_page.dart';
import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';

class NavigationService{
  late GlobalKey<NavigatorState> _navigatorKey;

  //creating a map of type String as keys and a widget that gets returned by a function that takes a build context
  final Map<String, Widget Function(BuildContext)> _routes={
    "/login":(context)=> LoginPage(),
    "/home":(context)=> HomePage(),
    "/signUp":(context)=>SignUpPage(),
  };

  //getter funvtion to access navigator key on the navigation service
  GlobalKey<NavigatorState>? get navigatorKey{
    return _navigatorKey;
  }

  Map<String, Widget Function(BuildContext)> get routes{
    return _routes;
  }

  NavigationService(){
    //setting navigatorKey to a new instance of a global key
    _navigatorKey= GlobalKey<NavigatorState>();
  }

  void pushNamed(String routeName){
    _navigatorKey.currentState?.pushNamed(routeName);
  }

  void pushReplacementNamed(String routeName){
    _navigatorKey.currentState?.pushReplacementNamed(routeName);
  }

  void goBack(){
    _navigatorKey.currentState?.pop();
  }
}