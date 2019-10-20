import 'package:catcher/core/catcher.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_divider.dart';
import '../../widgets/default_button.dart';
import '../../widgets/modal.dart';

import '../../models/itinerary.dart';
import '../../utils/default_padding.dart';
import '../../services/driver_service.dart';

class ItineraryDetailPage extends StatelessWidget {
  final DriverService _driverService = DriverService();

  final Itinerary _itinerary;
  final Modal _modal = Modal();

  ItineraryDetailPage(this._itinerary);

  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: DefaultPadding(
        noVertical: true,
        child: DefaultButton(
          text: 'Encerrar Itinerário',
          function: () => _finishItinerary(context),
        ),
      ),
      body: CustomScrollView(
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
                    DecodeItineraryTypeEnum.getDescription(_itinerary.type),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  padding: EdgeInsets.all(0),
                  elevation: 10,
                  backgroundColor: DecodeItineraryTypeEnum.getColor(_itinerary.type),
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
                    _itinerary.description,
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
                final child = _itinerary.itineraryChildren[index].child;
                return Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {},
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
                          ],
                        ),
                      ),
                    ),
                    CustomDivider(height: 0),
                  ],
                );
              },
              childCount: _itinerary.itineraryChildren.length
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _finishItinerary(final BuildContext context) async {
    final answer = await _modal.showModal(
      context,
      stringTitle: 'Tem certeza que deja encerrar o Itinerário ',
      stringContent: _modalContent,
      actions: _getFinishItineraryActions(context),
    );

    if (answer != null && answer == true) {
      Navigator.pop(context);
    }
  }

  String get _modalContent {
    if (_itinerary.type == ItineraryTypeEnum.IDA) {
      return 'Tem certeza que deixou todas crianças na escola?';
    } else {
      return 'Tem certeza que deixou todas crianças em casa?';
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
            _driverService.finishItinerary(_itinerary.id)
              .then((_) => Navigator.pop(context, true))
              .catchError((err) => Catcher.reportCheckedError(err, 'NoStack, Sorry'));
        },
      ),
    ];
}
