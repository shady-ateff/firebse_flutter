import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskat_app/cubit/task_cubit.dart';
import 'package:taskat_app/firebase_options.dart'; 
import 'package:taskat_app/screens/home.dart';
import 'package:taskat_app/services/firebase_services.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
); 
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
    create: (context) =>
        TaskCubit(FirebaseServicee())..getTasks(),

    child:   MaterialApp(
        useInheritedMediaQuery: true,
  locale: DevicePreview.locale(context),
  builder: DevicePreview.appBuilder,
      
      home: Home(),
    )
    );
  }
} 
