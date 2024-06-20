import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter/pages/home.dart';
import 'package:twitter/pages/signUp.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter/pages/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:twitter/providers/user_provider.dart';
import 'firebase_options.dart';


void main () async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
   runApp( ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(
        brightness: Brightness.dark,
      
        appBarTheme: AppBarTheme(backgroundColor: Colors.transparent ,centerTitle: true, shadowColor: Colors.transparent),
        // primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            ref.read(userProvider.notifier).logIn(snapshot.data!.email!);
        return   const HomePage();
          }
          return const SignInPage(title: 'Twitter clone');
        }
      ),
    );
  }
}

