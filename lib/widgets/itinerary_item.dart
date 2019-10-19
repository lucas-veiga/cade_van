import 'package:flutter/material.dart';

import '../models/itinerary.dart';
import '../utils/default_padding.dart';
import './widget_exception.dart';

class ItineraryItem extends StatelessWidget {
  final Itinerary _itinerary;

  ItineraryItem(this._itinerary);

  @override
  Widget build(BuildContext context) {
    return DefaultPadding(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Chip(
            label: Text(
              DecodeItineraryTypeEnum.getDescription(_itinerary.type),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: _chipBGColor,
          ),
          Text(
            _itinerary.description,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                _itinerary.itineraryChildren.length.toString(),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(width: 5),
              Icon(
                Icons.child_care,
                color: Colors.pink,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color get _chipBGColor {
    if (_itinerary == null) {
      throw WidgetException('itinerary is null');
    }

    if (_itinerary.type == null) {
      throw WidgetException('itinerary.type is null');
    }

    switch (_itinerary.type) {
      case ItineraryTypeEnum.IDA:
        return Colors.green;
      case ItineraryTypeEnum.VOLTA:
        return Colors.blue;
      default:
        throw WidgetException('ItineraryTypeEnum nao encontrado | chipBGColor: ${_itinerary.type}');
    }
  }
}
