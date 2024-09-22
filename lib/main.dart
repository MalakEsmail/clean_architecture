import 'package:clean_arch_pro/random_quote_app.dart';
import 'package:flutter/material.dart';
import 'injection_container.dart' as inj;
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
 await inj.init();
  runApp(const RandomQuoteApp());
}


