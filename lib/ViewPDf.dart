import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';


class PdfViwer extends StatefulWidget {
  var url,chapter,filename;
  PdfViwer(c,u,fn){this.url=u;this.chapter=c;this.filename=fn;}
  @override
  _PdfViwerState createState() => _PdfViwerState(this.chapter,this.url,this.filename);
}

class _PdfViwerState extends State<PdfViwer> {
var url;
var chapter,filename;


  _PdfViwerState(c,u,fn)  {
    chapter=c;
    url=u;
    filename=fn;
    print(url);

  }



  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/$filename');
  }
  Future<PDFDocument> _getdocument() async{
    var d;
    final directory = await getApplicationDocumentsDirectory();
    final file = await _localFile;
    final f='${directory.path}/$filename';
    var x=await File(f).exists();
    if( x==true){
       d=await PDFDocument.fromFile(file);
    }
    else{
      _checkconnectivity();
      d = await PDFDocument.fromURL(url);
    }
  return d;
  }


_checkconnectivity() async {
  var result = await Connectivity().checkConnectivity();
  if (result == ConnectivityResult.none) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("No internet Connection"),
            content: Text("Check your internet connection"),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chapter),
      ),
      body: FutureBuilder(
        builder: (context, AsyncSnapshot<PDFDocument> snapshot) {
          if(snapshot.hasData){
            return PDFViewer(document: snapshot.data);
          }
          else{
            return  Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(
                    ),
                    width: 30,
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text("Loading.."),
                  )
                ],
              ),
            );
      }
        },
        future: _getdocument(),
      ),
    );
  }
}
