import './child.dart';

class Itinerary {
  int id;
  String description;
  int driverId;
  List<ItineraryChild> itineraryChildren;

  Itinerary():
      itineraryChildren = [];

  Itinerary.fromJSON(final dynamic json):
    id = json['id'],
    description = json['description'],
    driverId = json['driverId'],
    itineraryChildren = List<ItineraryChild>
      .from(json['itineraryChildren']
      .map((item) => ItineraryChild.fromJSON(item)).toList());

    Itinerary.copy(final Itinerary itinerary):
      id = itinerary.id,
      description = itinerary.description,
      driverId = itinerary.driverId,
      itineraryChildren = List.unmodifiable(itinerary.itineraryChildren.map((item) => ItineraryChild.copy(item)).toList());

  static Map<String, dynamic> toJSON(final Itinerary itinerary) =>
    {
      'id': itinerary.id,
      'description': itinerary.description,
      'driverId': itinerary.driverId,
      'itineraryChildren': _setItineraryChildrenToJSON(itinerary.itineraryChildren),
    };


  static List<Map<String, dynamic>> _setItineraryChildrenToJSON(final List<ItineraryChild> itineraryChild) =>
    itineraryChild.map((item) => ItineraryChild.toJSON(item)).toList();

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();
    buffer.write('Intinerary: ');
    buffer.write('{ ');
    buffer.write('id: $id, ');
    buffer.write('description: "$description", ');
    buffer.write('driverId: $driverId, ');
    buffer.write('itineraryChildren: [ ');
    itineraryChildren.forEach((item) => buffer.write('${item.toString()}, '));
    buffer.write(' ]}');
    return buffer.toString();
  }
}

class ItineraryChild {
  int order;
  Child child;

  ItineraryChild.fromJSON(final dynamic json):
    order = json['order'],
    child = Child.fromJSON(json['child']);

  ItineraryChild.copy(final ItineraryChild itineraryChild):
      order = itineraryChild.order,
      child = Child.copy(itineraryChild.child);

  ItineraryChild(final Child child, final int order):
      order = order,
      child = child;

  static Map<String, dynamic> toJSON(final ItineraryChild itineraryChild) =>
    {
      'order': itineraryChild.order,
      'child': Child.toJSON(itineraryChild.child),
    };

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();
    buffer.write('ItineraryChild: ');
    buffer.write('order: $order, ');
    buffer.write('child: ${child.toString()}, ');
    buffer.write('}');
    return buffer.toString();
  }
}
