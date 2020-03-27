import 'package:flutter/material.dart';
import 'package:itry/wrappers/menu_wrapper.dart';

class Options extends StatefulWidget {
  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  @override
  Widget build(BuildContext context) {
    return MenuWrapper(
      title: 'Options',
      child: Center(
        child: Text('Options'),
      ),
    );
  }
}
