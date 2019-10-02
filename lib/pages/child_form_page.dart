import 'package:flutter/material.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../utils/default_padding.dart';
import '../utils/validations.dart';
import '../utils/mask.dart';

import '../services/service_exception.dart';
import '../services/child_service.dart';

import '../widgets/default_button.dart';
import '../models/child.dart';

class ChildFormPage extends StatelessWidget {
  static final GlobalKey<FormState> _formKey = GlobalKey();
  final Child _child = Child.empty();
  final ChildService _childService = ChildService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: DefaultPadding(
        child: DefaultButton(text: 'SALVAR', function: _submit),
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

  Future _submit() async {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    try {
      await _childService.saveChild(_child);
    } on ServiceException catch(err) {

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

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buildBirthDateButton(context),
        if (widget._child.birthDate != null) Text(CustomMask().date(widget._child.birthDate)),
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
