import 'package:flutter/material.dart';

import 'package:catcher/core/catcher.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_divider.dart';
import '../../widgets/default_button.dart';
import '../../widgets/default_alert_dialog.dart';
import '../../widgets/toast.dart';

import '../../models/child.dart';
import '../../models/itinerary.dart';

import '../../services/driver_service.dart';
import '../../services/child_service.dart';
import '../../services/service_exception.dart';

import '../../utils/application_color.dart';
import '../../utils/default_padding.dart';

import '../../provider/driver_provider.dart';
class ItineraryDetailPage extends StatefulWidget {
  final Itinerary _itinerary;
  final bool isViewing;

  ItineraryDetailPage(this._itinerary, [this.isViewing = false]);

  @override
  _ItineraryDetailPageState createState() => _ItineraryDetailPageState();
}

class _ItineraryDetailPageState extends State<ItineraryDetailPage> {
  final DriverService _driverService  = DriverService();
  final ChildService _childService    = ChildService();

  final Toast _toast = Toast();
  BuildContext contextScaffold;

  @override
  Scaffold build(BuildContext context) {
    return _scaffold(context);
  }

  Scaffold _scaffold(final BuildContext context) {
    if (widget.isViewing) {
      return Scaffold(
        body: Builder(
          builder: (ctx) {
            contextScaffold = ctx;
            return _getBody(context);
          },
        ),
      );
    }
    return Scaffold(
      bottomNavigationBar: DefaultPadding(
        noVertical: true,
        child: DefaultButton(
          text: 'Encerrar Itinerário',
          function: () => _finishItinerary(context),
        ),
      ),
      body: Builder(
        builder: (ctx) {
          contextScaffold = ctx;
          return _getBody(context);
        },
      ),
    );
  }

  CustomScrollView _getBody(final BuildContext context) =>
    CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Theme.of(context).primaryColor,
          floating: false,
          pinned: true,
          expandedHeight: 120,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Chip(
                label: Text(
                  DecodeItineraryTypeEnum.getDescription(widget._itinerary.type),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                padding: EdgeInsets.all(0),
                elevation: 10,
                backgroundColor: DecodeItineraryTypeEnum.getColor(widget._itinerary.type),
              ),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.only(top: 0, bottom: 10),
            centerTitle: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget._itinerary.description,
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate(
              (_, final int index) {
              final child = widget._itinerary.itineraryChildren[index].child;
              return Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      if (!widget.isViewing) {
                        _deliveryChild(child, context, true);
                      }
                    },
                    child: _childItem(child),
                  ),
                  CustomDivider(height: 0),
                ],
              );
            },
            childCount: widget._itinerary.itineraryChildren.length
          ),
        ),
      ],
    );

  _childItem(final Child child) {
    if (widget.isViewing) {
      return DefaultPadding(
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 40,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    child.name,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    child.school,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    child.responsible.name,
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Chip(
                label: Text(
                  DecodeChileStatusEnum.getDescription(child.status),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                padding: EdgeInsets.all(0),
                elevation: 10,
                backgroundColor: DecodeChileStatusEnum.getColor(child.status)
              ),
            )
          ],
        ),
      );
    } else {
      return Slidable(
        actionPane: SlidableDrawerActionPane(),
        actions: <Widget>[
          IconSlideAction(
            caption: 'Entregue',
            color: Colors.blue,
            icon: Icons.check,
            onTap: () => _deliveryChild(child, context),
          ),
        ],
        child: DefaultPadding(
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 40,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      child.name,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      child.school,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      child.responsible.name,
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Chip(
                  label: Text(
                    DecodeChileStatusEnum.getDescription(child.status),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  padding: EdgeInsets.all(0),
                  elevation: 10,
                  backgroundColor: DecodeChileStatusEnum.getColor(child.status)
                ),
              )
            ],
          ),
        ),
      );
    }
  }
  List<FlatButton> _getFinishItineraryActions(final BuildContext context) =>
    [
      FlatButton(
        child: Text(
          'Ainda não',
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        onPressed: () => Navigator.pop(context, false),
      ),
      FlatButton(
        child: Text(
          'Sim',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        onPressed: () {
          _driverService.finishItinerary(context, widget._itinerary.id)
            .then((_) => Navigator.pop(context, true))
            .catchError((err) => Catcher.reportCheckedError(err, 'NoStack, Sorry'));
        },
      ),
    ];


  Future<void> _finishItinerary(final BuildContext context) async {
    final answer = await showDialog(
      context: context,
      builder: (final BuildContext ctx) =>
        DefaultAlertDialog(
          ctx,
          stringTitle: 'Tem certeza que deja encerrar o Itinerário ',
          stringContent: _finishModalContent,
          actions: _getFinishItineraryActions(ctx),
        ),
    );

    if (answer != null && answer == true) {
      Navigator.pop(context);
    }
  }

  String get _finishModalContent {
    if (widget._itinerary.type == ItineraryTypeEnum.IDA) {
      return 'Tem certeza que deixou todas crianças na escola?';
    } else {
      return 'Tem certeza que deixou todas crianças em casa?';
    }
  }

  String get _deliveryModalContent {
    if (widget._itinerary.type == ItineraryTypeEnum.IDA) {
      return 'Tem certeza que deixou essa criança na escola?';
    } else {
      return 'Tem certeza que deixou essa criança em casa?';
    }
  }

  Future<void> _deliveryChild(final Child child, final BuildContext context, [isOnTab = false]) async {
    try {
      if (isOnTab) {
        final answer = await showDialog(
          context: context,
          builder: (ctx) =>
            DefaultAlertDialog(
              ctx,
              stringTitle: 'Tem certeza que entregou essa criança?',
              stringTitleColor: ApplicationColorEnum.WARNING,
              stringContent: _deliveryModalContent,
              actions: <Widget>[
                FlatButton(
                  child: Text('Sim'),
                  onPressed: () => Navigator.pop(ctx, true),
                ),
                FlatButton(
                  child: Text('Ainda Não'),
                  onPressed: () => Navigator.pop(ctx, false),
                )
              ],
            ),
        );

        if (answer == null || answer == false) {
          return;
        }
      }

      final DriverProvider driverProvider = Provider.of<DriverProvider>(context);

      if (widget._itinerary.type == ItineraryTypeEnum.IDA) {
        if (child.status == ChildStatusEnum.WAITING) {
          child.status = ChildStatusEnum.GOING_SCHOOL;
        } else if (child.status == ChildStatusEnum.GOING_SCHOOL) {
          child.status = ChildStatusEnum.LEFT_SCHOOL;
        }
      } else {
        if (child.status == ChildStatusEnum.WAITING) {
          child.status = ChildStatusEnum.GOING_HOME;
        } else if (child.status == ChildStatusEnum.GOING_HOME) {
          child.status = ChildStatusEnum.LEFT_HOME;
        }
      }
      final childSaved = await _childService.updateChild(child);
      final index = widget._itinerary.itineraryChildren.indexWhere((item) => item.child == childSaved);
      await _driverService.setAllItinerary(driverProvider);
      setState(() => widget._itinerary.itineraryChildren[index].child = childSaved);
    } on ServiceException catch(err) {
      print('CONTEX -> \n${err.msg}');
      _toast.show(err.msg, contextScaffold);
    }
  }
}
