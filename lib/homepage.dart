import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
              "Logged In",
              style: TextStyle(fontSize: 100),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    textStyle: const TextStyle(fontSize: 20),
                    backgroundColor: Theme.of(context).primaryColor),
                onPressed: () async {
                  await _auth.signOut();
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
                child: const Text("Sign Out",
                    style: TextStyle(color: Colors.white)))
          ],
        ),
      ),
    );
  }
}
