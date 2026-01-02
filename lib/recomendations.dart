import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'main.dart';
import 'login.dart';
import 'registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'search.dart';
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
  runApp(Recomendations());
}

final TextEditingController commentController = TextEditingController(); 
String testCommentatorName = "Evebebe_Super_Ultra";
String testComment = "Bullshit";
final textEditingCommentsController = TextEditingController();

Future<List<Map<String, dynamic>>> _getPopularItems() async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final items = await _firestore
      .collection('articles')
      .limit(10)
      .get();
  
  return items.docs.map((doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return {
      'bio': doc['bio'] as String? ?? '',
      'code': data['code'] as String? ?? '',
      'lang': data['lang'] as String? ?? '',
      'name': data['name'] as String? ?? '', // исправлено на 'name'
      'id': data['id'] as String? ?? '',
      "username": data['username'] as String? ?? ""
    };
  }).toList();
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

class Recomendations extends StatefulWidget {
  const Recomendations({super.key});

  @override
  State<Recomendations> createState() => _RecomendationsState();
}

class _RecomendationsState extends State<Recomendations>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          /*  Align(
            child: Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(lang == 1 ? "Main Page": "Главная страница",textAlign: TextAlign.left,style: TextStyle(fontSize: 40.0,fontFamily: 'Inter'),),
            ),
            alignment: Alignment.topLeft
          ), */
          Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: SearchArticles(),
          ),
          Expanded(
            child: Container(
              height: 620.0,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _getPopularItems(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text(
                        lang == 0 ? 'Ошибка загрузки' : 'Loading error');
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final article = snapshot.data![index];
                      String art_name = article["name"];
                      String art_code = article["code"];
                      String art_lang = article["lang"];
                      String art_username = article['username'];
                      String art_id = article["id"];
                      String art_bio = article['bio'];
                      var n = 0;
                      return Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color.fromARGB(50, 117, 131, 255),
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
                                      fontFamily: "Inter",
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
                                  margin:
                                      EdgeInsets.only(left: 30.0, bottom: 20.0),
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
                                margin: EdgeInsets.only(
                                    top: 10.0,
                                    bottom: 30.0,
                                    right: 10.0,
                                    left: 10.0),
                                padding: EdgeInsets.all(5.0),
                                height: 200.0,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 80, 44, 128),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: 10.0, left: 20.0),
                                        child: Text(
                                          "$art_lang",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.white,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        margin: EdgeInsets.only(top: 10.0),
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Text(
                                            "$art_code",
                                            maxLines: 5,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext) =>
                                                MaterialApp(
                                              home: Scaffold(
                                                body: ListView(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 50.0,
                                                          left: 10.0,
                                                          right: 10.0,
                                                          bottom: 10.0),
                                                      padding:
                                                          EdgeInsets.all(20.0),
                                                      decoration: BoxDecoration(
                                                        color: Color.fromARGB(
                                                            255, 80, 44, 128),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30.0),
                                                      ),
                                                      child: Text(
                                                        "$art_code",
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          fontSize: 13.0,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            top: 40.0),
                                                        child: Text(
                                                          lang == 1
                                                              ? "Back"
                                                              : "Назад",
                                                          style: TextStyle(
                                                            fontSize: 20.0,
                                                            color: Colors.blue,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
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
        /* Scaffold(
          appBar: AppBar(
            title: Text(lang == 0 ? 'Комментарии' : 'Comments'),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back),
            ),
          ),
          body: Column(
            children: [
              // Список комментариев
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _commentsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return Center(
                        child: Text(
                          lang == 0 ? 'Ошибка загрузки' : 'Loading error',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    
                    final comments = snapshot.data ?? [];
                    print(art_id);
                    if (comments.isEmpty) {
                      return Center(
                        child: Text(
                          lang == 0 ? 'Нет комментариев' : 'No comments yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }
                    
                    return ListView.separated( // Используем separated для разделителей
                      itemCount: comments.length,
                      separatorBuilder: (context, index) => Divider(),
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        final commentName = comment["name"] ?? 
                                           comment["username"] ?? 
                                           (lang == 0 ? 'Аноним' : 'Anonymous');
                        final commentText = comment["comment"] ?? "";
                        
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                commentName,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                commentText,
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              
              // Поле ввода комментария
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: textEditingCommentsController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          hintText: lang == 0 
                              ? 'Напишите комментарий...' 
                              : 'Write a comment...',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () async{
                              // TODO: Добавить отправку комментария
                               final comRef = FirebaseFirestore.instance.collection('commentaries').doc();
                              await comRef.set(
                               { "art_id": art_id,
                                "comment": textEditingCommentsController.text}
                              );
                              textEditingCommentsController.clear();
                              setState(() {
                                              _commentsFuture = _getCommentaries(art_id);                
                                                            });
                              
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ), */
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
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class Commentaries extends StatefulWidget{
  final String art_id;
  final int lang; // Добавляем параметр lang
  
  Commentaries({required this.art_id, required this.lang});
  
  @override
  _CommentariesPageState createState() => _CommentariesPageState();
}

class _CommentariesPageState extends State<Commentaries> {
  late Future<List<Map<String, dynamic>>> _commentsFuture;
  @override
  void initState() {
  super.initState();
  _commentsFuture = _getCommentaries(widget.art_id);
}
  Widget build(BuildContext context) {
    final TextEditingController _textEditingController = TextEditingController();
    // TODO: implement build
     return Scaffold(
          appBar: AppBar(
            title: Text(lang == 0 ? 'Комментарии' : 'Comments'),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back),
            ),
          ),
          body: Column(
            children: [
              // Список комментариев
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _commentsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return Center(
                        child: Text(
                          lang == 0 ? 'Ошибка загрузки' : 'Loading error',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    
                    final comments = snapshot.data ?? [];
                    print(widget.art_id);
                    if (comments.isEmpty) {
                      return Center(
                        child: Text(
                          lang == 0 ? 'Нет комментариев' : 'No comments yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }
                    
                    return ListView.separated( // Используем separated для разделителей
                      itemCount: comments.length,
                      separatorBuilder: (context, index) => Divider(),
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        final commentName = comment["name"] ?? 
                                           comment["username"] ?? 
                                           (lang == 0 ? 'Аноним' : 'Anonymous');
                        final commentText = comment["comment"] ?? "";
                        
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                commentName,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                commentText,
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              
              // Поле ввода комментария
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: textEditingCommentsController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          hintText: lang == 0 
                              ? 'Напишите комментарий...' 
                              : 'Write a comment...',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () async{
                              if (textEditingCommentsController.text.isNotEmpty) {
                                final comRef = FirebaseFirestore.instance.collection('commentaries').doc();
                              await comRef.set(
                               { "art_id": widget.art_id,
                               "username": name,
                                "comment": textEditingCommentsController.text}
                              );
                              textEditingCommentsController.clear();
                              setState(() {
                                              _commentsFuture = _getCommentaries(widget.art_id);                
                                                            });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
  }
}


