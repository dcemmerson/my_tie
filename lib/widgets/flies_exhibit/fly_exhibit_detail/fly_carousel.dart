import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:my_tie/misc/placeholders.dart';

class FlyCarousel extends StatelessWidget {
  final List<String> uris;

  FlyCarousel(this.uris);

  Widget _toImageWithLoadingBar(String uri) {
    return Image.network(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: uris?.map((uri) => _toImageWithLoadingBar(uri))?.toList(),
      options: CarouselOptions(
        height: 300,
        viewportFraction: 1,
        initialPage: 0,
        enableInfiniteScroll: uris != null && uris.length > 1,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        // onPageChanged: callbackFunction,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
