import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final String text;
  final Function function;
  EdgeInsets customPadding;

  static final EdgeInsets defaultPadding = const EdgeInsets.symmetric(vertical: 15);
  static final RoundedRectangleBorder defaultShape = RoundedRectangleBorder(
    borderRadius: new BorderRadius.circular(30.0),
  );

  DefaultButton.customPadding({
    @required this.text,
    @required this.function,
    @required this.customPadding,
  });

  DefaultButton({
    @required this.text,
    @required this.function,
  });

  @override
  SizedBox build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        shape: defaultShape,
        padding: customPadding == null ? defaultPadding : customPadding,
        color: Theme.of(context).primaryColor,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: function,
      ),
    );
  }
}
