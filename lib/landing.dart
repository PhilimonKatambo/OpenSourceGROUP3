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
    Online1(); // Only one Online1() method now
  }

  // ✅ The correct version of Online1
  void Online1() async {
    print('Hello');
    try {
      final DatabaseReference receiver = FirebaseDatabase.instance.ref();

      receiver.onChildAdded.listen((event) async {
        var roomName = event.snapshot.key.toString().replaceAll("/", "_");
        Update(roomName);
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  // ✅ Stub for Update() to avoid error. You can define the real logic later.
  void Update(String roomName) {
    print("Room name: $roomName");
  }

  void Delete(String child1) async {
    final DatabaseReference deleter = FirebaseDatabase.instance.ref();
    deleter.child(child1).remove().then((_) {
      setState(() {
        coll = [];
      });
      Online1();
    });
  }

  void showAlertDialog(BuildContext context, msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Notice"),
          content: Text(msg),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
