// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:math';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:multiple_images_picker/multiple_images_picker.dart';
// // import 'package:flutter_image_compress/flutter_image_compress.dart';
// //import 'package:flutter_image_compress/flutter_image_compress.dart';
//  //import 'package:multi_image_picker/multi_image_picker.dart';
//
// class AssetThumb2 extends StatefulWidget {
//   /// The asset we want to show thumb for.
//    final Asset? asset;
//    //final PickedFile? imageFile;
//
//   final File? fromFile;
//
//   /// The thumb width
//   final int width;
//
//   /// The thumb height
//   final int height;
//
//   /// The thumb quality
//   final int quality;
//
//   /// This is the widget that will be displayed while the
//   /// thumb is loading.
//   final Widget spinner;
//
//   final String? url;
//
//   const AssetThumb2({
//     Key? key,
//     this.asset,
//     // this.imageFile,
//     required this.width,
//     required this.height,
//     this.url,
//     this.fromFile,
//     this.quality = 100,
//     this.spinner = const Center(
//       child: SizedBox(
//         width: 50,
//         height: 50,
//         child: CircularProgressIndicator(),
//       ),
//     ),
//   }) : super(key: key);
//
//   @override
//   _AssetThumb2State createState() => _AssetThumb2State();
// }
//
// class _AssetThumb2State extends State<AssetThumb2> {
//   ByteData? _thumbData;
//
//   int get width => widget.width;
//   int get height => widget.height;
//   int get quality => widget.quality;
//   Asset? get asset => widget.asset;
//   //PickedFile? get imageFile => widget.imageFile;
//   Widget get spinner => widget.spinner;
//
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   this._loadThumb();
//   // }
//   @override
//   void initState() {
//     super.initState();
//     if (asset != null) {
//       _loadThumb();
//     }
//   }
//
//
//   @override
//   void didUpdateWidget(AssetThumb2 oldWidget) {
//     if (asset != null) {
//       if (oldWidget.asset!.identifier != widget.asset!.identifier) {
//         this._loadThumb();
//       }
//     }
//     // if (imageFile != null) {
//     //   if (oldWidget.imageFile?.path != widget.imageFile?.path) {
//     //     _loadThumb();
//     //   }
//     // }
//     super.didUpdateWidget(oldWidget);
//   }
//
//   void _loadThumb() async {
//     if (asset != null) {
//       setState(() {
//         _thumbData = null;
//       });
//
//       ByteData thumbData = await asset!.getThumbByteData(
//         width,
//         height,
//         quality: quality,
//       );
//
//       if (this.mounted) {
//         setState(() {
//           _thumbData = thumbData;
//         });
//       }
//    }
//   //   if (imageFile != null) {
//   //     setState(() {
//   //       _thumbData = null;
//   //     });
//   //
//   //     final bytes = await imageFile!.readAsBytes();
//   //     final buffer = bytes.buffer.asByteData();
//   //
//   //     if (this.mounted) {
//   //       setState(() {
//   //         _thumbData = buffer.buffer.asUint8List() as ByteData?;
//   //       });
//   //     }
//   //   }
//    }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_thumbData == null && asset != null) {
//       return spinner;
//     }
//     // if (_thumbData == null && imageFile != null) {
//     //   return spinner;
//     // }
//     else if (widget.fromFile!=null) {
//       return Image.file(
//         widget.fromFile!,
//         key: ValueKey(
//             asset != null ? asset!.identifier : Random.secure().nextInt(999)),
//         // key: ValueKey(imageFile?.path ?? Random.secure().nextInt(999)),
//         fit: BoxFit.contain,
//         gaplessPlayback: true,
//         height: 100,
//       );
//     } else if (widget.url != null) {
//       return CachedNetworkImage(
//         imageUrl: widget.url!,
//         height: 100,
//         fit: BoxFit.contain,
//         filterQuality: FilterQuality.low,
//         placeholder: (context, url) {
//           return CircularProgressIndicator();
//         },
//       );
//     } else  {
//       return Image.memory(
//         _thumbData!.buffer.asUint8List(),
//         key: ValueKey(
//             asset != null ? asset!.identifier : Random.secure().nextInt(999)),
//         // key: ValueKey(imageFile?.path ?? Random.secure().nextInt(999)),
//         fit: BoxFit.contain,
//         gaplessPlayback: true,
//         height: 100,
//       );
//     }
//   }
// }



