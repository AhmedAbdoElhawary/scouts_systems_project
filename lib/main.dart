import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouts_system/home_screen.dart';
import 'package:scouts_system/view%20model/events.dart';
import 'package:scouts_system/view%20model/seasons.dart';
import 'package:scouts_system/view%20model/studentsGetDataFirestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventsGetDataFirestore()),
        ChangeNotifierProvider(create: (_) => DBSeasons()),
        ChangeNotifierProvider(create: (_) => StudentsGetDataFirestore()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<StudentsGetDataFirestore>().getAllStudentsData();
    context.read<EventsGetDataFirestore>().getAllEventsData();
    context.read<DBSeasons>().getAllSeasonsData();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scouts App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
