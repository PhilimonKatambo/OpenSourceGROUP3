import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Chat(
      roomName: 'warge',
      sender: "philimon",
    ),
  ));
}

class Chat extends StatefulWidget {
  final String roomName;
  final String sender;
  const Chat({required this.roomName, required this.sender});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _msg = TextEditingController();
  final ScrollController _scroll = ScrollController();
  List<Widget> WidgetList2 = [];

  @override
  void initState() {
    super.initState();
    recieveMSG(); // 👈 Start receiving messages
  }

  void sendMSG(String msg) async {
    try {
      DateTime now = DateTime.now();
      final DatabaseReference sender = FirebaseDatabase.instance.ref();
      sender.child(widget.roomName).push().set({
        "msg": msg,
        "sender": widget.sender,
        "time": DateFormat('hh:mm a').format(now)
      });
      _msg.clear();
    } catch (e) {
      print("Failed $e");
    }
  }

  void recieveMSG() async {
    try {
      final DatabaseReference receiver = FirebaseDatabase.instance.ref();

      receiver.child(widget.roomName).onChildAdded.listen((event) {
        final key = event.snapshot.key.toString();
        var data = event.snapshot.value;

        if (data != null && data is Map && data.containsKey("msg")) {
          String time = data["time"] ?? "";
          if (data["sender"] != widget.sender && data["sender"] != "start") {
            Update(data["msg"], time, "receive", data["sender"], key);
          } else {
            if (data["sender"] != "start") {
              Update(data["msg"], time, "send", data["sender"], key);
            }
          }
        }
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void Delete(String child1, String key1) async {
    final DatabaseReference deleter = FirebaseDatabase.instance.ref();
    await deleter.child("$child1/$key1").remove();
    setState(() {
      WidgetList2 = [];
    });
    recieveMSG();
  }

  void Update(String message, String time, String type, String sender, String key) {
    setState(() {
      WidgetList2.add(
        GestureDetector(
          onLongPress: () {
            showAlertDialog2(context, "This message will be deleted.", key);
          },
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: type == "receive"
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Container(
                  constraints: BoxConstraints(minWidth: 100, maxWidth: 250),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xff0f212d),
                    border: Border.all(color: Color(0xff0d2230), width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sender == widget.sender ? "You" : sender,
                        style: GoogleFonts.roboto(
                            color: Color(0xff41a7cd), fontSize: 10),
                      ),
                      Text(
                        message,
                        softWrap: true,
                        style: GoogleFonts.roboto(color: Color(0xffddded9)),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            time != "" ? time : "time unavailable",
                            style: GoogleFonts.roboto(
                                color: Color(0xff41a7cd), fontSize: 10),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      );
    });

    scrollToBottom();
  }

  void scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scroll.hasClients) {
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      }
    });
  }

  void showAlertDialog2(BuildContext context, String msg, String key) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Message"),
          content: Text(msg),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                Delete(widget.roomName, key);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _msg.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff081c24),
      appBar: AppBar(
        backgroundColor: Color(0xff0f212d),
        title: Text(widget.roomName.toUpperCase()),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scroll,
              padding: EdgeInsets.all(10),
              children: WidgetList2,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            color: Color(0xff0f212d),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msg,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Type message",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (_msg.text.trim().isNotEmpty) {
                      sendMSG(_msg.text.trim());
                    }
                  },
                  icon: Icon(Icons.send, color: Color(0xff41a7cd)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
