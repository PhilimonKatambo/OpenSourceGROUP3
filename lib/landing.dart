import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'inbox.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Colls(name: "timoguy@gmail.com"),
  ));
}

class Colls extends StatefulWidget {
  final String name;
  const Colls({required this.name});

  @override
  State<Colls> createState() => _CollsState();
}

class _CollsState extends State<Colls> {
  List<Widget> coll = [];
  String user2 = "loading....";

  @override
  void initState() {
    super.initState();
    Online1();
  }

  void Online1() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/${widget.name}");

    final snapshot = await ref.get();
    if (snapshot.exists) {
      setState(() {
        user2 = snapshot.value.toString();
      });
    } else {
      setState(() {
        user2 = "No data available";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
      ),
      body: Center(
        child: Text(
          user2,
          style: GoogleFonts.poppins(fontSize: 20),
        ),
      ),
    );
  }
}
