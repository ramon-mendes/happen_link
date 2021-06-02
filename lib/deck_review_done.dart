import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DeckReviewDone extends StatelessWidget {
  static const routeName = '/deckreviewdone';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Lottie.asset('assets/complete.json'),
          Text('Revisão do deck concluída!'),
        ],
      ),
    );
  }
}
