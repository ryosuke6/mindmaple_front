import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const Header({Key? key, required this.title}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // 戻るボタンを非表示にする
      backgroundColor: Colors.green, // 背景色を指定
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white, // テキストの色を指定
              fontSize: 30,
            ),
          ),
          const SizedBox(width: 8),
          SvgPicture.asset(
            'assets/images/header_logo.svg', // ロゴのパスを設定
            height: 30,
          ),
        ],
      ),
    );
  }
}
