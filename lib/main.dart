import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouts_system/HomeScreen.dart';
import 'package:scouts_system/view%20model/eventsGetDataFirestore.dart';
import 'package:scouts_system/view%20model/seasonsGetDataFirestore.dart';
import 'package:scouts_system/view%20model/studentsGetDataFirestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => EventsGetDataFirestore()),
        ChangeNotifierProvider(
            create: (_) => SeasonsGetDataFirestore()),
        ChangeNotifierProvider(
            create: (_) => StudentsGetDataFirestore()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    context.read<StudentsGetDataFirestore>().getAllStudentsData();
    context.read<EventsGetDataFirestore>().getAllEventsData();
    context.read<SeasonsGetDataFirestore>().getAllSeasonsData();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
