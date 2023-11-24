import 'dart:typed_data';

import 'package:objectbox/objectbox.dart';

@Entity()
class OperationModel {
  @Id()
  int id;
  DateTime operationDate;
  String title;
  String amount;
  String currency;
  String nature;
  Uint8List picture;

  OperationModel({required this.operationDate, required this.title, required this.amount, required this.currency, required this.nature, required this.picture, this.id = 0});
}
