import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconNav extends StatelessWidget {
  final List<NavIconData> icons;

  const IconNav({Key? key, required this.icons}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0), // 上部にパディングを追加
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: icons.map((iconData) => NavIcon(iconData: iconData)).toList(),
      ),
    );
  }
}

class NavIcon extends StatelessWidget {
  final NavIconData iconData;

  const NavIcon({Key? key, required this.iconData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: iconData.onTap,
      child: Column(
        children: [
          SvgPicture.asset(
            iconData.iconPath,
            height: 100,
            color: iconData.color,
          ),
          SizedBox(height: 8),
          Text(
            iconData.label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: iconData.color,
            ),
          ),
        ],
      ),
    );
  }
}

class NavIconData {
  final String iconPath;
  final String label;
  final Color color;
  final VoidCallback onTap;

  NavIconData({
    required this.iconPath,
    required this.label,
    required this.color,
    required this.onTap,
  });
}
