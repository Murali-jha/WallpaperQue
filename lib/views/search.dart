import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wallpaperque/data/data.dart';
import 'package:wallpaperque/model/wallpaper_model.dart';
import 'package:wallpaperque/widget/widgets.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  final String searchQuery;
  Search({this.searchQuery});
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var _formKey = GlobalKey<FormState>();
  List<WallpaperModel> wallpapers = new List();
  TextEditingController searchController = new TextEditingController();
  getSearchWallpapers(String query) async {
    var response = await http
        .get("https://api.pexels.com/v1/search?query=$query&per_page=100",
        headers: {
      "Authorization": apiKey,
    });
    //print(response.body.toString());
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    wallpapers = new List();
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
    getSearchWallpapers(widget.searchQuery);
    super.initState();
    searchController.text=widget.searchQuery;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: brandName(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25.0)),
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
                          validator: (value){
                            if(value.isEmpty){
                              return("Search field Can't be Empty!!");
                            }
                          },
                          controller: searchController,
                          decoration: InputDecoration(
                              hintText: "search wallpaper",
                              hintStyle: TextStyle(fontSize: 18.0,fontFamily: "Raleway",),
                              border: InputBorder.none,
                              errorStyle: TextStyle(fontSize: 14.0,fontFamily: "Raleway",),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          getSearchWallpapers(searchController.text);
                        },
                        child: Container(child: Icon(Icons.search))),
                  ],
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              wallpaperList(wallpapers: wallpapers, context: context),
            ],
          ),
        ),
      ),
    );
  }
}
