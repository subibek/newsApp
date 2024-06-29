
import 'package:flutter/material.dart';
import 'package:news/consts.dart';
import 'package:news/data/news_db.dart';
import 'package:news/pages/details_page.dart';

import '../models/article.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePage();
}

class _FavoritePage extends State<FavoritePage> {

  Future<List<Article>>? futureArticles;
  final newsDB = NewsDb();

  @override 
  void initState(){
    super.initState();

    fetchNews();
  }

  void fetchNews() {
    setState(() {
      futureArticles = newsDB.fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) {

    final newsDB = NewsDb();

    return Scaffold(
      appBar: AppBar(
          title: Center(child: Text('Favorites', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),)),
          elevation: 0.0,

        ),
        //implementation of article tiles for the deatails page
        body: Padding(
          padding: EdgeInsets.only(left: 5, right: 5, top: 5),
          child: FutureBuilder<List<Article>>(
            future: futureArticles,
            builder: (context, snapshot){
              if (snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator());
              }else {
                
                final articles = snapshot.data;
          
                return (articles!.isEmpty)? 
                  const Center(child: Text(
                    'No Favorites',
                    style: TextStyle(fontWeight: FontWeight.bold,
                    fontSize: 22),
                    ),
                    ) 
                    : ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(height: 5),
                      itemCount: articles.length,
                      itemBuilder: (context, index){
                        final article = articles[index];
                         return articleTile(context, article, articles, index, newsDB);
                      }, 
                       
                      );
          
              }
            },
            ),
        )
      );
  }

  GestureDetector articleTile(BuildContext context, Article article, List<Article> articles, int index, NewsDb newsDB) {
    return GestureDetector(
                  onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => 
                            DetailsPage(
                              article.source,
                              article.author, 
                              article.title, 
                              article.description, 
                              article.url, 
                              article.urlToImage, 
                              article.publishedAt.toString(), 
                              article.content
                            )));
                          },
                  child: Container(
                    height: 120,
                    width: MediaQuery.of(context).size.width,
                    child:  Row(
                        children: [
                          Container(
                            height: 100,
                            width: 120,
                            decoration: BoxDecoration(
                              image: DecorationImage(image: 
                                  NetworkImage(article.urlToImage ?? PLACEHOLDER_IMAGE_LINK), 
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10,top: 5),
                            height: 140,
                            width: MediaQuery.of(context).size.width- 190,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article.title!.length > 110 ? article.title!.substring(0,article.title!.length - 20) : article.title!,
                                style: TextStyle(fontSize: 12, 
                                        fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                              Text(article.author!,style: TextStyle(fontSize: 12),)
                            ],
                          )
                            ,
                          ),
                          GestureDetector(
                            onTap: () async {
                                
                              Article art = Article(
                              source : articles[index].source,
                              author : articles[index].author,
                              title : articles[index].title,
                              description : articles[index].description,
                              url : articles[index].url,
                              urlToImage : articles[index].urlToImage,
                              publishedAt :articles[index].publishedAt,
                              content : articles[index].content
                            );
                              
                              String snackMessage;
                              Color? snackColor;
                              

                              try{
                                  await newsDB.delete(art);
                                  snackMessage =  "Removed from favorites successfully";
                                  snackColor = Colors.orange[400];
                                      }catch(e){
                                  snackMessage = " Error occured ";
                                  
                                  snackColor = Colors.red[400];
                              }
                              fetchNews();
                              final snackbar = SnackBar(
                                content: Text(snackMessage),
                                backgroundColor: snackColor,
                                elevation: 10,
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.all(5),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackbar);
                            },
                            child: Icon(Icons.delete),
                          )
                        ],
                      ),
                    ),
                );
  }
}