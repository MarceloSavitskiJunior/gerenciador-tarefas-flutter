import 'package:intl/intl.dart';

class Task {
  static const TABLE_NAME = "task";
  static const ID = "_id";
  static const DESCRIPTION = "description";
  static const DELIVERY_AT = "delivery";

  int? id;
  String description = "";
  DateTime? deliveryAt;

  Task({this.id, required this.description, this.deliveryAt});

  String get formatedDeliveryAt{
    return deliveryAt != null
        ? DateFormat("dd/MM/yyyy").format(deliveryAt!)
        : "";
  }

  Map<String, dynamic> toMap() => <String, dynamic> {
    ID: id,
    DESCRIPTION: description,
    DELIVERY_AT: deliveryAt == null ? null : DateFormat('yyyy-MM-dd').format(deliveryAt!)
  };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
    id: map[ID] is int ? map[ID] : null,
    description: map[DESCRIPTION] is String ? map[DESCRIPTION] : '',
    deliveryAt: map[DELIVERY_AT] == null ? null :
      DateFormat("yyyy-MM-dd").parse(map[DELIVERY_AT])
  );
}