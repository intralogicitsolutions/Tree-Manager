import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:cached_network_image/cached_network_image.dart';
//import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:save_in_gallery/save_in_gallery.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toast/toast.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/pojo/network_image.dart';

class ImageViewer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ImageViewerState();
  }
}

class ImageViewerState extends State<ImageViewer> {
  var args;
  NetworkPhoto? item;
  var imageBytes;
  var bytes;
  File? file;
  String text = '';

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      item = args['image'] as NetworkPhoto;
      text = args['text'];
      if (imageBytes == null) {
        // if (item!.localImage != null) {
        //   print("if");
        //   item!.localImage!.getByteData(quality: 100).then((byteData) {
        //     imageBytes = byteData.buffer.asUint8List();
        //     bytes = imageBytes;
        //     setState(() {});
        //   });
        // }
        //  else
        if (item!.imgPath != null) {
          print("else if");
          Helper.get(item!.imgPath!, {}).then((value) {
            setState(() {
              bytes = value.bodyBytes;
            });
          }).catchError((onError) {});
        } else {
          print("else");
          setState(() {
            print("${item!.fromFile!.path}");
            file = item!.fromFile;
            bytes = file!.readAsBytesSync();
          });
        }
      }
    });
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    item = args['image'] as NetworkPhoto;
    text = args['text'];
    return Scaffold(
      //bottomNavigationBar: Helper.getBottomBar(bottomClick),
      appBar: Helper.getAppBar(context,
          title: "",
          showNotification: false,
          actions: Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.save,
                    color: Colors.black,
                    size: 25,
                  ),
                  onPressed: () {
                    saveImage(bytes, item!.imgName!);
                  }),
              IconButton(
                  icon: Icon(
                    Icons.share,
                    color: Colors.black,
                    size: 25,
                  ),
                  onPressed: () async {
                    final tempDir = await getTemporaryDirectory();
                    final tempFile = File('${tempDir.path}/temp_image.png');
                    await tempFile.writeAsBytes(bytes);
                    await Share.shareFiles(
                      [tempFile.path],
                      text: 'My optional text.',
                    );
                    // await Share.file(
                    //     'esys image', 'test0.png', bytes, 'image/png',
                    //     text: 'My optional text.');
                  }),
            ],
            mainAxisSize: MainAxisSize.min,
          )),
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
            width: size.width,
            height: size.height,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                (() {
                  if (imageBytes != null)
                    return Image.memory(
                      imageBytes,
                      height: size.height * .80,
                    );
                  else if (item?.imgPath != null)
                    return CachedNetworkImage(
                      imageUrl: Helper.BASE_URL + item!.imgPath!,
                      height: size.height * .80,
                      placeholder: (context, url) {
                        return CircularProgressIndicator();
                      },
                    );
                  else if (file != null) {
                    return Image.file(
                      file!,
                      fit: BoxFit.contain, // Adjust to fit available space
                    );
                  } else {
                    return Center(child: Text('No image available')); // Fallback if no image is available
                  }
                  // else
                  //   return Image.file(
                  //     file!,
                  //     height: size.height * .80,
                  //   );
                }()),
                Spacer(),
                SingleChildScrollView(
                  child: Container(
                    color: Colors.black.withOpacity(0.8),
                    padding: EdgeInsets.only(bottom: 10, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            text,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context);
  }

  Future<void> saveImage(Uint8List bytes, String name) async {
    final directory = await getApplicationDocumentsDirectory();
    final imageFile = File('${directory.path}/$name');

    final image = img.decodeImage(bytes);
    if (image != null) {
      final pngBytes = img.encodePng(image);
      await imageFile.writeAsBytes(pngBytes);
      Toast.show('Image has been saved.',
         // textStyle: context,
          gravity: Toast.center);
    } else {
      Toast.show('Error decoding image.',
          //textStyle: context,
          gravity: Toast.center);
    }
    // final _imageSaver = ImageSaver();
    // final res = await _imageSaver.saveImage(
    //   imageBytes: bytes,
    //   imageName: name,
    //   directoryName: 'TreeManager',
    // );
    // if (res == true) {
    //   Toast.show('Image has saved.', textStyle: context, gravity: Toast.center);
    // } else {
    //   Toast.show('Exception on saving image.',
    //       textStyle: context, gravity: Toast.center);
    // }


    // if (await Permission.storage.request().isGranted) {
    //   print("bytes $bytes");
    //   var documentDirectory = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
    //   print("direc= $documentDirectory");
    //   var firstPath = documentDirectory.path + "/TreeManager/";
    //   print("fpath= $firstPath");
    //   Directory(firstPath).createSync(recursive: true);
    //   var filePathAndName = documentDirectory.path + '/TreeManager/$name';
    //   print("fpathName= $filePathAndName");
    //   File file2 = new File(filePathAndName);
    //   file2.writeAsBytesSync(bytes);
    // }
  }
}
