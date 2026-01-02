import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'recomendations.dart';
import 'firebase_options.dart';
import 'main.dart';
Future<List<Map<String, dynamic>>> _getYourItems() async {

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final items = await _firestore.collection('articles').where('username',isEqualTo: name)
    .limit(10000)
    .get();
return items.docs.map((doc) {
   final data = doc.data();
    return {
      'name': data['name']?.toString() ?? 'Без названия', // ДОБАВЛЕНО поле name
      'bio': data['bio']?.toString() ?? 'отсутствует',
      'code': data['code']?.toString() ?? 'отсутствует',
      'lang': data['lang']?.toString() ?? 'отсутствует',
      'username': data['username']?.toString() ?? 'отсутствует',
      'id': data["id"], // ДОБАВЛЕНО ID документа
    };
  }).toList();}

Future<List<Map<String, dynamic>>> _getFavItems() async {
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final likes = await _firestore.collection('likes').where('user_id',isEqualTo: userId)
    .limit(10)
    .get();
final artIds = likes.docs.map((doc) => doc['art_id']).toList();
  if (artIds.isEmpty) return [];
final articles = await _firestore.collection('articles') // предполагается, что арты хранятся в коллекции 'arts'
      .where(FieldPath.documentId, whereIn: artIds)
      .get();
return articles.docs.map((doc) {
    return {
      'art_id': doc.id,
      'data': doc.data()
    };
  }).toList();}

  

