import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget{
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(backgroundColor: Colors.grey, title: Text("hio"),),
      body: SingleChildScrollView(
        child: Center(
          child: Text('login'),
        ),
      ),
    );
  }
}