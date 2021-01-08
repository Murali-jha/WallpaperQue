import 'package:flutter/material.dart';
import 'package:wallpaperque/model/wallpaper_model.dart';
import 'package:wallpaperque/views/image_view.dart';

Widget brandName() {
  return RichText(
    text: TextSpan(
      style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w500),
      children: <TextSpan>[
        TextSpan(text: 'Wallpaper', style: TextStyle(fontFamily: "Raleway",fontSize: 21.0,fontWeight: FontWeight.bold)),
        TextSpan(text: 'Que', style: TextStyle(color: Colors.deepOrange,fontFamily: "Raleway",fontSize: 25.0,fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

Widget wallpaperList({List<WallpaperModel> wallpapers,context}){
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: GridView.count(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 0.6,
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 10.0,
      children:wallpapers.map(
              (wallpapers){
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return ImageView(imgUrl: wallpapers.src.portrait,);
                    }));
                  },
                  child: Hero(
                    tag: wallpapers.src.portrait,
                    child: GridTile(
                      child: Container(
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(18.0),
                                child: Image.network(wallpapers.src.portrait,fit: BoxFit.cover,)
                            ),
                            SizedBox(height: 15.0,),
                            Divider(height: 1.0,color: Colors.deepOrangeAccent,)
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
      ).toList()
    ),
  );
}
