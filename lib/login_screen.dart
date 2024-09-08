import 'package:flutter/material.dart';
import 'package:mindmaple/components/login_button.dart';
import 'package:mindmaple/services/auth_service.dart'; // 認証サービスをインポート

class LoginScreen extends StatelessWidget {
  final AuthService _authService = AuthService(); // 認証サービスのインスタンスを作成

  @override
  Widget build(BuildContext context) {
    // 画面サイズに基づいてロゴのサイズを計算
    final screenSize = MediaQuery.of(context).size;
    final logoSize = screenSize.width * 0.8; // 画面幅の80%をロゴサイズとする

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/mindmaple_logo.png',
              width: logoSize,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 50),
            LoginButton(
              text: 'メールアドレスでログイン',
              color: Colors.green,
              onPressed: () async {
                // メールアドレスでのログイン処理
                bool success = await _authService.signInWithEmail();
                if (success) {
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  // エラー処理
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('ログインに失敗しました。')),
                  );
                }
              },
            ),
            SizedBox(height: 20),
            LoginButton(
              text: 'Googleアカウントでログイン',
              color: Colors.white,
              textColor: Colors.black,
              image: Image.asset('assets/images/google_logo.png', width: 24),
              onPressed: () async {
                // Googleアカウントでのログイン処理
                bool success = await _authService.signInWithGoogle();
                if (success) {
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  // エラー処理
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Googleログインに失敗しました。')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
