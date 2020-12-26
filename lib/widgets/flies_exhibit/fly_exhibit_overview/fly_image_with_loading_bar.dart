import 'package:flutter/material.dart';
import 'package:my_tie/misc/placeholders.dart';

class FlyImageWithLoadingBar extends StatelessWidget {
  final String uri;

  FlyImageWithLoadingBar(this.uri);
  @override
  Widget build(BuildContext context) {
    return FadeInImage.assetNetwork(
      placeholder: PlaceHolders.loadingImage,
      image: uri,
      imageErrorBuilder: (context, error, stackTrace) => Stack(children: [
        Text('Error loading image',
            style: TextStyle(color: Theme.of(context).errorColor)),
        Image.asset(
          PlaceHolders.loadingImage,
          fit: BoxFit.fill,
          width: 1000,
        ),
      ]),
      // height: height,
      fit: BoxFit.fill,
      width: 1000,
      fadeOutDuration: const Duration(milliseconds: 400),
    );
  }
}
