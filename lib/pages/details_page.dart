import 'package:flutter/material.dart';
import 'package:news/consts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/news_db.dart';
import '../models/article.dart';

class DetailsPage extends StatefulWidget { 
  final String? source;
  final String? author;
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;

  DetailsPage(
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content
    );

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {

  final newsDB = NewsDb();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            topContainer(context),
            titleText(),
            detailPageBody(context)
          ],
        ),
      )
    );
  }

  Container detailPageBody(BuildContext context) {
    return Container(
            margin: EdgeInsets.only(left: 10,right: 10,top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.author!,
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,color: Colors.green[300]),
                ),
                    Text(widget.publishedAt!.substring(0,widget.publishedAt!.length-10),
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,color: Colors.green[300]),
                ),
                  ],
                
                ),
                SizedBox(height: 20),
                Text(
                  widget.description!,
                  style: TextStyle(
                    fontSize: 16,
                    
                  ),
                  ),
                  SizedBox(height: 5),
                  
                Text(widget.content!.substring(0,widget.content!.length-13),style: TextStyle(fontSize: 16)),
                SizedBox(height: 33),
                readArticleButton(context),
              SizedBox(height: 44)
              ],
            ),
          );
  }

  GestureDetector readArticleButton(BuildContext context) {
    return GestureDetector(
              onTap: () async {
                final url = widget.url!;
                if (!await launchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Container(
                height: 44,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.green[300]
                ),
                child: Center(child: Text('Read Full Article',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                ),
              
            );
  }

  Padding titleText() {
    return Padding(
            padding: EdgeInsets.only(left: 10,right: 10,top: 10),
            child: Text(
              widget.title!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black
              ),
              ),
          );
  }

  GestureDetector addToFavoriteButton(NewsDb newsDB, BuildContext context) {
    return GestureDetector(
                                  onTap: ()async {
                                    Article art = Article(
                                    source : widget.source,
                                    author : widget.author,
                                    title : widget.title,
                                    description : widget.description,
                                    url : widget.url,
                                    urlToImage : widget.urlToImage,
                                    publishedAt :widget.publishedAt,
                                    content : widget.content
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
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 5,top: 24),
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
                                        ),
                                );
  }

  Container topContainer(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(widget.urlToImage ?? PLACEHOLDER_IMAGE_LINK),
          fit: BoxFit.cover
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              backButton(context),
              addToFavoriteButton(newsDB, context),
            ],
          ),
        ],
      ),
    );
  }

  GestureDetector backButton(BuildContext context) {
    return GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.only(left: 5, top: 24),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey
              ),
              child: Icon(Icons.arrow_back,color: Colors.white),
            ),
          ),
        );
  }
}