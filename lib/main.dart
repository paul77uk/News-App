import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/user_response.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const MyHomePage(title: 'FDC News'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    myAmazingAsyncMethod();
    super.initState();
  }

  String firstName = "Still Loading......";
  String? imageUrl;
  List<Articles>? articleList;
  String getUsersUrl =
      "https://gnews.io/api/v4/top-headlines?country=us&token=d9e3edc863e36b5d03fc5b2f77756d00";

  Future myAmazingAsyncMethod() async {
    http.Response response = await http.get(Uri.parse(getUsersUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      NewsResponse userResponse = NewsResponse.fromJson(jsonData);

      // int? page = userResponse.page;
      List<Articles>? articles = userResponse.articles;

      setState(() {
        articleList = articles;
        firstName = articles![0].title!;
        imageUrl = articles[0].image!;
      });
    } else {
      print("OMG INTERNET IS BROKEN");
    }
    // return response;
    // HTTP STATUS CODES ->
    // 200 -> SUCCESSFUL API CALL
    // 404 -> NOT FOUND
    // 500 -> INTERNAL SERVER ERROR
    // 403-> FORBIDDEN
    // 400-> BAD REQUEST
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 2,
        shadowColor: Colors.white70,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Column(
          children: [
            Text(
              widget.title,
              style: TextStyle(
                  fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white70),
            ),
          ],
        ),
        toolbarHeight: 85,
      ),
      body:  articleList != null
          ? ListView.builder(
                  itemCount: articleList?.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                        launchUrl(Uri.parse(articleList![index].url!));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           if (index == 0)  Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Text(
                                "TOP STORIES",
                                style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Stack(
                              children: [
                                Container(
                                  height: 230,
                                  color: Colors.black,
                                ),
                                FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: articleList![index].image!),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                articleList![index].title!,
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                articleList![index].publishedAt!,
                                style: TextStyle(
                                    color: Colors.white38,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                            Divider(
                              thickness: 0.5,
                              color: Colors.white70,
                            ),
                          ],
                        ),
                      ),
                    );
                  }) : Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
