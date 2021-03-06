import 'dart:async';

import 'package:flutter/material.dart';

import '../../widgets/toast.dart';
import '../../widgets/default_button.dart';
import '../../widgets/block_ui.dart';

import '../../utils/validations.dart';
import '../../utils/default_padding.dart';

import '../../services/auth_service.dart';
import '../../services/service_exception.dart';

import '../../models/user.dart';

class SignIn extends StatelessWidget {
  final AuthService _authService = AuthService();
  final Toast _toast = Toast();
  final User _user = User.empty();
  final PageController _pageController;
  final StreamController<bool> _isLoadingStream;
  static final GlobalKey<FormState> _formKey = GlobalKey();

  SignIn(this._pageController, this._isLoadingStream);

  @override
  WillPopScope build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () {
        _pageController.animateToPage(
          1,
          duration: Duration(milliseconds: 800),
          curve: Curves.fastOutSlowIn,
        );
        return Future.value(false);
      },
      child: BlockUI(
        blockUIController: _isLoadingStream,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Builder(
            builder: (ctx) =>
              DefaultPadding(
                child: Padding(
                  padding: EdgeInsets.only(top: _height / 2),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          _buildEmailField,
                          _buildPasswordField,
                          SizedBox(height: 20),
                          DefaultButton(text: 'ENTRAR', function: () => _submit(ctx)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ),
        ),
      ),
    );
  }

  TextFormField get _buildEmailField =>
    TextFormField(
      onSaved: (value) => _user.email = value,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => Validations.isEmailValid(input: value),
      decoration: InputDecoration(
        labelText: 'E-mail',
      ),
    );

  TextFormField get _buildPasswordField =>
    TextFormField(
      onSaved: (value) => _user.password = value,
      obscureText: true,
      validator: (value) => Validations.isGreaterThan(input: value, minLength: 5),
      decoration: InputDecoration(
        labelText: 'Senha',
      ),
    );

  void _submit(BuildContext context) async {
    if (!_formKey.currentState.validate()) return;
    _isLoadingStream.add(true);
    _formKey.currentState.save();
    try {
      await _authService.login(_user, context, true);
    } on ServiceException catch(err) {
      _toast.show(err.msg, context);
    } finally {
      _isLoadingStream.add(false);
    }
  }
}
