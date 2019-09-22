import 'package:flutter/material.dart';

import 'package:dio/dio.dart';

import '../../models/user.dart';
import '../../widgets/default_button.dart';
import '../../resource/auth_resource.dart';
import '../../routes.dart';
import '../../utils/default_padding.dart';
import '../../utils/validations.dart';

class ResponsibleTab extends StatelessWidget {
  final AuthResource _authResource = AuthResource();

  final User _user = User.empty();
  static final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return DefaultPadding(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _buildNameField(),
              _buildEmailField(),
              _buildPhoneField(),
              _buildPassword(),
              SizedBox(height: 70),
              DefaultButton(text: 'CRIAR CONTA', function: () => _submit(context)),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildNameField() =>
    TextFormField(
      onSaved: (value) => _user.name = value,
      decoration: InputDecoration(
        labelText: 'Nome',
      ),
    );

  TextFormField _buildEmailField() =>
    TextFormField(
      onSaved: (value) => _user.email = value,
      decoration: InputDecoration(
        labelText: 'E-mail',
      ),
    );

  TextFormField _buildPhoneField() =>
    TextFormField(
      onSaved: (value) => _user.phone = value,
      decoration: InputDecoration(
        labelText: 'Telefone',
      ),
    );

  TextFormField _buildPassword() =>
    TextFormField(
      onSaved: (value) => _user.password = value,
      decoration: InputDecoration(
        labelText: 'Senha',
      ),
    );

  void _submit(BuildContext context) async {
    _formKey.currentState.save();
    _user.type = UserTypeEnum.RESPONSIBLE;
    try {
      await _authResource.createUser(_user);
      final res = await _authResource.login(_user);
      print('RES -> $res');
      Navigator.pushReplacementNamed(context, Routes.HOME_PAGE);
    } on DioError catch(err) {
      print('response -> \n${err}');
      print('data -> \n${err.response.data}');
      print('headers -> \n${err.response.headers}');
    }
  }
}
