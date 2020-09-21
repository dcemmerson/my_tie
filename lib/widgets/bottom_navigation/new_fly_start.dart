import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:my_tie/models/fly.dart';
import 'package:my_tie/routes/fly_form_routes.dart';
import 'package:my_tie/styles/styles.dart';
import 'package:my_tie/widgets/forms/new_fly_form/preview_publish/new_fly_attribute_preview.dart';

class NewFlyStart extends StatefulWidget {
  @override
  _NewFlyStartState createState() => _NewFlyStartState();
}

class _NewFlyStartState extends State<NewFlyStart> {
  ConfettiController _confettiController;
  bool _flyAddedToDb = false;
  Fly _flyAdded;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _navigateToNewFlyPublishPage(BuildContext context) async {
    Map returned = await FlyFormRoutes.newFlyPublishPage(context);
    if (returned != null && returned['flyAddedToDb'] == true) {
      setState(() {
        _flyAddedToDb = true;
        _flyAdded = returned['flyAdded'];
      });
    }
  }

  Widget _showConfetti() {
    _confettiController.play();
    return Align(
      alignment: Alignment.center,
      child: ConfettiWidget(
        confettiController: _confettiController,
        emissionFrequency: 0.05,
        maxBlastForce: 5,
        numberOfParticles: 20,
        minBlastForce: 2,

        blastDirectionality: BlastDirectionality.explosive,
        shouldLoop: false, // start again as soon as the animation is finished
        colors: const [
          Colors.green,
          Colors.blue,
          Colors.pink,
          Colors.orange,
          Colors.yellow,
          Colors.purple
        ], // manually specify the colors to be used
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (_flyAddedToDb)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_showConfetti()],
        ),
      if (_flyAddedToDb)
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Fly successfully added!',
                  style: TextStyle(fontSize: AppFonts.h2))
            ],
          ),
        ),
      if (_flyAdded != null && _flyAddedToDb)
        NewFlyAttributePreview(flyInProgress: _flyAdded),
      Expanded(
        flex: 2,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Semantics(
            label: 'New Fly Button',
            hint: 'Tap to add new fly',
            button: true,
            child: RaisedButton(
              key: ValueKey('addNewFlyButton'),
              child: Text(_flyAddedToDb ? 'Add another fly' : 'Add new fly'),
              onPressed: () => _navigateToNewFlyPublishPage(context),
            ),
          ),
        ]),
      ),
    ]);

    // return NewFlyFormAttributes();
  }
}
