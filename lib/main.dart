import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:news_api_flutter_app/widgets/category.dart';

import 'models/article_model.dart';
import 'models/category_models.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NewsAPI(),
    );
  }
}

class NewsAPI extends StatefulWidget {
  const NewsAPI({Key? key}) : super(key: key);

  @override
  State<NewsAPI> createState() => _NewsAPIState();
}

class _NewsAPIState extends State<NewsAPI> {
  Future getNews() async {
    var response = await get(Uri.https('https://newsapi.org/v2/',
        'top-headlines?country=us&category=business&apiKey=8432db45c70f45f091db088e634a017c'));
    var responseData = jsonDecode(response.body);
    List news = [];
    if (responseData['status'] == 'ok') {
      responseData['articles'].forEach((index) {
        if (index['urlToImage'] != null && index['description'] != null) {
          ArticleModel articleModel = ArticleModel(
              author: index['author'],
              title: index['title'],
              description: index['description'],
              url: index['url'],
              urlToImage: index['urlToImage'],
              content: index['content'],
              publishedAt: index['publishedAt']);
          news.add(articleModel);
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2c2f30),
      appBar: AppBar(
        backgroundColor: const Color(0xff2c2f30),
        title: Row(
          children: const [
            Text(
              'Flutter',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'News APP',
              style: TextStyle(color: Color(0xff21B2BB)),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {},
            child: SizedBox(
              height: 100,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: categoryList.length,
                itemBuilder: (context, index) {
                  return CategoryButton(
                    imageUrl: categoryList[index].imageUrl,
                    categoryName: categoryList[index].categoryName,
                  );
                },
              ),
            ),
          ),
          FutureBuilder(
              future: getNews(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return CircularProgressIndicator();
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (contex, index) {
                        return Column(
                          children: [
                            Image.network(snapshot.data[index].urlToImage)
                          ],
                        );
                      });
                }
              })
        ],
      ),
    );
  }
}
