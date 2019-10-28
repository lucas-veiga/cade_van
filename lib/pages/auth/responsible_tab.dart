import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:catcher/core/catcher.dart';

import '../../utils/default_padding.dart';
import '../../utils/validations.dart';
import '../../utils/mask.dart';

import '../../widgets/toast.dart';
import '../../widgets/default_button.dart';

import '../../services/auth_service.dart';
import '../../services/user_service.dart';

import '../../resource/resource_exception.dart';
import '../../models/user.dart';

class ResponsibleTab extends StatelessWidget {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  final StreamController<bool> _isLoadingStream;
  final CustomMask _customMask = CustomMask();
  final Toast _toast = Toast();
  final User _user = User.empty();
  static final GlobalKey<FormState> _formKey = GlobalKey();

  ResponsibleTab(this._isLoadingStream);

  @override
  Widget build(BuildContext context) {
    return DefaultPadding(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SvgPicture.asset(
                'assets/images/responsible_image.svg',
                height: 250,
                fit: BoxFit.cover,
              ),
              _buildNameField,
              _buildEmailField,
              _buildPhoneField,
              _buildPassword,
              SizedBox(height: 20),
              DefaultButton(text: 'CRIAR CONTA', function: () => _submit(context)),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField get _buildNameField =>
    TextFormField(
      onSaved: (value) => _user.name = value,
      textCapitalization: TextCapitalization.words,
      validator: (value) => Validations.defaultValidator(value, 3),
      decoration: InputDecoration(
        labelText: 'Nome',
      ),
    );

  TextFormField get _buildEmailField =>
    TextFormField(
      onSaved: (value) => _user.email = value,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => Validations.isEmailValid(input: value),
      decoration: InputDecoration(
        labelText: 'E-mail',
      ),
    );

  TextFormField get _buildPhoneField =>
    TextFormField(
      controller: _customMask.telefone(),
      onSaved: (value) => _user.phone = _customMask.removeTelefoneMask(value),
      keyboardType: TextInputType.number,
      validator: (value) => Validations.isTelefoneValid(_customMask.removeTelefoneMask(value)),
      decoration: InputDecoration(
        labelText: 'Telefone com DDD',
      ),
    );

  TextFormField get _buildPassword =>
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
    _formKey.currentState.save();
    _user.type = UserTypeEnum.RESPONSIBLE;
    _isLoadingStream.add(true);
    try {
      await _userService.create(_user, true);
      await _authService.login(_user, context);
    } on ResourceException catch(err, stack) {
      Catcher.reportCheckedError(err, stack);
      _toast.show(err.msg, context);
    } catch (err, stack) {
      Catcher.reportCheckedError(err, stack);
      _toast.show('Algo deu errado!', context);
    } finally {
      _isLoadingStream.add(false);
    }
  }
}
