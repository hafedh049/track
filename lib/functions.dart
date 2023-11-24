import 'package:em/operation_model.dart';

double calculateIncome(List<OperationModel> operations) {
  double tot = 0;
  for (OperationModel operation in operations) {
    if (operation.currency == "\$") {
      if (operation.nature == "+") {
        tot += double.parse(operation.amount) * 3.3611;
      } else {
        tot -= double.parse(operation.amount) * 3.3611;
      }
    }
    if (operation.currency == "£") {
      if (operation.nature == "+") {
        tot += double.parse(operation.amount) * 3.92;
      } else {
        tot -= double.parse(operation.amount) * 3.92;
      }
    }
    if (operation.currency == "€") {
      if (operation.nature == "+") {
        tot += double.parse(operation.amount) * 3.13;
      } else {
        tot -= double.parse(operation.amount) * 3.13;
      }
    } else {
      if (operation.nature == "+") {
        tot += double.parse(operation.amount);
      } else {
        tot -= double.parse(operation.amount);
      }
    }
  }
  return tot;
}
