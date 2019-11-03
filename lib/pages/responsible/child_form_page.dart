import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:catcher/catcher_plugin.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../../utils/default_padding.dart';
import '../../utils/validations.dart';
import '../../utils/mask.dart';

import '../../widgets/toast.dart';
import '../../widgets/default_button.dart';
import '../../widgets/block_ui.dart';

import '../../services/child_service.dart';
import '../../services/service_exception.dart';

import '../../provider/child_provider.dart';
import '../../provider/user_provider.dart';

import '../../models/child.dart';

class ChildFormPage extends StatelessWidget {
  final ChildService _childService = ChildService();

  static final GlobalKey<FormState> _formKey = GlobalKey();
  static final TextEditingController _driverCodeController = TextEditingController();

  final Child _child = Child.empty();
  final Toast _toast = Toast();
  final StreamController<bool> _blockUIStream = StreamController.broadcast();

  @override
  Widget build(BuildContext context) {
    return BlockUI(
      blockUIController: _blockUIStream,
      child: Scaffold(
        bottomNavigationBar: DefaultPadding(
          child: DefaultButton(text: 'SALVAR', function: () => _submit(context)),
        ),
        body: DefaultPadding(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 100,
                    ),
                    _buildNameField,
                    _buildSchoolField,
                    _buildPeriodoField,
                    BirthDate(_child),
                    Row(
                      children: <Widget>[
                        Flexible(
                          flex: 9,
                          child: _buildDriverCode,
                        ),
                        Flexible(
                          flex: 3,
                          child: RaisedButton(
                            child: Text('Colar'),
                            onPressed: () => Clipboard.getData('text/plain').then((res) {
                              _child.driverCode = res.text;
                              _driverCodeController.text = res.text;
                            }),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField get _buildNameField =>
    TextFormField(
      onSaved: (value) => _child.name = value,
      textCapitalization: TextCapitalization.words,
      validator: (value) => Validations.isRequired(input: value),
      decoration: InputDecoration(
        labelText: 'Nome',
      ),
    );

  TextFormField get _buildSchoolField =>
    TextFormField(
      onSaved: (value) => _child.school = value,
      validator: (value) => Validations.isRequired(input: value),
      decoration: InputDecoration(
        labelText: 'Escola',
      ),
    );

  TextFormField get _buildPeriodoField =>
    TextFormField(
      onSaved: (value) => _child.period = value,
      validator: (value) => Validations.isRequired(input: value),
      decoration: InputDecoration(
        labelText: 'Período',
      ),
    );

  TextFormField get _buildDriverCode =>
    TextFormField(
      controller: _driverCodeController,
      onSaved: (value) => _child.driverCode = value,
      validator: (value) => Validations.isRequired(input: value),
      decoration: InputDecoration(
        labelText: 'Código do Motorista'
      ),
    );

  Future _submit(final BuildContext context) async {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();

    _blockUIStream.add(true);
    final ChildProvider childProvider = Provider.of<ChildProvider>(context, listen: false);
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      await Future.delayed(Duration(seconds: 3));
      _child.status = ChildStatusEnum.LEFT_HOME;
      _child.responsible = userProvider.user;
      await _childService.saveChild(_child);
      await _childService.setAllChildren(childProvider);
      Navigator.pop(context);
    } on ServiceException catch(err) {
      _toast.show(err.msg, context);
    } finally {
      _blockUIStream.add(false);
    }
  }
}


class BirthDate extends StatefulWidget {
  final Child _child;

  BirthDate(this._child);

  @override
  _BirthDateState createState() => _BirthDateState();
}

class _BirthDateState extends State<BirthDate> {
  final CustomMask _customMask = CustomMask();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buildBirthDateButton(context),
        if (widget._child.birthDate != null) Text(_customMask.date(widget._child.birthDate)),
      ],
    );
  }

  FlatButton _buildBirthDateButton(final BuildContext context) =>
    FlatButton(
      child:
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text('Data de Nascimento')
        ],
      ),
      onPressed: () => DatePicker.showDatePicker(
        context,
        maxTime: DateTime.now(),
        locale: LocaleType.pt,
        onConfirm: (value) => setState(() => widget._child.birthDate = value),
      ),
    );
}
