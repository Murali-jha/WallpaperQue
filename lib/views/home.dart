import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpaperque/data/data.dart';
import 'package:wallpaperque/model/categories_model.dart';
import 'package:wallpaperque/model/wallpaper_model.dart';
import 'package:wallpaperque/views/categorie.dart';
import 'package:wallpaperque/views/image_view.dart';
import 'package:wallpaperque/views/search.dart';
import 'package:wallpaperque/widget/widgets.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoriesModel> categories = new List();
  List<WallpaperModel> wallpapers = new List();
  TextEditingController searchController = new TextEditingController();
  var _formKey = GlobalKey<FormState>();

  getTrendingWallpapers() async {
    var response = await http
        .get("https://api.pexels.com/v1/curated?per_page=100", headers: {
      "Authorization": apiKey,
    });
    //print(response.body.toString());
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element) {
      //print(element);
      WallpaperModel wallpaperModel = new WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });

    setState(() {});
  }

  @override
  void initState() {
    getTrendingWallpapers();
    categories = getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: brandName(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.0)),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 10.0,),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xff484747  ),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: 24.0,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Row(
                  children: [
                    Form(
                      key: _formKey,
                      child: Expanded(
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return ("Search field Can't be Empty!!");
                            }
                          },
                          controller: searchController,
                          decoration: InputDecoration(
                              hintText: "search wallpaper",
                              hintStyle: TextStyle(fontSize: 18.0,fontFamily: "Raleway",),
                              border: InputBorder.none,
                              errorStyle: TextStyle(fontSize: 14.0,fontFamily: "Raleway",)),
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_formKey.currentState.validate()) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return Search(
                                  searchQuery: searchController.text,
                                );
                              }));
                            }
                          });
                        },
                        child: Container(child: Icon(Icons.search))),
                  ],
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Wallpapers get updated in every ",
                    style: TextStyle(fontSize: 13.0,fontFamily: "Raleway",fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "3 ",
                    style: TextStyle(fontSize: 14.0,fontFamily: "Raleway",fontWeight: FontWeight.bold,color: Colors.deepOrangeAccent),
                  ),
                  Text(
                    "hours",
                    style: TextStyle(fontSize: 14.0,fontFamily: "Raleway",fontWeight: FontWeight.bold,),
                  ),
                ],
              ),
              SizedBox(
                height: 16.0,
              ),
              Container(
                height: 80.0,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return CategoriesTile(
                      title: categories[index].categoriesName,
                      imgUrl: categories[index].imgUrl,
                    );
                  },
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              wallpaperList(wallpapers: wallpapers, context: context),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesTile extends StatelessWidget {
  final String imgUrl, title;

  CategoriesTile({@required this.imgUrl, @required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Categorie(
            categorieName: title.toLowerCase(),
          );
        }));
      },
      child: Container(
        margin: EdgeInsets.only(right: 8.0),
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: CachedNetworkImage(
                  imageUrl: imgUrl,
                  width: 130.0,
                  height: 70.0,
                  fit: BoxFit.cover,
                )),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.black45,
                ),
                alignment: Alignment.center,
                width: 130.0,
                height: 70.0,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                    letterSpacing: 0.8,
                    fontFamily:"Raleway"
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
