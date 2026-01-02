import 'package:bd_flutter/login.dart';
import 'package:bd_flutter/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
  runApp(Registration());
}

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

final TextEditingController1 = TextEditingController();
final TextEditingController2 = TextEditingController();
final TextEditingController3 = TextEditingController();
final TextEditingController4 = TextEditingController();
var er = "";
var f = 0;
class _RegistrationState extends State<Registration> {
  double value = 0;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isSmallScreen = screenWidth < 600? true:false;
    return MaterialApp(
      theme: theme == 1 ? ThemeData.light() : ThemeData.dark(),
      home: Scaffold(
        
        body: Center(
          child: Container(
          padding: EdgeInsets.only(left: screenWidth * 0.05,right: screenWidth * 0.05),
          width: isSmallScreen ? screenWidth * 0.9 : screenWidth * 0.4,
          height: screenHeight * 0.8,
          child:  Form(
          child: Column(
            children: [
              Container(child: Center(child: Text("envelope", style: TextStyle(fontSize: isSmallScreen ? 35.0 : 50.0,fontWeight: FontWeight.bold),),),margin: EdgeInsets.only(top: screenHeight*0.01,bottom: screenHeight * 0.02),),
              Container(margin: EdgeInsets.only(bottom: screenHeight * 0.02),child:Center(child: Text(lang == 1 ?"Registration": "Регистрация",style: TextStyle(fontSize: 30.0),),),),
              Container(              
                margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                child: TextFormField(
                  controller: TextEditingController1,
                  validator: (inValue) {
                    if (inValue == null|| inValue.isEmpty) {return "Enter any text";}else{return null;}
                  },
                  decoration: InputDecoration(
                    hintText: lang == 1 ?'Email': "Почта",
                    labelText: lang == 1 ?'Enter your Email' : "Введите свою почту",
                  )
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                child: TextFormField(
                  controller: TextEditingController2,
                  validator: (inValue) {
                    if (inValue == null|| inValue.isEmpty) {return "Enter any text";}else{return null;}
                  },
                  decoration: InputDecoration(
                    hintText: lang == 1 ?'Username': "Имя",
                    labelText: lang == 1 ?'Enter your username': "Введите свое имя"
                  )
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                child: TextFormField(
                  controller: TextEditingController3,
                  validator: (inValue) {
                    if (inValue == null|| inValue.isEmpty) {return "Enter any text";}else{return null;}
                  },
                  decoration: InputDecoration(
                    hintText: lang == 1 ?'Password': "Пароль",
                    labelText: lang == 1 ?'Enter your password': "Введите свой пароль"
                  )
                ),
              ),
              Container(
                child: TextFormField(
                  controller: TextEditingController4,
                  validator: (inValue) {
                    if (inValue == null|| inValue.isEmpty) {return "Enter any text";}else{return null;}
                  },
                  decoration: InputDecoration(
                    hintText: lang == 1 ?'Repeat': "Повторите",
                    labelText: lang == 1 ?'Repeat password': "Повторите пароль"
                  )
                ),
              ),
              Container(child: Text("$er",style: TextStyle(color: Colors.red,fontSize: 20.0),textAlign: TextAlign.center,),margin: EdgeInsets.all(20.0),),
              GestureDetector(
                onTap: () async {
    final email = TextEditingController1.text.trim();
    final username = TextEditingController2.text.trim();
    final password = TextEditingController3.text.trim();
    final confirmPassword = TextEditingController4.text.trim(); // если есть подтверждение
  if(password==confirmPassword && username.isNotEmpty){
    if (password.length<6){
      setState(() {
        er = "Password must be 6 or more characters long";
      });
    } else{
      try {
        setState(() {
          f = 1;
        });
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => (MyApp())));
     await FirebaseFirestore.instance
      .collection('users')
      .doc()
      .set({
        'username': username,
        'email': email,
        
      });
    setState(() {
      er = '';
      name = username;
      var id = credential.user?.uid;
      userId = '$id';
    });
  } on FirebaseAuthException catch (e) {
    setState(() {
      er = "$e";
    });
  
    } catch (e) {
      setState(() {
        er = 'Error';
      });
    }
    }
    
  } else{
    setState(() {
      er = 'Error. Try again';
    });
  }

    
  },
                child: Container(
                  width: 150.0,
                  height: 50.0,
                  
                  padding: EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 40, 40, 44),
                    borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: Center(child: f == 0 ? Text(lang == 1 ? "Create" : "Создать",style: TextStyle(fontSize: 30.0,color: Colors.white),): CircularProgressIndicator(),)
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: Text(lang == 1 ? "Back" : "Назад",style: TextStyle(fontSize: 20.0,color: Colors.blue),),
                )
              )
            ],
          )
          
          )
        ),
        )
      ),
    );
  }
}