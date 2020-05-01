import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IconTextFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.body1,
        children: [
          TextSpan(
              text: 'You can access this info during the test by tapping '),
          WidgetSpan(
            child: Icon(
              Icons.info_outline,
              size: 15,
              color: Colors.grey,
            ),
          ),
          TextSpan(text: ' icon in the upper left corner. '),
        ],
      ),
    );
  }
}
