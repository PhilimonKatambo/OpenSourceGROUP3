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