void main() async{
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
  runApp(MaterialApp(
    home: Scaffold(
      body: Profile(),
    ),
  ));
}

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400.0,
      padding: EdgeInsets.all(10.0),
      child: Column(
      children: [
       
        Container(
          child: Row(
            children: [
              
              Container(
                          child: Align(
                          alignment: Alignment.centerLeft,
                          
                            child: Container(
                            margin: EdgeInsets.all(30.0),
                            child: Text(
                            name,
                            style: TextStyle(
                              fontSize: 32.0,
                              
                            ),
                            ),
                          ),
                          /* Container(
                            margin: EdgeInsets.only(top: 40.0,bottom: 40.0),
                            child: Text(
                            '$art_name',
                            style: TextStyle(
                              fontSize: 32.0,
                              fontFamily: "Inter"
                            ),
                            ),
                          ), */
                        ),  
                        ),
            ],
          ),
        ),
        
        Expanded(child: 
         Container(
          child: DefaultTabController(length: 2, child: Scaffold(
            appBar: TabBar(tabs: [
              /* Text(lang == 1 ? "Favorite" : "Понравившееся",style: TextStyle(fontSize: 20.0,fontFamily: "Inter"),),
              Text(lang == 1 ? "My" : 'Мое',style: TextStyle(fontSize: 20.0,fontFamily: "Inter"),), */
              Icon(Icons.favorite_outline,size: 32.0,color: Color.fromARGB(255, 80, 44, 128),),
              Icon(Icons.article_outlined,size: 32.0,)
            ]),
            body: TabBarView(children: [
              Favorite(),
              Your()
            ]),
          ),)
         )
        )
      ],
    ),
    );
  }
}

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getFavItems(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Container(
              width: 100.0,
              height: 100.0,
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasError) {
      return Text(lang == 0 ?'Ошибка загрузки' : 'Loading error');
    }
      return ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index){
          final art = snapshot.data![index];
          String art_id = art['art_id'];
          return Container(
            padding: EdgeInsets.only(right: 10.0,left: 10.0),
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),

                              color: Color.fromARGB(50, 216, 117, 255) 
                              /* 117, 131, 255 синий */
                              /* 216, 117, 255 фиолетовый */
                            ),
                      child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          
                            child: Container(
                            margin: EdgeInsets.all(30.0),
                            child: Text(
                            art['data']['username'],
                            style: TextStyle(
                              fontSize: 32.0,
                              fontFamily: "Inter"
                            ),
                            ),
                          ),
                          /* Container(
                            margin: EdgeInsets.only(top: 40.0,bottom: 40.0),
                            child: Text(
                            '$art_name',
                            style: TextStyle(
                              fontSize: 32.0,
                              fontFamily: "Inter"
                            ),
                            ),
                          ), */
                        ),  
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 30.0,bottom: 20.0 ),
                          width: screenWidth * 0.7,
                          child: Text(
                          art['data']['bio'],
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontFamily: "Inter",
                          ),
                          ),
                        ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          padding: EdgeInsets.only(left: 5.0, right: 5.0),
                          height: 200.0,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 80, 44, 128),
                            borderRadius: BorderRadius.circular(20.0)
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: EdgeInsets.only(top: 10.0,left: 20.0),
                                  child: Text(art['data']['lang'],style: TextStyle(fontSize: 15.0,color: Colors.white,fontFamily: 'Inter'),),
                                ),
                              ),
                              GestureDetector(
                                child: Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: Align(
                            child: Text(
                              maxLines: 5, // Ограничение до 3 строк
                             overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 15.0,color: Colors.white),
                              
                            textAlign: TextAlign.start,
                            art['data']['code']
                          ),
                          alignment: Alignment.topCenter,
                          ),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext) => MaterialApp(
                              home: Scaffold(
                                body: ListView(
      children: [
        Container(
          margin: EdgeInsets.only(top: 50.0,left: 10.0,right: 10.0,bottom: 10.0),
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 80, 44, 128),
            borderRadius: BorderRadius.circular(20.0)
          ),
          child: Text(art['data']['code'],textAlign: TextAlign.start,style: TextStyle(fontSize: 15.0,color: Colors.white),),
        ),
        GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 40.0),
                  child: Text(lang == 1 ? "Back" : "Назад",style: TextStyle(fontSize: 20.0,color: Colors.blue),textAlign: TextAlign.center,),
                )
              )
      ],
    ),
                              ),
                            )));
                            
                          },
                              )],
                          )
                        ),
                         Container(
                                margin: EdgeInsets.only(
                                    right: 250.0, bottom: 5.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          final likeExists =
                                              FirebaseFirestore.instance
                                                  .collection('likes')
                                                  .doc("$art_id" + "$userId");
                                          final doc = await likeExists.get();

                                          if (doc.exists == false) {
                                            String docId = art_id + userId;
                                            await FirebaseFirestore.instance
                                                .collection('likes')
                                                .doc(docId)
                                                .set({
                                              'user_id': userId,
                                              'art_id': art_id,
                                            });
                                          } else {
                                            await likeExists.delete();
                                          }
                                        },
                                        icon: StreamBuilder<DocumentSnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('likes')
                                              .doc("$art_id" + "$userId")
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return Container();
                                            }
                                            return Icon(
                                              snapshot.data!.exists
                                                  ? Icons.favorite
                                                  : Icons.favorite_outline,
                                              color: snapshot.data!.exists
                                                  ? Colors.red
                                                  : null,
                                              size: 32.0,
                                            );
                                          },
                                        ),
                                      ),
                                      IconButton(
  onPressed: () {
    late Future<List<Map<String, dynamic>>> _commentsFuture = _getCommentaries(art_id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Commentaries(art_id: art_id, lang: lang)
      ),
    );
  },
  icon: Icon(Icons.comment),
),
                                    ],
                                  ),
                                ),
                              ),
                      ],
                    ),
                    ),
                        );
        }
        );
      }
      );
  }
}

class Your extends StatefulWidget {
  const Your({super.key});
  
  @override
  State<Your> createState() => _YourState();
}

