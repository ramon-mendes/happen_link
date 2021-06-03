import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DeckReviewDone extends StatelessWidget {
  static const routeName = '/deckreviewdone';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE5F0F6),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
            child: Lottie.asset('assets/complete.json'),
          ),
          Text('Revisão do deck concluída!'),
        ],
      ),
    );
  }
}
