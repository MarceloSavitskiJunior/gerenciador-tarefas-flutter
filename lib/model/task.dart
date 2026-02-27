import 'package:intl/intl.dart';

class Task {
  static const ID = "_id";
  static const DESCRIPTION = "description";
  static const DELIVERY_AT = "delivery";

  int id;
  String description = "";
  DateTime? deliveryAt;

  Task({required this.id, required this.description, this.deliveryAt});

  String get formatedDeliveryAt{
    return deliveryAt != null
        ? DateFormat("dd/MM/yyyy").format(deliveryAt!)
        : "";
  }
}