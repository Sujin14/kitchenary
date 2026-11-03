import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:kitchenary/app.dart';
import 'package:kitchenary/services/hive_local_store.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final store = await HiveLocalStore.open();
  FlutterNativeSplash.remove();
  runApp(KitchenaryApp(store: store));
}
