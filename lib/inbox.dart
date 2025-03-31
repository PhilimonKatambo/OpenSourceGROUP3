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

  void recieveMSG() async{
    try{
      final DatabaseReference reciever=FirebaseDatabase.instance.ref();

      reciever.child(widget.roomName).onChildAdded.listen((event){
        final  key=event.snapshot.key.toString();
        var data = event.snapshot.value;
        if (data != null && data is Map && data.containsKey("msg")) {
          if(data["sender"]!=widget.sender && data["sender"]!="start") {
            Update(data["msg"],data["time"]!=null?data["time"]:"", "receive",data["sender"],key);
            scrollToBottom();
          }else{
            if(data["sender"]!="start") {
              Update(data["msg"],data["time"]!=null?data["time"]:"","send",data["sender"],key);
              scrollToBottom();
            }
          }
        } else {
          print("Halla");
        }
      });
    }catch(e){
      print("Error: $e");
    }
  }

  void Delete(child1,key1)async{
    print(key1);
    final DatabaseReference deleter=FirebaseDatabase.instance.ref();
    deleter.child("$child1/$key1").remove().then((_){
      setState(() {
        WidgetList2=[];
      });
      recieveMSG();
    });
  }

  void Update(message,time,type,sender,key) {
    setState(() {
      scrollToBottom();
      WidgetList2.add(
        GestureDetector(
          onLongPress: (){
            showAlertDialog2(context, "This message is going to be deleted", key);
          },
        child:Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            crossAxisAlignment: type == "receive"
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              Container(
                constraints: BoxConstraints(minWidth:100,maxWidth: 250),
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sender==widget.sender?"You":sender,
                      style: GoogleFonts.roboto(color: Color(0xff41a7cd),fontSize: 10),
                    ),
                    Text(
                      message,
                      softWrap: true,
                      style: GoogleFonts.roboto(
                        color: Color(0xffddded9),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          time!=""?time:"time unavailable",
                          style: GoogleFonts.roboto(color: Color(0xff41a7cd),fontSize: 10),
                        )
                      ],
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Color(0xff0f212d),
                  border: Border.all(color: Color(0xff0d2230), width: 1),
                  borderRadius: BorderRadius.circular(10),
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

  void showAlertDialog2(BuildContext context, msg,key) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Notice"),
          content: Text(msg),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("OK"),
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

  late double contH=0.8;
  void changeContHieght(){
    setState(() {
      contH=0.4;
    });
  }
  void changeContHieght1(){
    setState(() {
      contH=0.8;
    });
  }

  void scrollToBottom() {
    _scroll.animateTo(
      _scroll.position.extentTotal,
      duration: Duration(seconds: 2),
      curve: Curves.easeOut,
    );
  }

  void scrollTop() {
    _scroll.animateTo(
      _scroll.position.minScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.easeOut,
    );
  }

  @override
  void initState() {
    super.initState();
    recieveMSG();
    _scroll.addListener(_checkScroll);
  }

  bool _isAtBottom = false;

  void _checkScroll() {
    if (_scroll.position.pixels == _scroll.position.maxScrollExtent) {
      setState(() {
        _isAtBottom = true;
      });
      print("Reached Bottom!");
    } else {
      setState(() {
        _isAtBottom = false;
      });
    }
  }

  final List<String> Names=[""];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0b1c26),
      appBar: AppBar(
        backgroundColor: const Color(0xff0b1c26),
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: const Color(0xff00b2fd),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text(
                widget.roomName,
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
      body: Stack(
    children: [
    SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * contH,
              width: double.infinity,
              child: SingleChildScrollView(
                controller: _scroll,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(20),
                          child: Text(
                            "Telling you the truth guys your messages are not end to end encrypted! Don't even try to propose to your crush!. You gonna be exposed, am telling you the truth!",
                            style: GoogleFonts.roboto(
                                color: Color(0xff00b2fd),
                                fontSize: 10,
                                fontWeight: FontWeight.normal),
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xff0f212d),
                            border: Border.all(color: Color(0xff0d2230), width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text(
                                "Unnecessary, never mind!\n\n"
                                "1. Programming isn't about what you know; it's about what you can figure out: CHRIS PINE\n\n"
                                    "2: First, solve the problem. Then, write the code: JOHN JOHNSON\n\n"
                                    "3. If you don’t know where you’re going, any road will get you there: LEWIS CARROLL",
                                style: GoogleFonts.roboto(
                                    color: Color(0xff00b2fd),
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xff0f212d),
                            border: Border.all(color: Color(0xff0d2230), width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        SizedBox(height: 10),
                        ...WidgetList2,
                      ]),
                ),
              ),
            ),

            Container(
              height: MediaQuery.of(context).size.height * 0.08,
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Color(0xff0b1c26),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(

                      onTap: (){
                        //changeContHieght();
                        scrollToBottom();
                      },
                      controller: _msg,
                      decoration: InputDecoration(
                        labelText: "Enter your message",
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.indigo, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff00b2fd),
                            width: 1.0,
                          ),
                        ),
                      ),
                      style: GoogleFonts.roboto(
                        color: Color(0xffddded9),
                      ),
                    ),
                  ),
                  SizedBox(width: 2),
                  IconButton(
                    onPressed: () {
                      sendMSG(_msg.text.trim());
                      _msg.clear();
                     // changeContHieght1();
                      scrollToBottom();
                    },
                    icon: Icon(
                      Icons.send,
                      size: 30,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff0b1c26),
                      foregroundColor: Color(0xff00b2fd),
                      padding: EdgeInsets.all(0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      Positioned(
        bottom: MediaQuery.of(context).size.height * 0.15,
          right: MediaQuery.of(context).size.width * 0.0,
          child: _isAtBottom==false?IconButton(
            onPressed: () {
              if(WidgetList2.isNotEmpty){
                scrollToBottom();
              }
            },

            icon:  Icon(
              Icons.arrow_circle_down_sharp,
              size: 25,
              color: Color(0xff00b2fd),
            ),
          ):IconButton(
            onPressed: () {
              if(WidgetList2.isNotEmpty){
                scrollTop();
              }
            },

            icon:  Icon(
              Icons.arrow_circle_up,
              size: 25,
              color: Color(0xff00b2fd),
            ),
          )

         )
      ]
      ),
    );
  }
}
