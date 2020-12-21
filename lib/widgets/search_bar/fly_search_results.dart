import 'package:flutter/material.dart';
import 'package:my_tie/bloc/fly_search_bloc.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/models/fly_exhibits/fly_exhibit.dart';
import 'package:my_tie/widgets/search_bar/fly_search_results_stream_builder.dart';

class FlySearchResults extends StatelessWidget {
  Widget _buildFlyExhibitSearchResults(List<FlyExhibit> flyExhibits) {
    print(flyExhibits);
    return Column(
        children: flyExhibits
            .map((flyExhibit) => Row(
                  children: [Text(flyExhibit.fly.flyName)],
                ))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 0.7),
          borderRadius: BorderRadius.all(Radius.circular(3))),
      // height: 10,
      // margin: EdgeInsets.all(0),
      // color: Color.fromRGBO(255, 255, 255, 0.7),
      child: FlySearchResultsStreamBuilder(
        flySearchBloc:
            MyTieStateContainer.of(context).blocProvider.flySearchBloc,
        builder: _buildFlyExhibitSearchResults,
      ),
    );
  }
}
