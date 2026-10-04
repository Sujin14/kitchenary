import 'package:flutter/widgets.dart';
import 'package:kitchenary/app.dart';
import 'package:kitchenary/services/hive_local_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await HiveLocalStore.open();
  runApp(KitchenaryApp(store: store));
}
