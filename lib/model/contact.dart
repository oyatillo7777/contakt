import 'package:hive/hive.dart';

part 'contact.g.dart';

@HiveType(typeId: 0)
class Contact {
  @HiveField(0)
  String ism;
  @HiveField(1)
  String number;

  Contact(this.ism, this.number);
}