class _YourState extends State<Your>{
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder<List<Map<String, dynamic>>>(
  future: _getYourItems(),
  builder: (context, snapshot) {
     print('ConnectionState: ${snapshot.connectionState}');
    print('HasError: ${snapshot.hasError}');
    print('Error: ${snapshot.error}');
    print('HasData: ${snapshot.hasData}');
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(
        child: Container(
        width: 100,
        height: 100,
        child:  CircularProgressIndicator(),
      ),
      );
    }
    if (snapshot.hasError) {
      return Text('Ошибка загрузки');
    }
    return ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        final article = snapshot.data![index];
        String art_name = article["name"];
        String art_code = article["code"];
        String art_lang = article["lang"];
        String art_username = article[
          'username'
        ];
        String art_bio = article['bio'];
        String art_id = article['id'];
                      return Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          padding: EdgeInsets.only(right: 10.0,left: 10.0),
                          child: Card(
                      child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          
                            child: Container(
                            margin: EdgeInsets.all(30.0),
                            child: Text(
                            '$art_username',
                            style: TextStyle(
                              fontSize: 32.0,
                              fontFamily: "Inter"
                            ),
                            ),
                          ),
                          /* Container(
                            margin: EdgeInsets.only(top: 40.0,bottom: 40.0),
                            child: Text(
                            '$art_name',
                            style: TextStyle(
                              fontSize: 32.0,
                              fontFamily: "Inter"
                            ),
                            ),
                          ), */
                        ),  
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 30.0,bottom: 20.0 ),
                          width: screenWidth * 0.7,
                          child: Text(
                          '$art_bio',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontFamily: "Inter",
                          ),
                          ),
                        ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          padding: EdgeInsets.only(left: 10.0,right: 10.0),
                          height: 200.0,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 80, 44, 128),
                            borderRadius: BorderRadius.circular(20.0)
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: EdgeInsets.only(top: 10.0,left: 20.0),
                                  child: Text("$art_lang",style: TextStyle(fontSize: 15.0,color: Colors.white,fontFamily: 'Inter'),),
                                ),
                              ),
                              GestureDetector(
                                child: Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: Align(
                            child: Text(
                              maxLines: 5, // Ограничение до 3 строк
                             overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 15.0,color: Colors.white),
                              
                            textAlign: TextAlign.start,
                            "$art_code"
                          ),
                          alignment: Alignment.topCenter,
                          ),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext) => MaterialApp(
                              home: Scaffold(
                                body: ListView(
      children: [
        Container(
          margin: EdgeInsets.only(top: 50.0,left: 10.0,right: 10.0,bottom: 10.0),
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 80, 44, 128),
            borderRadius: BorderRadius.circular(20.0)
          ),
          child: Text("$art_code",textAlign: TextAlign.start,style: TextStyle(fontSize: 15.0,color: Colors.white),),
        ),
        GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 40.0),
                  child: Text(lang == 1 ? "Back" : "Назад",style: TextStyle(fontSize: 20.0,color: Colors.blue),textAlign: TextAlign.center,),
                )
              ),
              Container(
                                margin: EdgeInsets.only(
                                    right: 250.0, bottom: 5.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          final likeExists =
                                              FirebaseFirestore.instance
                                                  .collection('likes')
                                                  .doc("$art_id" + "$userId");
                                          final doc = await likeExists.get();

                                          if (doc.exists == false) {
                                            String docId = art_id + userId;
                                            await FirebaseFirestore.instance
                                                .collection('likes')
                                                .doc(docId)
                                                .set({
                                              'user_id': userId,
                                              'art_id': art_id,
                                            });
                                          } else {
                                            await likeExists.delete();
                                          }
                                        },
                                        icon: StreamBuilder<DocumentSnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('likes')
                                              .doc("$art_id" + "$userId")
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return Container();
                                            }
                                            return Icon(
                                              snapshot.data!.exists
                                                  ? Icons.favorite
                                                  : Icons.favorite_outline,
                                              color: snapshot.data!.exists
                                                  ? Colors.red
                                                  : null,
                                              size: 32.0,
                                            );
                                          },
                                        ),
                                      ),
                                      IconButton(
  onPressed: () {
    late Future<List<Map<String, dynamic>>> _commentsFuture = _getCommentaries(art_id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Commentaries(art_id: art_id, lang: lang)
      ),
    );
  },
  icon: Icon(Icons.comment),
),
                                    ],
                                  ),
                                ),
                              ),
      ],
    ),
                              ),
                            )));
                            
                          },
                              )],
                          )
                        )
                      ],
                    ),
                    ),
                        );
                    },
                  );});
  }
}

Future<List<Map<String, dynamic>>> _getCommentaries(comment_id) async {
  print(comment_id);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final items = await _firestore
      .collection('commentaries')
      .limit(100)
      .where("art_id", isEqualTo: comment_id)
      .get();
  
  return items.docs.map((doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return {
      'comment': data["comment"].toString(),
      'name': data['username'].toString()
    };
  }).toList();
}