// import 'dart:typed_data';
// import 'dart:io';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:multiple_images_picker/multiple_images_picker.dart';
//
// class AssetThumb2 extends StatefulWidget {
//   final Asset? asset;
//   final File? fromFile;
//   final int width;
//   final int height;
//   final int quality;
//   final Widget spinner;
//   final String? url;
//
//   const AssetThumb2({
//     Key? key,
//     this.asset,
//     required this.width,
//     required this.height,
//     this.url,
//     this.fromFile,
//     this.quality = 100,
//     this.spinner = const Center(
//       child: SizedBox(
//         // width: 10,
//         // height: 10,
//         child: CircularProgressIndicator(),
//       ),
//     ),
//   }) : super(key: key);
//
//   @override
//   _AssetThumb2State createState() => _AssetThumb2State();
// }
//
// class _AssetThumb2State extends State<AssetThumb2> {
//   ByteData? _thumbData;
//
//   int get width => widget.width;
//   int get height => widget.height;
//   int get quality => widget.quality;
//   Asset? get asset => widget.asset;
//   Widget get spinner => widget.spinner;
//
//
//   @override
//   void initState() {
//     // super.initState();
//     // print('hhhhhhhh ====> ${widget.asset}');
//     // if (widget.asset != null) {
//     //   _loadThumb();
//     // }
//     super.initState();
//     this._loadThumb();
//   }
//
//   @override
//   void didUpdateWidget(AssetThumb2 oldWidget) {
//     // if (widget.asset != null && widget.asset != oldWidget.asset) {
//     //   _loadThumb();
//     // }
//     if (asset != null) {
//       if (oldWidget.asset?.identifier != widget.asset?.identifier) {
//         this._loadThumb();
//       }
//     }
//     super.didUpdateWidget(oldWidget);
//   }
//
//   void _loadThumb() async {
//     print('kkkkkkkkkk');
//     if (asset != null) {
//       setState(() {
//         _thumbData = null;
//       });
//
//       ByteData? thumbData = await asset!.getThumbByteData(
//        width,
//         height,
//         quality: quality,
//       );
//
//       if (this.mounted) {
//         setState(() {
//           _thumbData = thumbData;
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_thumbData == null && asset != null) {
//       return widget.spinner;
//     }
//
//     if (widget.fromFile != null) {
//       print('image fromfile ----> ${widget.fromFile}');
//       return Image.file(
//         widget.fromFile!,
//         key: ValueKey(
//             asset != null ? asset?.identifier : Random.secure().nextInt(999)),
//         fit: BoxFit.contain,
//         gaplessPlayback: true,
//         height: 100,
//       );
//     } else if (widget.url != null) {
//       print('image url ----> ${widget.url}');
//       return CachedNetworkImage(
//         imageUrl: widget.url!,
//         height: widget.height.toDouble(),
//         fit: BoxFit.contain,
//         filterQuality: FilterQuality.low,
//         // placeholder: (context, url) {
//         //   return CircularProgressIndicator();
//         // },
//         progressIndicatorBuilder: (context, url, downloadProgress) =>
//             CircularProgressIndicator(value: downloadProgress.progress),
//         errorWidget: (context, url, error) => Icon(Icons.error),
//       );
//     } else {
//       print('image  ----> ${widget.fromFile}');
//       return Image.memory(
//        _thumbData!.buffer.asUint8List(),
//         key: ValueKey(
//             asset != null ? asset?.identifier : Random.secure().nextInt(999)),
//         fit: BoxFit.contain,
//         gaplessPlayback: true,
//         height: 100,
//       );
//     }
//   }
// }


import 'dart:typed_data';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AssetThumb2 extends StatefulWidget {
  final File? fromFile; // Changed from Asset? to File?
  final int width;
  final int height;
  final int quality;
  final Widget spinner;
  final String? url;

  const AssetThumb2({
    Key? key,
    this.fromFile,
    required this.width,
    required this.height,
    this.url,
    this.quality = 100,
    this.spinner = const Center(
      child: CircularProgressIndicator(),
    ),
  }) : super(key: key);

  @override
  _AssetThumb2State createState() => _AssetThumb2State();
}

class _AssetThumb2State extends State<AssetThumb2> {
  Uint8List? _thumbData;

  int get width => widget.width;
  int get height => widget.height;
  int get quality => widget.quality;
  File? get fromFile => widget.fromFile;
  Widget get spinner => widget.spinner;

  @override
  void initState() {
    super.initState();
    _loadThumb();
  }

  @override
  void didUpdateWidget(AssetThumb2 oldWidget) {
    if (fromFile != null && oldWidget.fromFile != fromFile) {
      _loadThumb();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _loadThumb() async {
    print('Loading thumbnail...');
    if (fromFile != null) {
      setState(() {
        _thumbData = null;
      });

      try {
        final byteData = await fromFile!.readAsBytes();
        if (mounted) {
          setState(() {
            _thumbData = byteData;
          });
        }
      } catch (e) {
        print('Error loading thumbnail: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_thumbData == null && fromFile != null) {
      return spinner;
    }

    if (widget.url != null) {
      print('Image URL: ${widget.url}');
      return CachedNetworkImage(
        imageUrl: widget.url!,
        height: widget.height.toDouble(),
        fit: BoxFit.contain,
        filterQuality: FilterQuality.low,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    } else if (_thumbData != null) {
      print('Image from file');
      return Image.memory(
        _thumbData!.buffer.asUint8List(),
        key: ValueKey(Random.secure().nextInt(999)),
        fit: BoxFit.contain,
        gaplessPlayback: true,
        height: 100,
      );
    } else {
      return spinner;
    }
  }
}
