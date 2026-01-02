import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'main.dart';
import 'login.dart';
import 'registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'recomendations.dart';



class SearchArticles extends StatelessWidget {
  final  searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isSmallScreen = screenWidth < 600 ? true:false;
    return Container(
                    
                    child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                        width: screenWidth * 0.7,
                        height: screenHeight * 0.075,
                        child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: lang == 1 ? 'Search' : 'Поиск',
                          
                        ),
                      ),
                      ),
                      GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(left: screenWidth * 0.01),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            shape: BoxShape.rectangle,
                            color: Color.fromARGB(255, 80, 44, 128),
                          ),
                          width: screenHeight * 0.075,
                          height: screenHeight * 0.075,
                          
                          child: Center(
                            child: Icon(Icons.search,color: Colors.white,),
                          ),
                        ),
                        onTap: () async{
                          if (searchController.text.isNotEmpty) {
                            Future<List<Map<String, dynamic>>> getSearchItems() async {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final search_articles = await _firestore
    .collection("articles")
    .where('bio', isGreaterThanOrEqualTo: searchController.text)
    .where('bio', isLessThanOrEqualTo: searchController.text + '\uf8ff')
    .limit(50)
    .get();
      
  
  return search_articles.docs.map((doc) {
    return {
      'bio': doc['bio'],
      'code': doc['code'],
      'lang': doc['lang'],
      'username': doc['username'],
      'id': doc['id'],
    };
  }).toList();
}
Navigator.push(context, MaterialPageRoute(builder: (BuildContext) => MaterialApp(
  theme: theme == 1 ? ThemeData.light() : ThemeData.dark(),
  home: Scaffold(
    appBar: AppBar(
      title: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back))
    ),
    body: Container(
                    margin: EdgeInsets.only(top: 10.0),
   
                    child: FutureBuilder<List<Map<String, dynamic>>>(
  future: getSearchItems(),
  builder: (context, snapshot) {
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
      print(snapshot.error);
      return Text(lang == 0 ?'Ошибка загрузки' : 'Loading error');
    }
    return ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        final article = snapshot.data![index];
        String art_code = article["code"];
        String art_lang = article["lang"];
        String art_username = article[
          'username'
        ];
        String art_id = article["id"];
        String art_bio = article['bio'];
        var n = 0;
                      return Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),

                              color: Color.fromARGB(50, 117, 131, 255) 
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
                          margin: EdgeInsets.only(top: 10.0, bottom: 30.0,right: 10.0,left: 10.0),
                          padding: EdgeInsets.all(5.0),
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
                              style: TextStyle(fontSize: 13.0,color: Colors.white),
                              
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
            borderRadius: BorderRadius.circular(30.0)
          ),
          child: Text("$art_code",textAlign: TextAlign.start,style: TextStyle(fontSize: 13.0,color: Colors.white),),
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
                    },
                  );}) 
                    )
  ),
)));
                        };
                        })
                    ],
                  ),
                  );
                  
                            
                          }
                          
                  
                  
                  /* Expanded(child: Container(
                    margin: EdgeInsets.only(top: 10.0),
                    height: 620.0,
                    child: FutureBuilder<List<Map<String, dynamic>>>(
  future: getSearchItems(),
  builder: (context, snapshot) {
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
      return Text(lang == 0 ?'Ошибка загрузки' : 'Loading error');
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
        String art_id = article["id"];
        String art_bio = article['bio'];
        var n = 0;
                      return Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),

                              color: Color.fromARGB(50, 117, 131, 255) 
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
                          width: 450.0,
                          child: Text(
                          '$art_bio',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 25.0,
                            fontFamily: "Inter",
                          ),
                          ),
                        ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10.0, bottom: 30.0,right: 10.0,left: 10.0),
                          padding: EdgeInsets.all(5.0),
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
                              style: TextStyle(fontSize: 13.0,color: Colors.white),
                              
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
            borderRadius: BorderRadius.circular(30.0)
          ),
          child: Text("$art_code",textAlign: TextAlign.start,style: TextStyle(fontSize: 13.0,color: Colors.white),),
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
                          margin: EdgeInsets.only(right: 250.0,bottom: 20.0),
                          child: Align(
                          child: IconButton(onPressed: () async{
                            final likeExists = FirebaseFirestore.instance.collection('likes').doc("$art_id"+"$userId");
                            final doc = await likeExists.get();

      if (doc.exists==false){
        String docId = art_id + userId;
        await FirebaseFirestore.instance
      .collection('likes')
      .doc(docId)
      .set({
        'user_id': userId,
        'art_id': art_id,
      });
      
      }
      else {
        await likeExists.delete();
      }
                            
                          }, icon: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
    .collection('likes')
    .doc("$art_id"+"$userId")
    .snapshots(),
        builder: (context, snapshot) {
           if (!snapshot.hasData) return Container();
          return Icon(
             snapshot.data!.exists ? Icons.favorite : Icons.favorite_outline,
            color: snapshot.data!.exists ? Colors.red : null,
            size: 32.0,
          );
        },
      ),
                          alignment: Alignment.centerLeft,
                        ),
                        ))
                      ],
                    ),
                    ),

                        );
                    },
                  );}) 
                    )); */
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