import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/network_image.dart';
import 'package:tree_manager/site_inspection/asset_thumb.dart';
import 'package:image_picker/image_picker.dart';

class AfterPhoto extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AfterPhotoState();
  }
}

class AfterPhotoState extends State<AfterPhoto>
    with AutomaticKeepAliveClientMixin<AfterPhoto> {
   List<XFile> assets = <XFile>[];
  //List<NetworkPhoto>? images;
   List<NetworkPhoto> images = [];
 // String _error = 'No Error Dectected';

  bool initialPopup = false;

  @override
  void initState() {
    print('initing after photos');
    if (Global.after_images != null) {
      images = [];
      if (Global.after_images!.length > 0) images.addAll(Global.after_images as Iterable<NetworkPhoto>);
    } else
      images = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    // var args=ModalRoute.of(context)?.settings.arguments as Map<String,dynamic>;
    if (Global.job?.siteHazardFormExists == 'true' ||
        Global.job?.siteHazardUploadExists == 'true' ||
        Global.job?.siteHazard == 'true') {
      WidgetsBinding.instance.addPostFrameCallback((Duration d) {
        if (Global.job?.afterImagesExists == 'false' && !initialPopup) {
          initialPopup = true;
          loadedMinimum(upload: false);
        }
      });
    }
    return Scaffold(
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      // appBar: Helper.getAppBar(context, title: "UserName"),
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
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                /*Center(child: Text('Error: $_error')),
                ElevatedButton(
                  child: Text("Pick images"),
                  onPressed: loadAssets,
                ),*/
                Expanded(
                  child: buildGridView(),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    width: size.width * .60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: 0,
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                                height: 60.0,
                                width: 60.0,
                                margin: EdgeInsets.only(bottom: 10.0, top: 30),
                                child: FittedBox(
                                  child: IconButton(
                                      icon: SvgPicture.asset(
                                        "assets/images/add_photo.svg",
                                        height: 60,
                                        width: 60,
                                      ),
                                      onPressed: () async {
                                        if (Global.job?.siteHazardFormExists ==
                                            'true' ||
                                            Global.job?.siteHazardUploadExists ==
                                                'true' ||
                                            Global.job?.siteHazard == 'true') {
                                          var action = await showMinimumWarning(
                                              title: 'Choose an Action',
                                              desc: '  ');
                                          if (action == true)
                                            loadAssets();
                                          else if(action == false)
                                            getImage(ImageSource.camera);
                                          // else
                                          //   getImage(ImageSource.camera);
                                                                                } else {
                                          Toast.show(
                                            'Complete Site Hazard and Comeback to upload.',
                                            //context
                                          );
                                        }
                                      }),
                                )),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                                height: 60.0,
                                width: 60.0,
                                margin: EdgeInsets.only(bottom: 10.0, top: 30),
                                child: FittedBox(
                                  child: FloatingActionButton(
                                      heroTag: 'dialog_action_after',
                                      child: SvgPicture.asset(
                                        "assets/images/continue_button.svg",
                                        height: 60,
                                        width: 60,
                                      ),
                                      onPressed: () {
                                        if (Global.job?.siteHazardFormExists ==
                                            'true' ||
                                            Global.job?.siteHazardUploadExists ==
                                                'true' ||
                                            Global.job?.siteHazard == 'true') {
                                          loadedMinimum(upload: true);
                                        } else {
                                          Toast.show(
                                            'Complete Site Hazard and Comeback to upload.',
                                            //context
                                          );
                                        }
                                      }),
                                )),
                            Text(
                              "CONTINUE",
                              style: TextStyle(color: Themer.textGreenColor),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildGridView() {
    var _crossAxisSpacing = 8;
    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = 2;
    var _width = (_screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var cellHeight = 205;
    var _aspectRatio = _width / cellHeight;
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 8,
            crossAxisCount: _crossAxisCount,
            childAspectRatio: _aspectRatio),
        itemCount: images.length,
        itemBuilder: (context, index) {
          //Asset? asset = images[index].localImage;
          File? asset = images[index].fromFile;
          NetworkPhoto item = images[index];
          //print('${asset?.name}   ${asset?.identifier}');
          print('File Path: ${asset?.path ?? 'null'}');

          return GestureDetector(
            child: Container(
                padding: EdgeInsets.all(2),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (Global.job?.deleteAfterimages == 'true' ||
                        item.id == null)
                      Align(
                        child: Container(
                          margin: EdgeInsets.only(top: 0, right: 10),
                          width: 25,
                          height: 25,
                          child: FloatingActionButton(
                            heroTag: 'after_${index}',
                            onPressed: () {
                              deleteImage(item, index);
                            },
                            child: SvgPicture.asset(
                                'assets/images/delete_button.svg'),
                          ),
                        ),
                        alignment: Alignment.topRight,
                      ),
                    AssetThumb2(
                      quality: 100,
                      //asset: asset,
                      url: (asset == null && !item.camera!)
                          ? Helper.BASE_URL + item.imgPath!
                          : null,
                      fromFile: item.fromFile,
                      width: 150,
                      height: 120,
                    ),
                    GestureDetector(
                      child: Container(
                        height: 60,
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 2, bottom: 2),
                        child: Align(
                          child: Text(item.imgDescription ?? 'Description',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white)),
                        ),
                        decoration: BoxDecoration(color: Themer.textGreenColor),
                      ),
                      onTap: () async {
                        var msg = await Navigator.pushNamed(
                            context, 'comment_box',
                            arguments: {
                              'title': 'Site Photos',
                              'sub_title': 'Description',
                              'positiveButtonText': 'SAVE',
                              'positiveButtonimage': 'save_button.svg',
                              'negativeButtonText': 'BACK',
                              'negativeButtonimage': 'back_button.svg',
                              'option': Global.before_photos,
                              'text': item.imgDescription??'',
                            });
                        print('Msg=$msg');
                        if (msg is String) {
                          setState(() {
                            item.imgDescription = msg;
                            images[index] = item;
                          });
                        }
                      },
                    ),
                  ],
                )),
            onTap: () {
              Navigator.pushNamed(context, 'image_viewer', arguments: {
                'image': item,
                'text': item.imgDescription ?? ' '
              });
            },
          );
        });
  }

  //File? _image;

  // Future getImage(ImgSource source) async {
  //   var image = await ImagePickerGC.pickImage(
  //     context: context,
  //     source: source,
  //     cameraIcon: Icon(
  //       Icons.add,
  //       color: Colors.red,
  //     ), //cameraIcon and galleryIcon can change. If no icon provided default icon will be present
  //   );
  //
  //   setState(() {
  //     _image = image;
  //     if (image != null) {
  //       var tmp = NetworkPhoto();
  //       tmp.fromFile = image;
  //       tmp.camera = true;
  //       images?.add(tmp);
  //     }
  //     print('camera ${_image?.path}');
  //   });
  // }
   Future<void> getImage(ImageSource source) async {
     final ImagePicker picker = ImagePicker();
     XFile? image;

     try {
       if (source == ImageSource.camera) {
         image = await picker.pickImage(source: ImageSource.camera);
       } else {
         image = await picker.pickImage(source: ImageSource.gallery);
       }

       if (image != null) {
         File file = File(image.path);
         var tmp = NetworkPhoto();
         tmp.fromFile = file;
         tmp.camera = source == ImageSource.camera;
         images.add(tmp);

         // Call setState to update the UI
         setState(() {
          // _image = file; // Update any state variables as needed
         });
       }
     } catch (e) {
       print('Error occurred while picking image: $e');
     }
   }

  // Future<void> loadAssets() async {
  //   List<Asset> resultList = <Asset>[];
  //   String error = 'No Error Dectected';
  //
  //   try {
  //     resultList = await MultipleImagesPicker.pickImages(
  //       maxImages: 50,
  //       enableCamera: true,
  //       selectedAssets: assets,
  //       cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
  //       materialOptions: MaterialOptions(
  //         actionBarColor: "#14BB11",
  //         actionBarTitle: "Select Before Images",
  //         allViewTitle: "All Photos",
  //         useDetailsView: true,
  //         selectCircleStrokeColor: "#14BB11",
  //       ),
  //     );
  //   } on Exception catch (e) {
  //     error = e.toString();
  //   }
  //
  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;
  //
  //   setState(() {
  //     assets = resultList;
  //     if (resultList.length > 0) {
  //       images?.removeWhere(
  //           (test) => test.localImage != null && test.imgPath == null);
  //       images
  //           ?.removeWhere((test) => test.camera != true && test.imgPath == null);
  //     }
  //     assets.forEach((f) {
  //       var tmp = NetworkPhoto();
  //       tmp.localImage = f;
  //       tmp.camera = false;
  //       print('identifier ${f.identifier}');
  //       images?.add(tmp);
  //     });
  //     _error = error;
  //   });
  // }
   Future<void> loadAssets() async {
     List<XFile> resultList = <XFile>[];
     String error = 'No Error Dectected';

     PermissionStatus status = await Permission.photos.request();

     if (status.isGranted) {
       try {
         // Attempt to pick images
         resultList = await ImagePicker().pickMultiImage();

         print('Images selected: ${resultList}');
       } on Exception catch (e) {
         // Handle specific exception where user cancels selection
         if (e.toString().contains("cancelled")) {
           error = 'Image selection cancelled by the user.';
         } else {
           error = 'Error: ${e.toString()}';
         }
         print('Error occurred: ${error}');
       }
     } else if (status.isDenied || status.isPermanentlyDenied) {
       // Handle the case when the user denies the permission
       print('Photos permission denied.');
     }
     if (!mounted) return;

     setState(() {
       assets = resultList;
       assets.forEach((f) {
         var tmp = NetworkPhoto();
         tmp.fromFile = File(f.path);
         tmp.camera = false;
         images.add(tmp);
       });
       //_error = error;
     });
   }

  Future<void> deleteImage(NetworkPhoto image, int index) async {
    if (image.fromFile != null) {
      setState(() {
        assets.remove(image.fromFile);
        images.removeAt(index);
      });
    } else {
      var action = await showDeleteConfirmation();
      if (action == true) {
        var post = {
          "params": {"id": '${image.id}'}
        };
        Helper.showProgress(context, 'Deleting Image');
        Helper.post("uploadimages/Delete", post, is_json: true).then((data) {
          Helper.hideProgress();
          var json = jsonDecode(data.body);
          if (json['success'] == 1) {
            var post = {
              "params": {"imgPath": "${image.imgPath}"}
            };
            Helper.post("uploadimages/deleteImg", post, is_json: true)
                .then((data) {
              Helper.hideProgress();
              var json = jsonDecode(data.body);
              if (json['response'] == 'success') {
                setState(() {
                  images.removeAt(index);
                  //assets.remove(image.localImage);
                });
              }
            }).catchError((error) {
              Helper.hideProgress();
            });
          }
        }).catchError((onError) {
          Helper.hideProgress();
        });
      }
    }
  }

  Future<void> loadedMinimum({required bool upload}) async {
    if (images.length < 3) {
      var action = await showMinimumWarning(
          title: '', desc: 'Please load at least 3 photos.');
      if (action == true){
        loadAssets();}
      else if(action == false){
        getImage(ImageSource.camera);}
      // else
      //   getImage(ImageSource.camera);
        } else if (upload) {
      update();
    }
  }

  void update() {
    images.asMap().forEach((index, it) async {
      if (it.id == null) {
        it.imgName =
        "AFTER_Image_${DateFormat('yyMMddHHmmssS').format(DateTime.now())}_$index.jpg";
        it.imgPath =
        "${Global.job?.jobId??''}/${Global.job?.jobAllocId??''}/${it.imgName}.jpg";
      }
      var url = '';
      var post = {
        "id": "${it.id}",
        "job_id": "${Global.job?.jobId}",
        "job_no": "${Global.job?.jobNo}",
        "job_alloc_id": "${Global.job?.jobAllocId}",
        "company_id": "${Helper.user?.companyId}",
        "upload_type": "0",
        "upload_type_detail": "0",
        "img_type": "2",
        "img_path": "${it.imgPath}",
        "img_description": "${it.imgDescription ?? ''}",
        "img_name": "${it.imgName}",
        "status": "1",
        "process_id": "${Helper.user?.processId}",
        "owner": "${Helper.user?.id}",
        "created_by": "${Helper.user?.id}",
        "last_modified_by": "${Helper.user?.id}",
        "created_at":
        "${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}",
        "last_updated_at":
        "${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}",
        "included": "2",
        "upload_by": "${Helper.user?.id}",
        "upload_time":
        "${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}",
        "source": "2",
        "img_inc": "2",
        "vs": await Helper.getAppVersion()
      };
      if (it.id == null)
        url = "UploadImages/CreateWithNewID";
      else
        url = "uploadimages/Edit";
      Helper.showProgress(context, 'Uploading Images..');
      (it.id == null
          ? Helper.post(url, post, is_json: true)
          : Helper.put(url, post, is_json: true))
          .then((data) async {
        var json = jsonDecode(data.body);
        if (json['success'] == 1) {
          if (it.id == null) {
            var byte = it.camera == false
                ? await it.fromFile?.readAsBytes()
            // (await it.localImage!.getByteData(quality: 10))
            //         .buffer
            //         .asUint8List()
                : (await it.fromFile!.readAsBytes());
           // var image = img.decodeJpg(byte.buffer.asUint8List());
            var image = img.decodeJpg(byte!);
            var finalImg = img.copyResize(image!,
                width: image.width ~/ 2, height: image.height ~/ 2);
            var base64 = base64Encode(img.encodeJpg(finalImg, quality: 50));
            var innerPost = {
              "imgPath": "data:image/jpeg;base64,${base64}",
              "jobId": "${Global.job?.jobId}",
              "jobAllocId": "${Global.job?.jobAllocId}",
              "imgName": "${it.imgName}"
            };
            Helper.post("uploadimages/uploadAppPic", innerPost, is_json: true)
                .then((data) async {
              var json = jsonDecode(data.body);
              if (json['status'] == 1) {
                if (index == images.length - 1) {
                  await Helper.updateNotificationStatus(Global.job!.jobAllocId??'');
                  Helper.hideProgress();
                  var action = await showPhotoLoaded();
                  if (action == true) {
                    Navigator.pushReplacementNamed(context, 'accident');
                  } else {
                    try {
                      Navigator.pushReplacementNamed(context, 'invoice');
                    } catch (e) {}
                  }
                }
              }
            }).catchError((onError) {
              Helper.hideProgress();
            });
          } else {
            if (index == images.length - 1) {
              var action = await showPhotoLoaded();
              if (action == true) {
                Navigator.pushReplacementNamed(context, 'accident');
              } else {
                try {
                  Navigator.pushReplacementNamed(context, 'invoice');
                } catch (e) {}
              }
            }
          }
        }
      }).catchError((onError) {
        Helper.hideProgress();
      });
    });
  }

  Future<bool?> showPhotoLoaded() async {
    return (await Helper.showMultiActionModal(context,
        title: 'Good Job!',
        description:
        'Photos loaded Successfully.Do you want to complete the job?',
        negativeButtonText: 'NO',
        negativeButtonimage: 'reject.svg',
        positiveButtonText: 'YES',
        positiveButtonimage: 'accept.svg'));
  }

  Future<bool?> showDeleteConfirmation() async {
    return (await Helper.showMultiActionModal(context,
        title: 'Delete',
        description: 'Do you want to Delete the photo?',
        negativeButtonText: 'NO',
        negativeButtonimage: 'reject.svg',
        positiveButtonText: 'YES',
        positiveButtonimage: 'accept.svg'));
  }

  Future<bool?> showMinimumWarning({String? title, String? desc}) async {
    final result = await Helper.showMultiActionModal(context,
        title: title,
        description: desc,
        negativeButtonText: 'CAMERA',
        negativeButtonimage: 'camera_button.svg',
        positiveButtonText: 'GALLERY',
        positiveButtonimage: 'gallery_button.svg');
    return result ?? null;
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context, setState);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
