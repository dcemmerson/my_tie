import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:my_tie/models/fly_instruction.dart';

class InstructionPreviewCarousel extends StatelessWidget {
  final FlyInstruction instruction;
  final String startingUri;

  InstructionPreviewCarousel({@required this.instruction, this.startingUri});

  Widget _toImageWithLoadingBar(String uri) {
    return Hero(
      tag: uri,
      child: Image.network(
        uri,
        fit: BoxFit.cover,
        width: 1000,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress != null) {
            return Center(
              child: LinearProgressIndicator(
                value: loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes,
              ),
            );
          }
          return child;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _toImageWithLoadingBar(startingUri);

    // Container(
    //   child: CarouselSlider(
    //     items: instruction.imageUris
    //         .map((uri) => _toImageWithLoadingBar(uri))
    //         .toList(),
    //     options: CarouselOptions(
    //       // height: 300,
    //       viewportFraction: 1,
    //       initialPage: instruction.imageUris.indexOf(startingUri),
    //       enableInfiniteScroll: instruction.imageUris.length > 1,
    //       reverse: false,
    //       autoPlay: false,
    //       // autoPlayInterval: Duration(seconds: 3),
    //       // autoPlayAnimationDuration: Duration(milliseconds: 800),
    //       // autoPlayCurve: Curves.fastOutSlowIn,
    //       enlargeCenterPage: true,
    //       // onPageChanged: callbackFunction,
    //       scrollDirection: Axis.horizontal,
    //     ),
    //   ),
    // );
  }
}
