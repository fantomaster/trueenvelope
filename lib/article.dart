import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'main.dart';

  final controllerLang = TextEditingController();

  final controllerBio = TextEditingController();
  final controllerCode = TextEditingController();

class Article extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    return Container(
      padding: EdgeInsets.all(10.0),
      child: ListView(
      children: [
        Container(
          margin: EdgeInsets.only(left: 20.0,top: 20.0),
          child: Text(lang == 1 ? "New Article": "Новая статья", style: TextStyle(fontFamily: "Inter", fontSize: 40.0),),
        ),
        /* Container(
          margin: EdgeInsets.only(top: 20.0),
          width: 300.,
          child: Center(
          child: Text(
            textAlign: TextAlign.center,
            "Create new article. Write name of your code, bio and language",
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 20.0
            ),
          ),
        ),
        ), */
        Container(

          margin: EdgeInsets.only(top: 50.0,right: 10.0),
          child: Column(
            children: [
              Container(
              

                margin: EdgeInsets.only(right: 10.0,left: 10.0 ),
          child: TextFormField(
            controller: controllerLang,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(20.0),
            border: OutlineInputBorder(),
            labelText: lang == 1 ? "Language": "Язык"
          ),
        ),
        ),
        Container(
        margin: EdgeInsets.only(top: 70.0,right: 10.0,left: 10.0 ),
        
        child: TextFormField(
          controller: controllerBio,
          minLines: 1, 
           // Минимальное количество строк
          maxLines: null,  // null = бесконечно строк (разворачивается по мере ввода)
          keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(20.0),
            isDense: false,
            labelText: lang == 1 ? "Bio": "Описание",
            
          ),
          ),
      ),
      Container(
        margin: EdgeInsets.only(top: 70.0,right: 10.0,left: 10.0 ),
        
        
        child: TextFormField(
          controller: controllerCode,
          minLines: 3,  // Минимальное количество строк
          maxLines: null,  // null = бесконечно строк (разворачивается по мере ввода)
          keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(20.0),
            isDense: false,
            labelText: lang == 1 ? "Code": "Код",
            hintText: lang == 1 ? "Minimum 3 lines": "Минимум три строки"
          ),
          ),
      ),
      GestureDetector(
        child: Container(
                  width: 150.0,
                  height: 50.0,
                  margin: EdgeInsets.only(top: 50.0,left: 100.0,right: 100.0),
                  padding: EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 40, 40, 44),
                    borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: Center(child: Text("Create",style: TextStyle(fontSize: 30.0,color: Colors.white),),)
                ),
                onTap:() async {
                  if (controllerLang.text.isNotEmpty && controllerBio.text.isNotEmpty && controllerCode.text.isNotEmpty) {
                    try {
                      final docRef = FirebaseFirestore.instance.collection('articles').doc();
                        await docRef.set({
                          'id': docRef.id,
                           'username': name,

        'lang': controllerLang.text,
        'bio': controllerBio.text,
        'code': controllerCode.text,
                        });

        controllerLang.clear();
        controllerBio.clear();
        controllerCode.clear();


        showDialog(context: context, builder: (BuildContext inContext) {
          return SimpleDialog(
            title: Container(
              height: 100.0,
              child: Center(child: Text(lang == 1 ? "Article was created" : "Статья была создана",style: TextStyle(
                                                fontFamily: "Inter",
                                                fontSize: 20.0,
                                              ),),)
            )
          );
        })
        ;
                    } catch(e) {
                      print("Ошибка");
                    }
                  } else {print("ошибочка");}
                }, 
      )
      ],
    ),
    )]));
  }
}

Widget _textFormFieldLang() {
  return TextFormField(
            controller: controllerLang,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(20.0),
            border: OutlineInputBorder(),
            labelText: lang == 1 ? "Language": "Язык"
          ),
        );
}

Widget _textFormFieldBio() {
  return TextFormField(
          controller: controllerBio,
          minLines: 1, 
           // Минимальное количество строк
          maxLines: null,  // null = бесконечно строк (разворачивается по мере ввода)
          keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(20.0),
            isDense: false,
            labelText: lang == 1 ? "Bio": "Описание",
            
          ),
          );
}

Widget _textFormFieldCode() {
  return TextFormField(
          controller: controllerCode,
          minLines: 3,  // Минимальное количество строк
          maxLines: null,  // null = бесконечно строк (разворачивается по мере ввода)
          keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(20.0),
            isDense: false,
            labelText: lang == 1 ? "Code": "Код",
            hintText: lang == 1 ? "Minimum 3 lines": "Минимум три строки"
          ),
          );
}