import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';
import 'package:reebapp/consttants.dart';
import 'package:reebapp/services/api/book.dart';
import 'package:reebapp/services/models/book.dart';

class Reader extends StatefulWidget {
  final Book book;
  final int ? initialPage;
  const Reader({Key? key, required this.book, this.initialPage}) : super(key: key);

  @override
  State<Reader> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  PdfController ? pdfController;
  String pageNum = " / ";

  @override
  void initState() {
    // TODO: implement initState
    pdfController = PdfController(
        document: PdfDocument.openData(InternetFile.get(widget.book.assetPath!)),
        initialPage: widget.initialPage ?? 1
    );
    pageNum = "${widget.initialPage ?? 1}/ ";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.book.name!, overflow: TextOverflow.ellipsis,),
        backgroundColor: Colors.white,
        foregroundColor: kBlackColor,
        elevation: 0,
        actions: [
          Text(pageNum, style: const TextStyle(fontSize: 16),)
        ],
      ),
      body: pdfController == null ? const Center(child: CircularProgressIndicator(color: kBlackColor,),) : PdfView(
          controller: pdfController!,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        onDocumentLoaded: (doc){
          setState((){
            pageNum = "${pageNum.split("/").first}/${doc.pagesCount}";
          });
        },
        onPageChanged: (page) async {
            await BookApi.readHistoryUpdate(widget.book.docId!, page, int.parse(pageNum.split("/").last));
            setState((){
              pageNum = "$page/${pageNum.split("/").last}";
            });
        },
      ),
    );
  }
}
