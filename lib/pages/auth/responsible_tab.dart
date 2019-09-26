import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/toast.dart';
import '../../utils/default_padding.dart';
import '../../utils/validations.dart';
import '../../utils/mask.dart';

import '../../resource/auth_resource.dart';
import '../../resource/resource_exception.dart';

import '../../models/user.dart';
import '../../widgets/default_button.dart';

class ResponsibleTab extends StatelessWidget {
  final AuthResource _authResource = AuthResource();
  final Toast _toast = Toast();
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
              SvgPicture.asset(
                'assets/images/back_to_school_bg.svg',
                height: 250,
                fit: BoxFit.cover,
              ),
              _buildNameField(),
              _buildEmailField(),
              _buildPhoneField(),
              _buildPassword(),
              SizedBox(height: 20),
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
      validator: (value) => Validations.defaultValidator(value, 3),
      decoration: InputDecoration(
        labelText: 'Nome',
      ),
    );

  TextFormField _buildEmailField() =>
    TextFormField(
      onSaved: (value) => _user.email = value,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => Validations.isEmailValid(input: value),
      decoration: InputDecoration(
        labelText: 'E-mail',
      ),
    );

  TextFormField _buildPhoneField() =>
    TextFormField(
      controller: CustomMask().telefone(),
      onSaved: (value) => _user.phone = CustomMask().removeTelefoneMask(value),
      keyboardType: TextInputType.number,
      validator: Validations.isTelefoneValid,
      decoration: InputDecoration(
        labelText: 'Telefone com DDD',
      ),
    );

  TextFormField _buildPassword() =>
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
    try {
      await _authResource.createUser(_user);
      await _authResource.login(_user, context);
    } on ResourceException catch(err) {
      _toast.show(err.msg, context, type: ToastType.ERROR);
    }
  }
}
