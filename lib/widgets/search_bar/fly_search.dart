import 'package:flutter/material.dart';
import 'package:my_tie/bloc/fly_search_bloc.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';

class FlySearch extends StatefulWidget {
  @override
  _FlySearchState createState() => _FlySearchState();
}

class _FlySearchState extends State<FlySearch> {
  final _formKey = GlobalKey<FormState>();
  FlySearchBloc _flySearchBloc;

  void didChangeDependencies() {
    super.didChangeDependencies();
    _flySearchBloc = MyTieStateContainer.of(context).blocProvider.flySearchBloc;
  }

  // void _handleInput(String str) {
  //   _flySearchBloc.flySearchTermSink.add(str);
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 0.7),
          borderRadius: BorderRadius.all(Radius.circular(3))),
      // height: 10,
      // margin: EdgeInsets.all(0),
      // color: Color.fromRGBO(255, 255, 255, 0.7),
      child: Form(
        key: _formKey,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            Text('body goes here...'),
            // Wrap(
            //   children: [
            //     Icon(Icons.search,
            //         color: Theme.of(context).colorScheme.primaryVariant),
            //     FractionallySizedBox(
            //       widthFactor: 0.85,
            //       child: TextField(
            //         onChanged: null,
            //         // initialValue: 'abc',
            //         decoration: const InputDecoration(
            //           contentPadding: EdgeInsets.all(5),
            //           isDense: true,
            //           isCollapsed: true,
            //           hintText: 'Search',
            //           // fillColor: Colors.red,
            //           // border: OutlineInputBorder(
            //           //     // borderRadius: BorderRadius.all(Radius.circular(10)),
            //           //     ),
            //         ),
            //       ),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
