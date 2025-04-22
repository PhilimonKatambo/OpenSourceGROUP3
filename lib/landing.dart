import 'package:firebase_database/firebase_database.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'inbox.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Colls(name: "priscillahdyson@gmail.com"),
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
  late String user2 = "loading....";

  @override
  void initState() {
    super.initState();
    Online1();

  }

  void Online1() async {
    print('Hello');
    try {
      final DatabaseReference reciever = FirebaseDatabase.instance.ref();
      reciever.onChildAdded.listen((event) async {
        var roomName = event.snapshot.key.toString().replaceAll("/", "_");
        Update(roomName);
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void Delete(child1)async{
    final DatabaseReference deleter=FirebaseDatabase.instance.ref();
    deleter.child(child1).remove().then((_){
      setState(() {
        coll=[];
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

  void Update(String roomName) async {
    setState(() {
      coll.add(
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Chat(roomName: roomName,sender: widget.name);
            }));
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.person),
                  color: Color(0xff0fd4fe),
                ),
                Column(children: [
                  Text(
                    roomName.toUpperCase(),
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        color: Color(0xff0fd4fe),
                        fontSize: 15,
                      ),
                    ),
                  ),
                ]),
                IconButton(
                  onPressed: () {
                    widget.name.toLowerCase()==roomName.toLowerCase()?Delete(roomName):showAlertDialog(context, "Can't delete others inboxes");
                  },
                  icon: Icon(
                    widget.name.toLowerCase()==roomName.toLowerCase()?Icons.delete:Icons.delete_forever_outlined,
                    color: Color(0xff2d87af),
                    size: 25,
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xff0f6c92)),
                top: BorderSide(color: Color(0xff0f6c92)),
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0b1c26),
      appBar: AppBar(
          backgroundColor: const Color(0xff0b1c26),
          leadingWidth: 0,
          title:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              "Online",
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(
                  color: Color(0xff0fd4fe),
                  fontSize: 30,
                ),
              ),
            ),
            Text(
              widget.name==''?"Loading...":widget.name.toUpperCase(),
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(
                  color: Color(0xff0fd4fe),
                  fontSize: 15,
                ),
              ),
            ),
          ])),
      body: SingleChildScrollView(
        child: coll.isEmpty?Center(
            child:Container(
                margin: EdgeInsets.only(top: 200),
                width:50,height:50,
                child:CircularProgressIndicator())):Container(
          width: double.infinity,
          child: Column(
            children: [...coll],
          ),
        ),
      ),
    );
  }
}