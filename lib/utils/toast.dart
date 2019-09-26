import 'package:flutter/material.dart';

class Toast {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    final String msg,
    final BuildContext context,
    { ToastType type = ToastType.ERROR }) {

    return Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          textAlign: TextAlign.center,
        ),
        backgroundColor: _getToastColor(type),
      ),
    );
  }
  
  Color _getToastColor(ToastType type) {
    if (type == ToastType.SUCCESS) {
      return Colors.green;
    }
    
    if (type == ToastType.ERROR) {
      return Colors.red;
    }
    
    return Colors.orange;
  }
}

enum ToastType {
  ERROR,
  SUCCESS,
  WARNING,
}
