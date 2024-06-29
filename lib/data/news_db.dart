import 'dart:async';
import 'package:news/data/database_service.dart';
import 'package:news/models/article.dart';
import 'package:sqflite/sqflite.dart';

//creating the methods to insert,fetch and delete data from the database

class NewsDb {
  final tableName = 'news';

  Future<void> createTable(Database database) async {
    await database.execute(""" CREATE TABLE IF NOT EXISTS $tableName (
    "source" TEXT NOT NULL,
    "author"  TEXT NOT NULL,
    "title"   TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "url" TEXT NOT NULL ,
    "urlToImage"  TEXT NOT NULL,
    "publishedAt" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    PRIMARY KEY("publishedAt")
    );
      """);
  }

  Future<int> create({required Article article}) async {
    final database = await DatabaseService().database;
    return await database.rawInsert(
      '''INSERT INTO $tableName (source, author, title, description,
       url, urlToImage, publishedAt, content) VALUES (?,?,?,?,?,?,?,?) ON CONFLICT (publishedAt) DO NOTHING''',
       [article.source, article.author, article.title, article.description,
       article.url, article.urlToImage, article.publishedAt,article.content],
       
    );
  }

  Future<List<Article>> fetchAll() async {
    final database = await DatabaseService().database;
    final articles = await database.rawQuery(
      ''' SELECT * from $tableName ''');
      return articles.map((article) => Article.fromSqfliteDatabase(article)).toList();
  }

  Future<void> delete(Article article) async {
    final database = await DatabaseService().database;
    await database.rawDelete('''DELETE FROM $tableName WHERE publishedAt=?''', [article.publishedAt]);
  }
}