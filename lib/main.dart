import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'article.dart';
import 'recomendations.dart';
import 'profile.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';

int lang = 1;
int theme = 1;
int a = 0;



var name = "";
var userId = "";  

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
   try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
  final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user?.email)
        .get();
        
        name= querySnapshot.docs.first.data()['username'];
  runApp(AuthWrapper());//Login!!!!
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  Stream<User?> get userStream => _auth.authStateChanges();
  
  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }
  
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

/* class UserRepository {
  Future<void> persistUser(User user) async {
    // Сохраняем в SharedPreferences или другую локальную БД\
    final prefs = await SharedPreferences.getInstance();
    await 
  }
  
  Future<User?> getPersistedUser() async {
    // Получаем из локального хранилища
  }
} */

final user = FirebaseAuth.instance.currentUser;

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Показываем загрузку пока проверяем состояние аутентификации
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        if (snapshot.hasData) {

          // Пользователь авторизован
          return const MyApp();
        } else {
          // Пользователь не авторизован
          return const Login();
        }
      },
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isSmallScreen = screenWidth < 600 ? true:false;
    return MaterialApp(
      theme: theme == 1 ? ThemeData.light() : ThemeData.dark(),
      home: DefaultTabController(
        length: 3, 
        child: Scaffold(
          drawer: Drawer(
            child: Column(
              children: [
                Container(height: isSmallScreen ? 100:200, child: Center(child: Text("envelope",style: TextStyle(fontSize: 32.0,fontFamily: 'Inter',color: Color.fromARGB(255, 80, 44, 128),fontWeight: FontWeight.bold),),)),
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
            title: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20.0,right: screenWidth * 0.2,),
                  child: Text("envelope",style: TextStyle(fontSize: isSmallScreen ? 20.0 : 32.0,fontFamily: 'Inter',color: Color.fromARGB(255, 80, 44, 128),fontWeight: FontWeight.bold),),
                ),
                
              ],
            )
          ),
          bottomNavigationBar: BottomAppBar(
            height: 90,
            child: TabBar(
              
              tabs: [
                Center(child:Tab(icon: Icon(Icons.home,size: 40,),/* child: Text(lang == 0 ? 'Главная' : 'Home',style: TextStyle(fontSize: 15.0,fontFamily: 'Inter'),), */),),
                Center(child:Tab(icon: Icon(Icons.new_label,size: 40),/* child: Text(lang == 0 ? 'Создать' : 'Create',style: TextStyle(fontSize: 15.0, fontFamily: 'Inter'),), */),),
                Center(child:Tab(icon: Icon(Icons.person,size: 40),/* child: Text(lang == 0 ? 'Профиль' : 'Profile',style: TextStyle(fontSize: 15.0, fontFamily: 'Inter'),), */),)
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Recomendations(),
              Article(),
              Profile()
            ]
            ),
        )
        ),
    );
  }
}



