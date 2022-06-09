import 'package:cloud_firestore/cloud_firestore.dart';

class Book{
  final String ? name;
  final String ? assetPath;
  final String ? imagePath;
  final int ? pages;
  final double ? rating;
  final bool ? readAloud;
  final int ? readCount;
  final String ? desc;
  final Timestamp ? createdAt;
  final String ? author;

  Book({
      this.name,
      this.assetPath,
      this.pages,
      this.rating,
      this.readAloud,
      this.readCount,
      this.imagePath,
      this.desc,
      this.createdAt,
      this.author
  });


}