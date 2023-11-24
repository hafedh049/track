import 'package:em/objectbox.g.dart';
import 'package:em/operation_model.dart';

class ObjectBoxDatabase {
  late final Store _store;
  late final Box<OperationModel> _operationBox;
  ObjectBoxDatabase._init(this._store) {
    _operationBox = Box<OperationModel>(_store);
  }
  static Future<ObjectBoxDatabase> init() async {
    final Store store = await openStore();
    return ObjectBoxDatabase._init(store);
  }

  OperationModel? getOperation(int id) => _operationBox.get(id);
  Stream<List<OperationModel>> getAllOperations() => _operationBox.query().watch(triggerImmediately: true).map((query) => query.find());
  int addOperation(OperationModel operation) => _operationBox.put(operation);
  bool deleteOperation(int id) => _operationBox.remove(id);
}
