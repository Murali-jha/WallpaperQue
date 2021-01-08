import 'dart:io';
import 'dart:typed_data';
import 'package:toast/toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageView extends StatefulWidget {
  final String imgUrl;
  ImageView({@required this.imgUrl});
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  var filePath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: widget.imgUrl,
            child: Container(
              height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.network(widget.imgUrl,fit: BoxFit.cover,)
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
               GestureDetector(
                 onTap: (){
                   _save();

                 },
                 child: Stack(
                   children: [
                     Container(
                       decoration: BoxDecoration(
                         color: Color(0xff1C1B1B).withOpacity(0.8),
                         borderRadius: BorderRadius.circular(30.0),
                       ),
                       width: MediaQuery.of(context).size.width/2,
                       height: 60.0,

                     ),
                     Container(
                       height: 60.0,
                       width: MediaQuery.of(context).size.width/2,
                       padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 8.0),
                       decoration: BoxDecoration(
                         border: Border.all(color: Colors.white54,width: 1),
                         borderRadius: BorderRadius.circular(30.0),
                         // gradient: LinearGradient(
                         //   begin: Alignment.topRight,
                         //   end: Alignment.bottomLeft,
                         //   stops: [0.1, 0.5, 0.7, 0.9],
                         //   colors: [
                         //     Color(0x36FFFFFF),
                         //     Color(0x0FFFFFFF),
                         //   ],
                         // ),
                         color: Colors.grey
                       ),
                       child:Column(
                         children: [
                           Text("Set Wallpaper",style: TextStyle(fontSize: 20,color: Colors.white)),
                           Text("Image will be Saved to Gallery",style: TextStyle(fontSize: 12,color: Colors.white),)
                         ],
                       ) ,
                     ),
                   ],
                 ),
               ),
                SizedBox(
                  height: 14.0,
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                    child: Text("Cancel",style: TextStyle(color: Colors.white),)),
                SizedBox(
                  height: 80.0,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _save() async {
     if(Platform.isAndroid){
       await _askPermission();
       print("Yes done");
     }
    var response = await Dio().get(widget.imgUrl,
        options: Options(responseType: ResponseType.bytes));
    final result =
    await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    if(result==null){
      print('No');
    }
    else{
      print("Fucked");
    }
    Navigator.pop(context);
     showDialog(
       context: context,
       builder: (context) {
         return AlertDialog(
           title: Text('Image Saved in Gallery',style: TextStyle(fontFamily: "Raleway"),),
           content: Text("Check it out :)",style: TextStyle(fontFamily: "Raleway")),
           actions: [
             Center(
               child: FlatButton(
                 child: Text('Cool !', style: TextStyle(color: Colors.green,fontSize: 18.0,fontFamily: "Raleway",fontWeight: FontWeight.bold),),
                 onPressed: () async {
                   Navigator.pop(context);
                 },
               ),
             ),
           ],
         );
       }
     );
  }

  _askPermission() async {
    if (Platform.isIOS) {
          Map<PermissionGroup,PermissionStatus> permissions= await PermissionHandler()
          .requestPermissions([PermissionGroup.photos]);
    }
    else {
//     PermissionStatus permissionStatus =  await PermissionHandler()
//          .checkPermissionStatus(PermissionGroup.storage);
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    }
  }
}
