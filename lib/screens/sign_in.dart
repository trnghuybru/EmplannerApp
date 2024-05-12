import 'dart:convert';

import 'package:emplanner/screens/dashboard.dart';
import 'package:emplanner/screens/tabs.dart';
import 'package:emplanner/widgets/combo_text_field.dart';
import 'package:emplanner/widgets/buttons/main_button.dart';
import 'package:flutter/material.dart';
import 'package:emplanner/auth_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  var authInfo = AuthService();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  var _isSending = false;
  var _isError = false;
  String _error = '';

  void _loginSubmit(context) async {
    String enteredEmail = emailController.text.trim();
    String enteredPassword = passwordController.text.trim();

    setState(() {
      _isError = false;
      _isSending = true;
    });

    final response = await authInfo.login(enteredEmail, enteredPassword);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final String token = data['data']['token'];

      await AuthService.setToken(token);

      setState(() {
        _isSending = false;
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (ctx) => const TabsScreen()));
    } else {
      setState(() {
        _isError = true;
        _error = json.decode(response.body)['message'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: Image.asset('assets/images/shape.png'),
          ),
          SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  MediaQuery.of(context).padding.top + 130,
                  16,
                  keyboardSpace + 16,
                ),
                child: Column(
                  children: [
                    Image.asset('assets/images/logo.png'),
                    const SizedBox(
                      height: 60,
                    ),
                    Image.asset(
                        'assets/images/undraw_access_account_re_8spm 1.png'),
                    const SizedBox(
                      height: 60,
                    ),
                    ComboTextField(
                      controller: emailController,
                      title: 'Email',
                      hintText: 'emplanner@mail.com',
                      isPassword: false,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ComboTextField(
                      controller: passwordController,
                      title: 'Password',
                      hintText: 'Enter your password',
                      isPassword: true,
                    ),
                    if (_isError)
                      Text(
                        _error,
                        style: const TextStyle(color: Colors.red),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot Password?',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(
                                        255, 250, 187, 24)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: MainButton(
                        onPressed: _isSending
                            ? () {}
                            : () {
                                final focusNode = FocusScope.of(context);
                                focusNode.unfocus();
                                _loginSubmit(context);
                              },
                        title: _isSending
                            ? const CircularProgressIndicator()
                            : Text(
                                'Login',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                              ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have account?",
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Sign Up',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(
                                        255, 250, 187, 24)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
