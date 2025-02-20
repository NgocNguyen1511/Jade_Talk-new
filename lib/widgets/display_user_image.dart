import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jade_talk/utilities/assets_manager.dart';
import 'package:jade_talk/utilities/global_methods.dart';

class DisplayUserImage extends StatelessWidget {
   DisplayUserImage(
      {super.key,required this.finalFileImage, required this.radius, required this.onPressed});

  File? finalFileImage;
  final double radius;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return finalFileImage == null
        ? Stack(
            children: [
               CircleAvatar(
                radius: radius,
                backgroundImage: AssetImage(AssetsManager.userImage),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: onPressed,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )
        : Stack(
            children: [
              CircleAvatar(
                radius: radius,
                backgroundImage: FileImage(File(finalFileImage!.path)),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: onPressed,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
