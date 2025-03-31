import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'landing.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
  ));
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _email = TextEditingController();
  late List<String> rooms=[];

  @override
  void initState() {
    super.initState();
    Check();
  }

  void Check() async {
    print('Halla');
    try {
      final DatabaseReference reciever = FirebaseDatabase.instance.ref();
      reciever.onChildAdded.listen((event) async {
        var roomName = event.snapshot.key.toString().replaceAll("/", "_");
        print(roomName.toLowerCase());
        rooms.add(roomName.toLowerCase());
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void sendMSG(String msg) async{
    if(!rooms.contains(msg.toLowerCase())) {
      try {
        final DatabaseReference sender = FirebaseDatabase.instance.ref();
        sender.child(msg).push().set({
          "msg": "",
          "sender": "start"
        });
        print("msg sent");
        showAlertDialog(context, "Your group is online", "success", msg);
      } catch (e) {
        print("Failed $e");
      }
    }else{
      showAlertDialog(context, "The group name is already taken.\n You're online ", "success", msg);
    }
  }


  void showAlertDialog(BuildContext context, msg, type,per) {
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
                if(type=="success"){
                  Navigator.pop(context);
                  _email.clear();
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=>Colls(name: per))
                  );
                }else{
                  Navigator.pop(context);
                  _email.clear();

                }
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
      backgroundColor: const Color(0xff0b1c26),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Center(
                child: Text(
                  "Start",
                  style: GoogleFonts.roboto(
                      color: Color(0xff00b2fd),
                      fontSize: 42,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 100),
              Form(
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    TextFormField(
                      controller: _email,
                      decoration: InputDecoration(
                        hintText: "Enter your group name",
                        hintStyle: GoogleFonts.roboto(
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        suffixIcon: const Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                      style: GoogleFonts.roboto(
                        color: Color(0xff00b2fd),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        _email.text.trim()==''?showAlertDialog(context, "Enter somena", "",''):
                        sendMSG(_email.text.trim());
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff00b2fd),
                          foregroundColor: Color(0xff0b1c26),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 0)
                      ),

                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.login,
                            size: 30,
                            color: Colors.white,
                          ),
                          SizedBox(width: 20),
                          Text(
                            "See online",
                            style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
