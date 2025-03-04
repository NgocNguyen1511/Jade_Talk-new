import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsListTile extends StatelessWidget {
  const SettingsListTile(
      {super.key,
      required this.title,
      this.subTitle,
      required this.icon,
      required this.iconContainerColor,
      required this.onTap});

  final String title;
  final String? subTitle;
  final IconData icon;
  final Color iconContainerColor;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconContainerColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
      title: Text(title),
      subtitle: subTitle != null
          ? Text(
              subTitle!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            )
          : null,
          trailing:  Icon(Platform.isAndroid ? Icons.arrow_forward : Icons.arrow_back_ios_new),
          onTap: onTap,
    );
  }
}
