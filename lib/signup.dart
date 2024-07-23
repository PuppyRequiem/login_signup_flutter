import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_signup/login.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();

  final _key = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? errorMessage;
  bool _passwordVisible = true;
  bool _confirmpasswordVisible = true;

  Future<String?> _signup(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()));
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("You have Signed in Successfully"),
        duration: Duration(seconds: 5),
      ));
    } on FirebaseAuthException catch (error) {
      errorMessage = error.toString();
    }
    return null;
  }

  String? _emailValidator(String? email) {
    if (email == null || email.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _passwordValidator(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter your password';
    } else if (!RegExp(
            r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$')
        .hasMatch(password)) {
      return 'Minimum eight characters, at least one letter, one number and one special character';
    }
    return null;
  }

  String? _confirmpasswordValidator(String? confirmpassword, String password) {
    if (confirmpassword == null || confirmpassword.isEmpty) {
      return 'Please confirm your password';
    } else if (confirmpassword != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _passwordVisible = true;
    _confirmpasswordVisible = true;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SizedBox(
            width: 700,
            child: Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("WELCOME NEW USER",
                      style: TextStyle(fontSize: 50)),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Enter email"),
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: _emailValidator,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Enter Password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    controller: _passwordController,
                    validator: _passwordValidator,
                    obscureText: _passwordVisible,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Confirm password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _confirmpasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          setState(() {
                            _confirmpasswordVisible = !_confirmpasswordVisible;
                          });
                        },
                      ),
                    ),
                    controller: _confirmpasswordController,
                    validator: (value) => _confirmpasswordValidator(
                        value, _passwordController.text),
                    obscureText: _confirmpasswordVisible,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        textStyle: const TextStyle(fontSize: 20),
                        backgroundColor: Theme.of(context).primaryColor),
                    onPressed: () {
                      setState(() {
                        _emailValidator(_emailController.text);
                        _passwordValidator(_passwordController.text);
                        _confirmpasswordValidator(
                            _confirmpasswordController.text,
                            _passwordController.text);
                      });
                      if (_key.currentState!.validate()) {
                        _signup(
                            _emailController.text, _passwordController.text);
                      }
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/');
                          },
                          child: const Text("login here")),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
