import 'package:bd_flutter/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'registration.dart';
import 'package:firebase_auth/firebase_auth.dart';

var al = false;
var f = 0;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
   try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
  runApp(Login());
}

final textEditingController1 = TextEditingController();
final textEditingController2 = TextEditingController();
var er2 = "";

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isSmallScreen = screenWidth < 600 ? true:false;
    return MaterialApp(
      theme: theme == 1 ? ThemeData.light() : ThemeData.dark(),
      home: Scaffold(
        drawer: Drawer(
            child: Column(
              children: [
                Container(height:200.0, child: Center(child: Text("envelope",style: TextStyle(fontSize: 32.0,fontFamily: 'Inter',color: Color.fromARGB(255, 80, 44, 128),fontWeight: FontWeight.bold),),)),
                Divider(),
                GestureDetector(
                  onTap: () {
                    if (lang==0){
                      setState(() {
                        lang = 1;
                      });
                      
                    } else {
                      setState(() {
                        lang = 0;
                      });
                      
                    }
                  },
                  child: Container(
                    
                    
                    height: 40.0,
                    child: Text(lang == 1 ? "Change language" : "Поменять язык",style: TextStyle(fontSize: 20.0,fontFamily: 'Inter',fontWeight: FontWeight.bold),
                  ),
                )),
                Divider(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      theme == 0 ? theme = 1: theme = 0;
                    });
                  },
                  child: Container(
                    
                    height: 40.0,
                    child: Text(lang == 1 ? "Change theme" : "Сменить тему",style: TextStyle(fontSize: 20.0,fontFamily: 'Inter',fontWeight: FontWeight.bold),
                  ),
                )),
                Divider()
                /* GestureDetector(
                  onTap: () {
                    if (lang==0){
                      setState(() {
                        lang = 1;
                      });
                      
                    } else {
                      setState(() {
                        lang = 0;
                      });
                      
                    }
                  },
                  child:Container(
                    margin: EdgeInsets.only(top: 50.0,right: 45.0),
                    width: 200.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: theme == 1 ? Color.fromARGB(255, 80, 44, 128) : Color.fromARGB(255, 89, 87, 199),
                      /* gradient: const LinearGradient(
        colors: [Color.fromARGB(255, 80, 44, 128),  Color.fromARGB(255, 89, 87, 199),]), */
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(width: 1.0,color: Colors.black)
                    ),
                    child: Center(child: Text(lang == 1 ? "Change language" : "Поменять язык",style: TextStyle(fontSize: 20.0,fontFamily: 'Inter',color: Color.fromARGB(255, 255, 255, 255),fontWeight: FontWeight.bold),)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 50.0,right: 45.0),
                    width: 200.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 80, 44, 128),
                      gradient: theme == 1 ?const LinearGradient(
        colors: [Color.fromARGB(255, 80, 44, 128),  Color.fromARGB(255, 230,230,230),]):const LinearGradient(
        colors: [Color.fromARGB(255, 89, 87, 199),  Color.fromARGB(255, 0,0,0),]),
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(width: 1.0,color: Colors.black)
                    ),
                    child: Center(child: Text(lang == 1 ? "Change theme" : "Сменить тему",style: TextStyle(fontSize: 20.0,fontFamily: 'Inter',color: Color.fromARGB(255, 255, 255, 255),fontWeight: FontWeight.bold),),)
                  ),
                ) */
              ],
            ),                                                                                                                 
          ),
        appBar: AppBar(
          toolbarHeight: 100.0,
          title: Container(
            margin: EdgeInsets.only(top: screenHeight*0.05,right: 50.0, bottom: screenHeight * 0.1),
            child: Center(child: Text("envelope", style: TextStyle(fontSize: isSmallScreen ? 35.0 : 50.0,fontWeight: FontWeight.bold),),)
          ),
        ),
        body: Form(
          child: Center(
            child: Container(
              margin: EdgeInsets.only(bottom: screenHeight * 0.1),
            padding: EdgeInsets.all(20.0),
            width: isSmallScreen ? screenWidth * 0.9 : screenWidth * 0.4,
            height: screenHeight * 0.75,
            child: Column(
            children: [
              
              Text(lang == 1 ?"Log in": "Войти",style: TextStyle(fontSize: 30.0),),
              Container(height: 10.0,),
              Container(
                child: TextFormField(
                controller: textEditingController1,
                validator: (inValue) {
                  if (inValue == null || inValue.isEmpty == true){return 'Enter any text';}else{return null;}
                },
                decoration: InputDecoration(
                  hintText: lang == 1 ?"Email": "Почта",
                  labelText: lang == 1 ?'Enter your email' : "Введите свою почту"
                ),
              ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0),
                child: TextFormField(
                controller: textEditingController2,
                validator: (inValue) {
                  if (inValue == null || inValue.isEmpty == true){return 'Enter any text';}else{return null;}
                },
                decoration: InputDecoration(
                  hintText: lang == 1 ?"Password": "Пароль",
                  labelText: lang == 1 ?'Enter your password': "Введите свой пароль"
                ),
              ),
              ),
              Gest2(),
              Gest(),
              Txt(),
              al ? CircularProgressIndicator() : Container(),
              f == 0? Container() : Text(lang == 1 ? "Not found. Try again" : "Не найдено. Попробуйте еще раз",style: TextStyle(fontSize: 30.0, color: Color.fromARGB(255, 255, 0, 0)))
            ],
          ),
            ),
          )
        )
      ),
    );
  }
}

class Gest extends StatelessWidget {
  const Gest({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
                  child: GestureDetector(
                    child: Text(lang == 1 ?"Haven't account? Create": "Нет аккаунта? Создать",style: TextStyle(color: Colors.blue,fontSize: 15.0),),
                    onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Registration()))},
                  ),
              margin: EdgeInsets.only(top: 15.0),
              );
  }
}

class Gest2 extends StatefulWidget {
  const Gest2({super.key});

  @override
  State<Gest2> createState() => _Gest2State();
}

class _Gest2State extends State<Gest2> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
               onTap: () async {
        if (textEditingController1.text.isEmpty || textEditingController2.text.isEmpty) {
          setState(() {
            er = "Full all fields";
          });
          return;
        }
        try{
          setState(() {
            al = true;
          });
          final email = textEditingController1.text;
          final password = textEditingController2.text;
           final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
        
        String usernam = querySnapshot.docs.first.data()['username'];
        String id_e = querySnapshot.docs.first.data()['id'];
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
          final user = FirebaseAuth.instance.currentUser;
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
    setState(() {
      name = usernam;
      userId = '$id_e';
    });
  
  } on FirebaseAuthException catch (e) {
    setState(() {
      er = '$e';
      al = false;
      f = 1;
    });
    return null;
  } catch (e) {
    setState(() {
      al = false;
      er = 'Error';
      f = 1;
      
    }
    
    );
    print(e);
    return null;
  }
      },
                child: Container(
                  width: 150.0,
                  height: 50.0,
                  margin: EdgeInsets.only(top: 15.0),
                  padding: EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 40, 40, 44),
                    borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: Center(child: al ? CircularProgressIndicator() : f != 0 ? Text(lang == 1 ?"Error":"Ошибка", style: TextStyle(color: Colors.red,fontSize: 30.0,),) : Text(lang == 1 ? "Go" : "Вперед",style: TextStyle(fontSize: 30.0,color: Colors.white),),)
                ),
              );
  }
}

class Txt extends StatefulWidget {
  const Txt({super.key});

  @override
  State<Txt> createState() => _TxtState();
}

class _TxtState extends State<Txt> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: Text("$er2", style: TextStyle(color: Colors.red),),
    );
  }
}