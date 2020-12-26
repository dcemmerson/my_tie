import 'package:flutter/material.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/models/fly_exhibits/fly_exhibit.dart';
import 'package:my_tie/widgets/search_bar/fly_search_result_preview.dart';
import 'package:my_tie/widgets/search_bar/fly_search_results_stream_builder.dart';

class FlySearchResults extends StatelessWidget {
  Widget _buildFlyExhibitSearchResults(List<FlyExhibit> flyExhibits) {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      itemCount: flyExhibits.length,
      itemBuilder: (context, index) =>
          FlySearchResultPreview(flyExhibits[index]),
    );
    // return Column(
    //     children: flyExhibits
    //         .map((flyExhibit) => FlySearchResultPreview(flyExhibit))
    //         .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 0.7),
          borderRadius: BorderRadius.all(Radius.circular(3))),
      child: FlySearchResultsStreamBuilder(
        flySearchBloc:
            MyTieStateContainer.of(context).blocProvider.flySearchBloc,
        builder: _buildFlyExhibitSearchResults,
      ),
    );
  }
}
