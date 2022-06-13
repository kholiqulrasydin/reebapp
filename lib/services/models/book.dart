import 'package:cloud_firestore/cloud_firestore.dart';

class Book{
  final String ? docId;
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
  bool ? isFavorite;
  final List ? part;
  final int ? lastPageRead;
  final int ? totalPages;

  Book({
      this.docId,
      this.name,
      this.assetPath,
      this.pages,
      this.rating,
      this.readAloud,
      this.readCount,
      this.imagePath,
      this.desc,
      this.createdAt,
      this.author,
      this.isFavorite,
      this.part,
      this.lastPageRead,
      this.totalPages
  });


}