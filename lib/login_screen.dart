import 'package:flutter/material.dart';
import 'components/login_button.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/mindmaple_logo.png', width: 500),
            LoginButton(
              text: 'メールアドレスでログイン',
              color: Colors.green,
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            SizedBox(height: 50),
            LoginButton(
              text: 'Googleアカウントでログイン',
              color: Colors.white,
              textColor: Colors.black,
              image: Image.asset('assets/images/google_logo.png', width: 32),
              onPressed: () {
                // Googleログイン処理を実装
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
          ],
        ),
      ),
    );
  }
}
