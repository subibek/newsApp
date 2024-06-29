import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:news/consts.dart';
import 'package:news/data/news_db.dart';
import '../models/article.dart';
import 'details_page.dart';

class HomePage extends StatefulWidget {
  final Article? article;

  const HomePage({
    Key? key,
    this.article
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {

  final newsDB = NewsDb();
  
  final Dio dio = Dio();
  List<Article> articles = []; 
  List<Article> allArticles = [];
  bool _isLoading = true;
 

  @override
  void initState(){
    super.initState();
    _getNews();
    _getAllArtiles();
  }

  @override
  Widget build(BuildContext context) {
    return 
    //implementation of the different widgets in the home page
      Scaffold(
        appBar: AppBar(
          title: Center(child: Text('HOME', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),)),
          
          elevation: 0.0,

        ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    topHeadlinesText(),
                    SizedBox(height: 4),
                    topHeadlinesTile(),
                    SizedBox(height: 10),
                    allNewsText(),
                    SizedBox(height: 4),
                    allNewsTile()
                  ],
              
                ),
          ),

      );
  }

  Container allNewsTile() {
    return Container(
              child: _isLoading ? Center(child: CircularProgressIndicator(),) : ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 10), 
                itemCount: allArticles.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index){
                  final article = allArticles[index];
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
                      height: 150,
                      child: Padding(
                    
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          children: [
                            Container(
                              height: 140,
                              width: 150,
                              decoration: BoxDecoration(
                                image: DecorationImage(image: 
                                    NetworkImage(article.urlToImage ?? PLACEHOLDER_IMAGE_LINK), 
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              height: 140,
                              width: MediaQuery.of(context).size.width- 190,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  article.title!.length > 110 ? article.title!.substring(0,article.title!.length - 20) : article.title!,
                                  style: TextStyle(fontSize: 16, 
                                          fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                Text(article.author!)
                              ],
                            )
                              ,
                            )
                          ],
                        ),
                      ),
                      ),
                  );
                },
                
                )
            );
  }

  Container allNewsText() {
    return Container(
            margin: EdgeInsets.only(left: 20,top: 10),
            child: Text(
              'ALL NEWS',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
          );
  }

  Container topHeadlinesTile() {
    return Container(
              margin: EdgeInsets.only(left: 20, right: 10),
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 350,
                        width: MediaQuery.of(context).size.width,
                        child: _isLoading ? Center(child: CircularProgressIndicator(),) :ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(width: 15,), 
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: articles.length,
                      itemBuilder: (context, index){
                        final article = articles[index];
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(context, new MaterialPageRoute(
                            builder: (context) => DetailsPage(
                              articles[index].source,
                              articles[index].author, 
                              articles[index].title, 
                              articles[index].description, 
                              articles[index].url, 
                              articles[index].urlToImage, 
                              articles[index].publishedAt.toString(), 
                              articles[index].content)
                        )
                      );
                          },
                          child: Container(
                              width: 280,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(article.urlToImage!),
                                  fit: BoxFit.cover
                                  ),
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(28)
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    addToFavoriteButton(index, context),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                      article.title!,
                                        style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22
                                  ),
                                ),
                                Text(
                                    article.author!,
                                    style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(
                                    article.publishedAt!.substring(0,article.publishedAt!.length-10),
                                    style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12
                                    ),
                                  ),
                                      ],
                                    )
                                  
                                  
                                  
                                  ],
                                ),
                              )
                          ),
                        );
                            }
                            ),              )
                  ],),
              ),
              );
  }

  GestureDetector addToFavoriteButton(int index, BuildContext context) {
    return GestureDetector(
                                    onTap: ()async {
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
                                        await newsDB.create(article: art);
                                        snackMessage =  "Added to favorites successfully";
                                        snackColor = Colors.green[300];
                                      }catch(e){
                                        snackMessage = " Error occured ";
                                      
                                        snackColor = Colors.red[400];
                                      }

                                      final snackbar = SnackBar(
                                      content: Text(snackMessage),
                                      backgroundColor: snackColor,
                                      elevation: 10,
                                      behavior: SnackBarBehavior.floating,
                                      margin: EdgeInsets.all(5),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                                          },
                                          child: Container(
                                            height: 44,
                                            width: 44,
                                            alignment: Alignment.topRight,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.green[300],
                                              ),
                                              child: Center(child: Icon(Icons.favorite_border_outlined)),
                                          ),
                                  );
  }

  Container topHeadlinesText() {
    return Container(
              margin: EdgeInsets.only(left: 20,top: 10),
              child: Text(
                'TOP HEADLINES',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
            );
  }

// methods to retrieve data from api

  Future<void> _getNews() async {
    final response = await dio.get('https://newsapi.org/v2/top-headlines?country=us&apiKey=${NEWS_API_KEY}',
    );
    
    final articlesJson = response.data['articles'] as List;

    if(mounted){
      setState(() {
      _isLoading = false;
      articles = articlesJson.map((e) => Article.fromJson(e)).toList();
      //make do way for selecting not null values from the list of data
      articles = articles.where((a) => a.title != '[Removed]' && a.author != null && a.publishedAt != null && a.url != null && a.urlToImage != null ).toList();
    });
    }
  

  }

  Future<void> _getAllArtiles() async {
    final response = await dio.get('https://newsapi.org/v2/everything?q=bitcoin&apiKey=${NEWS_API_KEY}',
    );
    
    final articlesJson = response.data['articles'] as List;

    if(mounted){
      setState(() {
      allArticles = articlesJson.map((e) => Article.fromJson(e)).toList();
      allArticles = allArticles.where((a) => a.title != '[Removed]' && a.author != null && a.publishedAt != null && a.url != null && a.urlToImage != null ).toList();
    });
    }
  

  }
}