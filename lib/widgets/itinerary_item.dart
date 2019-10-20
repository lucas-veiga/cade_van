import 'package:flutter/material.dart';

import '../models/itinerary.dart';
import '../utils/default_padding.dart';

class ItineraryItem extends StatelessWidget {
  final Itinerary _itinerary;

  ItineraryItem(this._itinerary);

  @override
  Widget build(BuildContext context) {
    return DefaultPadding(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (_itinerary.isAtivo) Chip(
            label: Text(
              'Em Andamento',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.orange,
          ),
          SizedBox(width: 5),
          Chip(
            label: Text(
              DecodeItineraryTypeEnum.getDescription(_itinerary.type),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: DecodeItineraryTypeEnum.getColor(_itinerary.type),
          ),
          Expanded(
            child: Text(
              _itinerary.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15
              ),
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
}
