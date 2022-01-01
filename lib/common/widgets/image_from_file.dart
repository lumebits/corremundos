import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:utils/utils.dart';

class ImageFromFile extends StatelessWidget {
  const ImageFromFile(this.path, {Key? key, this.borderRadius})
      : super(key: key);

  final String path;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Utils.isRemoteFile(path)
        ? CachedNetworkImage(
            imageUrl: path,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            errorWidget: (context, url, dynamic error) => const Center(
              child: Icon(Icons.error),
            ),
            placeholder: (context, url) => Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/newcard.png'),
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          )
        : Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(File(path)),
                fit: BoxFit.contain,
              ),
            ),
          );
  }
}
