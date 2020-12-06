import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _formKey = GlobalKey<FormState>();

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
            Wrap(
              children: [
                Icon(Icons.search),
                FractionallySizedBox(
                  widthFactor: 0.85,
                  child: TextFormField(
                    initialValue: 'abc',
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      isDense: true,
                      isCollapsed: true,
                      hintText: 'Search',
                      // fillColor: Colors.red,
                      border: OutlineInputBorder(
                          // borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
