import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/user_response.dart';
import 'package:url_launcher/url_launcher.dart';

const List<String> list = <String>[
  'ar',
  'au',
  'at',
  'be',
  'br',
  'bg',
  'ca',
  'cn',
  'co',
  'cu',
  'cz',
  'eg',
  'fr',
  'de',
  'gr',
  'hk',
  'hu',
  'in',
  'id',
  'ie',
  'il',
  'it',
  'jp',
  'lv',
  'lt',
  'my',
  'mx',
  'ma',
  'nl',
  'nz',
  'ng',
  'no',
  'ph',
  'pl',
  'pt',
  'ro',
  'ru',
  'sa',
  'rs',
  'sg',
  'sk',
  'si',
  'za',
  'kr',
  'se',
  'ch',
  'tw',
  'th',
  'tr',
  'ae',
  'ua',
  'gb',
  'us',
  've',
];

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
  @override
  void initState() {
    getRequestMethod();
    textController = TextEditingController(text: '');
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  // String firstName = "Still Loading......";
  // String? imageUrl;
  List<Articles>? articleList;
  String country = "us";
  String getUsersUrl =
      "https://gnews.io/api/v4/top-headlines?country=gb&token=6f7b64d2d3e976d1346acfa5f4a19c2e";
  late TextEditingController textController;
  String endPoint = "top-headlines?";
  bool showButton = false;

  Future getRequestMethod() async {
    getUsersUrl =
        "https://gnews.io/api/v4/$endPoint&country=$country&token=6f7b64d2d3e976d1346acfa5f4a19c2e";
    http.Response response = await http.get(Uri.parse(getUsersUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      NewsResponse userResponse = NewsResponse.fromJson(jsonData);
      showButton = false;

      // int? page = userResponse.page;
      List<Articles>? articles = userResponse.articles;

      setState(() {
        articleList = articles;
        // firstName = articles![0].title!;
        // imageUrl = articles[0].image!;
      });
    } else {
      print("OMG INTERNET IS BROKEN");
      showButton = true;
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                iconSize: 0,
                value: country,
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    country = value!;
                    getRequestMethod();
                  });
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: SvgPicture.network(
                      "https://newsapi.org/images/flags/$value.svg",
                      height: 35,
                      width: 35,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
        elevation: 2,
        shadowColor: Colors.white70,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Column(
          children: [
            Text(
              widget.title,
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70),
            ),
          ],
        ),
        toolbarHeight: 85,
      ),
      body: articleList != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CupertinoSearchTextField(
                    controller: textController,
                    onChanged: (value) {
                      endPoint = "search?q=$value";
                      getUsersUrl =
                          "https://gnews.io/api/v4/$endPoint&country=$country&token=6f7b64d2d3e976d1346acfa5f4a19c2e";
                      getRequestMethod();
                    },
                    style: TextStyle(fontSize: 20, color: Colors.white70),
                    itemSize: 20,
                    itemColor: Colors.white30,
                    padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: articleList?.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              launchUrl(Uri.parse(articleList![index].url!));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (index == 0)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: Text(
                                      "TOP STORIES",
                                      style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                if (articleList?[index].image != null)
                                  Image.network(articleList![index].image!),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    articleList![index].title!,
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
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
                          );
                        }),
                  ),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
