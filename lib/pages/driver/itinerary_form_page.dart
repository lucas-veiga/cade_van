import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:catcher/core/catcher.dart';

import '../../utils/application_color.dart';
import '../../utils/default_padding.dart';
import '../../utils/validations.dart';

import '../../models/itinerary.dart';
import '../../models/child.dart';

import '../../widgets/default_button.dart';
import '../../widgets/custom_divider.dart';
import '../../widgets/toast.dart';
import '../../widgets/block_ui.dart';

import '../../services/driver_service.dart';
import '../../provider/driver_provider.dart';

class ItineraryFormPage extends StatefulWidget {
  final List<Child> _allChildren;

  ItineraryFormPage(this._allChildren);

  @override
  _ItineraryFormPageState createState() => _ItineraryFormPageState();
}

class _ItineraryFormPageState extends State<ItineraryFormPage> {
  final DriverService _driverService = DriverService();

  final StreamController<bool> _blockUIStream = StreamController.broadcast();
  final Itinerary _itinerary = Itinerary()..type = ItineraryTypeEnum.IDA;
  final List<Child> _childrenSelected = [];
  final GlobalKey<FormState> _formKey = GlobalKey();
  final Toast _toast = Toast();

  @override
  Widget build(BuildContext context) {
    return BlockUI(
      blockUIController: _blockUIStream,
      child: Scaffold(
        bottomNavigationBar: Builder(
          builder: (ctx) => DefaultPadding(
            child: DefaultButton(text: 'SALVAR', function: () => _submit(ctx)),
          ),
        ),
        appBar: AppBar(
          title: Text(
            'Novo itinerário',
            style: TextStyle(
              color: Theme.of(context).primaryColor
            ),
          ),
          backgroundColor: Colors.transparent,
          actionsIconTheme: IconThemeData(
            color: Theme.of(context).primaryColor,
          ),
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor,
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DefaultPadding(child: _buildNameField),
                SizedBox(height: 20),
                DefaultPadding(child: Text('Tipo de Itinerário'), noVertical: true),
                DefaultPadding(
                  noVertical: true,
                  child: Row(
                    children: <Widget>[
                      Text(DecodeItineraryTypeEnum.getDescription(ItineraryTypeEnum.IDA)),
                      Radio(
                        value: ItineraryTypeEnum.IDA,
                        groupValue: _itinerary.type,
                        onChanged: (value) => setState(() => _itinerary.type = value),
                      ),
                      SizedBox(width: 20),
                      Text(DecodeItineraryTypeEnum.getDescription(ItineraryTypeEnum.VOLTA)),
                      Radio(
                        value: ItineraryTypeEnum.VOLTA,
                        groupValue: _itinerary.type,
                        onChanged: (value) => setState(() => _itinerary.type = value),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  height: MediaQuery.of(context).size.height / 1.79,
                  child: _buildChildrenList
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField get _buildNameField =>
    TextFormField(
      onSaved: (value) => _itinerary.description = value,
      textCapitalization: TextCapitalization.words,
      validator: (value) => Validations.isRequired(input: value),
      decoration: InputDecoration(
        labelText: 'Nome',
      ),
    );

  ListView get _buildChildrenList =>
    ListView.separated(
      separatorBuilder: (_, __) => CustomDivider(height: 0),
      itemCount: widget._allChildren.length,
      itemBuilder: (final BuildContext ctx, final int index) => Container(
        child: InkWell(
          onTap: () => _onChildSelection(widget._allChildren[index]),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: <Widget>[
                Checkbox(
                  value: _isCheckboxSelected(widget._allChildren[index]),
                  onChanged: (value) => _onChildSelection(widget._allChildren[index], value),
                ),
                CircleAvatar(
                  radius: 30,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildChildNameField(widget._allChildren[index].name),
                      _buildChildSchoolField(widget._allChildren[index].school),
                      _buildChildResponsibleField(widget._allChildren[index].responsible.name),
                      _buildChildPeriodField(widget._allChildren[index].period),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );

  RichText _buildChildNameField(final String name) =>
    RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Nome: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: name,
            style: TextStyle(
              color: Colors.black,
            ),
          )
        ],
      ),
    );

  RichText _buildChildResponsibleField(final String responsible) =>
    RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Responsável: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: responsible,
            style: TextStyle(
              color: Colors.black,
            ),
          )
        ],
      ),
    );

  RichText _buildChildSchoolField(final String school) =>
    RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Escola: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: school,
            style: TextStyle(
              color: Colors.black,
            ),
          )
        ],
      ),
    );

  RichText _buildChildPeriodField(final String period) =>
    RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Periodo: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: period,
            style: TextStyle(
              color: Colors.black,
            ),
          )
        ],
      ),
    );

  set _addChildIntoSelection(final Child child) =>
    setState(() => _childrenSelected.add(child));

  set _removeChildFromSelection(final Child child) =>
    setState(() => _childrenSelected.removeWhere((item) => item == child));

  void _onChildSelection(final Child child, [final bool value]) {
    if (value != null) {
      if (value) {
        _addChildIntoSelection = child;
      } else {
        _removeChildFromSelection = child;
      }
    } else {
      if (_childrenSelected.contains(child)) {
        _removeChildFromSelection = child;
      }
      else {
        _addChildIntoSelection = child;
      }
    }
  }

  bool _isCheckboxSelected(final Child child) {
    return _childrenSelected.contains(child);
  }

  Future<void> _submit(final BuildContext context) async {
    if (!_formKey.currentState.validate()) return;
    if (_childrenSelected.isEmpty) {
      _toast.show('Selecione ao menos uma criança', context, backgroundColor: ApplicationColorEnum.WARNING);
      return;
    }
    _formKey.currentState.save();
    _blockUIStream.add(true);
    _itinerary.itineraryChildren = _childrenSelected
      .asMap()
      .map((index, child) => MapEntry(index, ItineraryChild(child, index)))
      .values
      .toList();
    try {
      final DriverProvider driverProvider = Provider.of<DriverProvider>(context, listen: false);

      await _driverService.saveItinerary(_itinerary, true);
      await _driverService.setAllItinerary(driverProvider);
      Navigator.pop(context);
    } catch(err, stack) {
      Catcher.reportCheckedError(err, stack);
    } finally {
      _blockUIStream.add(false);
    }
  }

}
