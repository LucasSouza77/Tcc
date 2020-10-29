import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigatorUtil {
  Future<dynamic> buildPage({@required BuildContext context, @required Widget page}) {
    return Navigator.push(context, CupertinoPageRoute(
      builder: (context) => page,
    ));
  }

  Future<dynamic> buildAndRemove({@required BuildContext context, @required Widget page}) {
    return Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(
      builder: (context) => page,
    ), (route) => false);
  }
}