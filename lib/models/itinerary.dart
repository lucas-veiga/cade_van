import './child.dart';
import './model_exception.dart';

class Itinerary {
  int id;
  String description;
  ItineraryTypeEnum type;
  int driverId;
  List<ItineraryChild> itineraryChildren;

  Itinerary():
      itineraryChildren = [];

  Itinerary.fromJSON(final dynamic json):
    id = json['id'],
    description = json['description'],
    driverId = json['driverId'],
    type = _typeFromJSON(json['type']),
    itineraryChildren = List<ItineraryChild>
      .from(json['itineraryChildren']
      .map((item) => ItineraryChild.fromJSON(item)).toList());

    Itinerary.copy(final Itinerary itinerary):
      id = itinerary.id,
      description = itinerary.description,
      type = itinerary.type,
      driverId = itinerary.driverId,
      itineraryChildren = List.unmodifiable(itinerary.itineraryChildren.map((item) => ItineraryChild.copy(item)).toList());

  static Map<String, dynamic> toJSON(final Itinerary itinerary) =>
    {
      'id': itinerary.id,
      'description': itinerary.description,
      'type': _typeToJSON(itinerary.type),
      'driverId': itinerary.driverId,
      'itineraryChildren': _setItineraryChildrenToJSON(itinerary.itineraryChildren),
    };


  static List<Map<String, dynamic>> _setItineraryChildrenToJSON(final List<ItineraryChild> itineraryChild) =>
    itineraryChild.map((item) => ItineraryChild.toJSON(item)).toList();

  static ItineraryTypeEnum _typeFromJSON(final String type) {
    switch (type.trim().toUpperCase()) {
      case 'IDA':
        return ItineraryTypeEnum.IDA;
      case 'VOLTA':
        return ItineraryTypeEnum.VOLTA;
      default:
        throw ModelException('ItineraryTypeEnum nao encontrado | _typeFromJSON: $type');
    }
  }

  static String _typeToJSON(final ItineraryTypeEnum type) {
    switch (type) {
      case ItineraryTypeEnum.IDA:
        return 'IDA';
      case ItineraryTypeEnum.VOLTA:
        return 'VOLTA';
      default:
        throw ModelException('ItineraryTypeEnum nao encontrado | _typeToJSON: $type');
    }
  }

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();
    buffer.write('Intinerary: ');
    buffer.write('{ ');
    buffer.write('id: $id, ');
    buffer.write('description: "$description", ');
    buffer.write('driverId: $driverId, ');
    buffer.write('type: "$type", ');
    buffer.write('itineraryChildren: [ ');
    itineraryChildren.forEach((item) => buffer.write('${item.toString()}, '));
    buffer.write(' ]}');
    return buffer.toString();
  }
}

class ItineraryChild {
  int childOrder;
  Child child;

  ItineraryChild.fromJSON(final dynamic json):
      childOrder = json['order'],
    child = Child.fromJSON(json['child']);

  ItineraryChild.copy(final ItineraryChild itineraryChild):
      childOrder = itineraryChild.childOrder,
      child = Child.copy(itineraryChild.child);

  ItineraryChild(final Child child, final int childOrder):
      childOrder = childOrder,
      child = child;

  static Map<String, dynamic> toJSON(final ItineraryChild itineraryChild) =>
    {
      'childOrder': itineraryChild.childOrder,
      'child': Child.toJSON(itineraryChild.child),
    };

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();
    buffer.write('ItineraryChild: ');
    buffer.write('order: $childOrder, ');
    buffer.write('child: ${child.toString()}, ');
    buffer.write('}');
    return buffer.toString();
  }
}

enum ItineraryTypeEnum { IDA, VOLTA }

class DecodeItineraryTypeEnum {
  static String getDescription(ItineraryTypeEnum value) {
    switch (value) {
      case ItineraryTypeEnum.IDA:
        return 'Ida';
      case ItineraryTypeEnum.VOLTA:
        return 'Volta';
      default:
        throw ModelException('ItineraryTypeEnum nao encontrado | _getDescription: $value');
    }
  }
}
