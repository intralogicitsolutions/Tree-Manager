// import 'dart:html';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdfx/pdfx.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';

class PdfViewer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PdfViewerState();
  }
}

class PdfViewerState extends State<PdfViewer> {
  Map<String, dynamic>? args;
  bool _isLoading = true;
  PdfDocument? document;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      var url = Helper.BASE_URL + args!['url'] + "&v=${Random().nextInt(99999)}";
      print(url);

      // Fetch the PDF data
      final response = await http.get(Uri.parse(url), headers: {
        "Authorization":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjEiLCJpYXQiOjE1MDY1NjA5ODB9.LAGHEE6tyd9FmZXaK40yDeUkHVZkOl8MdXSrtEcGwB4"
      });

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        document = await PdfDocument.openData(bytes);
        if (document!.pagesCount == 1) {
          // Handle single page scenario if needed
        }
        setState(() {
          _isLoading = false;
        });
      } else {
        // Handle error
        print('Failed to load PDF');
        setState(() {
          _isLoading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return Scaffold(
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      appBar: Helper.getAppBar(context,
          title: args!['title'], sub_title: 'Job TM# ${Global.job?.jobNo??''}'),
      body: Stack(
        children: <Widget>[
          Center(
            child: Visibility(
              child: Image.asset(
                'assets/images/background_image.png',
                width: size.width,
                height: size.height,
                fit: BoxFit.cover,
              ),
              visible: false,
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            width: size.width,
            height: size.height,
            child: Center(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : PdfView(
                      controller: PdfController(
                        document: Future.value(document!),//change
                        initialPage: 0,
                      ),
                      scrollDirection: Axis.vertical,
                    ),
            ),
          )
        ],
      ),
    );
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context);
  }
}
