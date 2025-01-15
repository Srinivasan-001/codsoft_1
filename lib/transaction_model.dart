import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  late String reason;

  @HiveField(1)
  late double amount;

  @HiveField(2)
  late DateTime dateTime;

  @HiveField(3)
  late bool isIncome;
}
