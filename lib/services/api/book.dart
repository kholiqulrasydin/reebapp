import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:reebapp/services/models/book.dart';

class BookApi{

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> readHistoryUpdate(String docId, int lastReadPage, int totalPages) async {
    await _firestore.collection('user').doc(_auth.currentUser!.uid).collection('readHistory').doc(docId).set({
      'lastReadPage': lastReadPage,
      'totalPages': totalPages,
      'lastRead': Timestamp.now()
    });
  }

  static Future<void> addToFavorites(String docId) async {
    DocumentSnapshot docSnap = await _firestore.collection('book').doc(docId).get();
    await _firestore.collection('user').doc(_auth.currentUser!.uid).collection('favorites')
        .doc(docId).set(docSnap.data() as Map<String, dynamic>);
  }

  static Future<void> deleteFromFavorites(String docId) async {
    await _firestore.collection('user').doc(_auth.currentUser!.uid).collection('favorites').doc(docId).delete();
  }

  static Future<List<Book>> mostlyRead() async {
    List<Book> book = [];
    QuerySnapshot snap = await _firestore.collection('book').get();
    QuerySnapshot favSnap = await _firestore.collection('user').doc(_auth.currentUser!.uid).collection('favorites').get();
    QuerySnapshot readHistorySnap = await _firestore.collection('user').doc(_auth.currentUser!.uid).collection('readHistory').get();

    for(int i = 0; i < snap.docs.length; i++){
      DocumentSnapshot data = snap.docs[i];
      String pdfUrl = await getDownloadableAssetLink(data.get('assetPath'));
      String thumbnailUrl = await getDownloadableAssetLink(data.get('imagePath'));
      // print("tessssssss"+readHistorySnap.docs.where((element) => element.id == data.id).first.get('totalPages'));
      Book item = Book(
          docId: data.id,
          name: data.get('name'),
          assetPath: pdfUrl,
          imagePath: thumbnailUrl,
          pages: data.get('pages'),
          rating: data.get('rating'),
          readAloud: data.get('readAloud'),
          readCount: data.get('readCount'),
          createdAt: data.get('createdAt'),
          author: data.get('author'),
          desc: data.get('desc'),
          part: data.get('part'),
          isFavorite: favSnap.docs.isNotEmpty ? favSnap.docs.where((element) => element.id == data.id).isNotEmpty : false,
          lastPageRead: readHistorySnap.docs.isNotEmpty ? readHistorySnap.docs.where((element) => element.id == data.id).isNotEmpty ? readHistorySnap.docs.where((element) => element.id == data.id).first.get('lastReadPage') : 0 : 0,
          totalPages: readHistorySnap.docs.isNotEmpty ? readHistorySnap.docs.where((element) => element.id == data.id).isNotEmpty ? readHistorySnap.docs.where((element) => element.id == data.id).first.get('totalPages') : 0 : 0,
      );
      book.add(item);
    }

    book.sort((i, e) => (i.readCount! as int).compareTo(e.readCount as int));
    List<Book> sortedBook = book.reversed.toList();
    return sortedBook;
  }

  static Future<List<Book>> getAll() async {
    List<Book> book = [];
    QuerySnapshot snap = await _firestore.collection('book').get();
    QuerySnapshot favSnap = await _firestore.collection('user').doc(_auth.currentUser!.uid).collection('favorites').get();
    QuerySnapshot readHistorySnap = await _firestore.collection('user').doc(_auth.currentUser!.uid).collection('readHistory').get();

    for(int i = 0; i < snap.docs.length; i++){
      DocumentSnapshot data = snap.docs[i];
      String pdfUrl = await getDownloadableAssetLink(data.get('assetPath'));
      String thumbnailUrl = await getDownloadableAssetLink(data.get('imagePath'));
      Book item = Book(
        docId: data.id,
        name: data.get('name'),
        assetPath: pdfUrl,
        imagePath: thumbnailUrl,
        pages: data.get('pages'),
        rating: data.get('rating'),
        readAloud: data.get('readAloud'),
        readCount: data.get('readCount'),
        createdAt: data.get('createdAt'),
        author: data.get('author'),
        desc: data.get('desc'),
        part: data.get('part'),
        isFavorite: favSnap.docs.isNotEmpty ? favSnap.docs.where((element) => element.id == data.id).isNotEmpty : false,
        lastPageRead: readHistorySnap.docs.isNotEmpty ? readHistorySnap.docs.where((element) => element.id == data.id).isNotEmpty ? readHistorySnap.docs.where((element) => element.id == data.id).first.get('lastReadPage') : 0 : 0,
        totalPages: readHistorySnap.docs.isNotEmpty ? readHistorySnap.docs.where((element) => element.id == data.id).isNotEmpty ? readHistorySnap.docs.where((element) => element.id == data.id).first.get('totalPages') : 0 : 0,
      );
      book.add(item);
    }

    return book;
  }

  static Future<int> add(Book book, String pdfPath, String thumbnailPath) async {
    int turn = 500;
    String fileName = '${((((pdfPath.split('/')).last)).split('.')).first }.${(pdfPath.split('.')).last}';
    String thumbnailName = '${((((thumbnailPath.split('/')).last)).split('.')).first }.${(thumbnailPath.split('.')).last}';
    try{
      await _firestore.collection('book').add({
        'name': book.name,
        'assetPath': 'book/$fileName',
        'imagePath': 'book/thumbnail/$thumbnailName',
        'pages': book.createdAt,
        'rating': 0,
        'readAloud': book.readAloud,
        'readCount': 0,
        'desc': book.desc,
        'createdAt': Timestamp.now(),
        'author': book.author,
        'desc': book.desc,
        'part': book.part
      });
      await uploadFile(pdfPath, fileName);
      await uploadFile(thumbnailPath, 'thumbnail/'+thumbnailName);
      turn = 200;
    } catch (e){
      print(e.toString());
    }

    return turn;
  }

  static Future<void> update() async {

  }

  static Future<void> delete() async {

  }

  static Future<String> getDownloadableAssetLink(String path) async {
    String link = await _storage.ref(path).getDownloadURL();
    print(link);
    return link;
  }

  static Future<void> uploadFile(String filePath, String fileName) async {
    File file = File(filePath);

    try {
      await _storage.ref('book/$fileName').putFile(file);
    } catch (e) {
      print(e.toString());
    }
  }
}