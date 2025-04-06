import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Chat(
        roomName:'warge',
        sender:"philimon"
    ),
  ));
}

class Chat extends StatefulWidget {
  final String roomName;
  final String sender;
  Chat({required this.roomName, required this.sender});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _msg = TextEditingController();
  final ScrollController _scroll=ScrollController();
  List<Widget> WidgetList2 = [];


  void sendMSG(String msg) async{
    try {
      DateTime now=DateTime.now();
      final DatabaseReference sender = FirebaseDatabase.instance.ref();
      sender.child(widget.roomName).push().set({
        "msg":msg,
        "sender":widget.sender,
        "time":DateFormat('hh:mm a').format(now)
      });
      print("msg sent");
      //Update(msg, "send");
    }catch(e){
      print("Failed $e");
    }
  }