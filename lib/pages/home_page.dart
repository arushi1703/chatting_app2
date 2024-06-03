import 'package:chatting_app2/services/alert_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:chatting_app2/services/auth_service.dart';
import 'package:chatting_app2/services/navigation_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final GetIt _getIt= GetIt.instance; //variable that stores reference to the GetIt package
  late AuthService _authService;
  late NavigationService _navigationService;
  late AlertService _alertService;

  @override
  void initState() {
    super.initState();
    _authService= _getIt.get<AuthService>();
    _navigationService= _getIt.get<NavigationService>();
    _alertService=_getIt.get<AlertService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Chats",
          style: TextStyle(
            fontSize: 25,
            color: Colors.pink,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              bool result = await _authService.logout();
              if (result){
                _alertService.showToast(
                  txt: "Logout successful",
                  icon: Icons.check_circle_outline,
                );
                _navigationService.pushReplacementNamed("/login");
              }
            },
            icon: const Icon(
              Icons.logout_rounded,
            ),
          )
        ],
      ),
    );
  }
}
