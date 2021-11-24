
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stats_app/providers/authentication_provider.dart';
import 'package:stats_app/widgets/app_main_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailInputController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthenticationProvider>(context);

    return Scaffold(
        appBar: AppMainBar("Login"),
        body: Center(
          child: SizedBox(
            width: double.infinity,
            height: 400,
            child: Padding(
              padding: const EdgeInsets.all(46.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: emailInputController,
                      decoration: const InputDecoration(
                          labelText: 'Email',
                          icon: Icon(Icons.account_circle_rounded)),
                    ),
                    TextFormField(
                      controller: passwordInputController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText: 'Password', icon: Icon(Icons.lock)),
                    ),
                    const Spacer(),
                    ElevatedButton(
                        onPressed: () {
                          authProvider.login(emailInputController.text, passwordInputController.text);
                        },
                        child: const Text('Log in')
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
