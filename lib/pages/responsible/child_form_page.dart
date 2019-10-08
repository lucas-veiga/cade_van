import 'package:catcher/catcher_plugin.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../../utils/default_padding.dart';
import '../../utils/validations.dart';
import '../../utils/mask.dart';
import '../../widgets/toast.dart';

import '../../resource/resource_exception.dart';
import '../../services/child_service.dart';

import '../../provider/child_provider.dart';
import '../../widgets/default_button.dart';
import '../../models/child.dart';

class ChildFormPage extends StatelessWidget {
  static final GlobalKey<FormState> _formKey = GlobalKey();
  final Child _child = Child.empty();
  final ChildService _childService = ChildService();
  final Toast _toast = Toast();

  @override
  Widget build(BuildContext context) {
  final ChildProvider childProvider = Provider.of<ChildProvider>(context, listen: false);

    return Scaffold(
      bottomNavigationBar: DefaultPadding(
        child: DefaultButton(text: 'SALVAR', function: () => _submit(childProvider, context)),
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
                  _buildDriverCode,
                ],
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
      onSaved: (value) => _child.driverCode = value,
      validator: (value) => Validations.isRequired(input: value),
      decoration: InputDecoration(
        labelText: 'Código do Motorista'
      ),
    );

  Future _submit(final ChildProvider childProvider, final BuildContext context) async {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    try {
      await _childService.saveChild(_child);
      await _childService.setAllChildren(childProvider);
      Navigator.pop(context);
    } on ResourceException catch(err, stack) {
        _toast.show(err.msg, context);
        Catcher.reportCheckedError(err, stack);
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
