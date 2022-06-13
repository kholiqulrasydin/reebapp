import 'package:reebapp/consttants.dart';
import 'package:reebapp/screens/components/sizeconfig.dart';
import 'package:reebapp/screens/reader.dart';
import 'package:reebapp/services/api/book.dart';
import 'package:reebapp/services/models/book.dart';
import 'package:reebapp/widgets/book_rating.dart';
import 'package:reebapp/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  final Book book;
  const DetailsScreen({Key? key, required this.book}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool isFavorite = false;
  String bookTitle = "";

  @override
  void initState() {
    // TODO: implement initState
    isFavorite = widget.book.isFavorite!;
    setBookTitle();
    super.initState();
  }

  void favSet() async {
    if(!isFavorite){
      await BookApi.addToFavorites(widget.book.docId!);
    }else{
      await BookApi.deleteFromFavorites(widget.book.docId!);
    }
    setState((){
      isFavorite = !isFavorite;
    });
  }

  void setBookTitle(){
    if(widget.book.name!.contains(" ") && widget.book.name!.split(" ").length > 2){
      var conn = StringBuffer();
      List.generate(widget.book.name!.split(" ").length, (index) => index > 0 ? widget.book.name!.split(" ")[index]+" " : "")
          .toList().forEach((element) {conn.write(element);});
      setState((){
        bookTitle = conn.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics()
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(top: size.height * .12, left: size.width * .1, right: size.width * .02),
                  height: size.height * .48,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/bg.png"),
                      fit: BoxFit.fitWidth,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: BookInfo(size: size, book: widget.book, onPressed: favSet, title: bookTitle, isFav: isFavorite, readPress: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (contex) => Reader(book: widget.book, initialPage: 1,)));
                  },)
                ),
                Container(
                  margin: EdgeInsets.only(top: size.height * .48 - 20, bottom: size.height * .05 - 20),
                  height: SizeConfig.getSize(context, heightPercent: 20 * (widget.book.part!.length + .0)).height,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                      itemCount: widget.book.part!.length,
                      itemBuilder: (context, index){
                        final item = widget.book.part![index];
                        return ChapterCard(
                          name: item['title'],
                          chapterNumber: index+1,
                          tag: item['desc'],
                          press: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (contex) => Reader(book: widget.book, initialPage: item['page'],)));
                          },
                        );
                      }
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.headline5,
                      children: [
                        TextSpan(
                          text: "You might also ",
                        ),
                        TextSpan(
                          text: "like….",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 180,
                        width: double.infinity,
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding:
                              EdgeInsets.only(left: 24, top: 24, right: 150),
                          height: 160,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(29),
                            color: Color(0xFFFFF8F9),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(color: kBlackColor),
                                  children: [
                                    TextSpan(
                                      text:
                                          "How To Win \nFriends & Influence \n",
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "Gary Venchuk",
                                      style: TextStyle(color: kLightBlackColor),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  BookRating(
                                    score: 4.9,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: RoundedButton(
                                      text: "Read",
                                      verticalPadding: 10,
                                      press: () {  },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Image.asset(
                          "assets/images/book-3.png",
                          width: 150,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}


class ChapterCard extends StatelessWidget {
  final String name;
  final String tag;
  final int chapterNumber;
  final Function() press;
  const ChapterCard({
    Key ? key,
    required this.name,
    required this.tag,
    required this.chapterNumber,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      margin: EdgeInsets.only(bottom: 16),
      width: size.width - 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(38.5),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 33,
            color: Color(0xFFD3D3D3).withOpacity(.84),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$name \n",
                  style: TextStyle(
                    fontSize: 16,
                    color: kBlackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: tag,
                  style: TextStyle(color: kLightBlackColor),
                ),
              ],
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              size: 18,
            ),
            onPressed: press,
          )
        ],
      ),
    );
  }
}

class BookInfo extends StatelessWidget {
  
  const BookInfo({
    Key ? key,
    required this.size,
    required this.book,
    this.onPressed,
    required this.title,
    required this.isFav,
    this.readPress
  }) : super(key: key);

  final Size size;
  final Book book;
  final Function() ? onPressed;
  final String title;
  final bool isFav;
  final Function() ? readPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Flex(
        crossAxisAlignment: CrossAxisAlignment.start,
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    (book.name!.contains(" ") && book.name!.split(" ").length > 2) ? book.name!.split(" ").first : book.name!,
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                      fontSize: 28
                    ),
                  ),
                ),
                if(book.name!.contains(" ") && book.name!.split(" ").length > 2)
                  Container(
                    margin: EdgeInsets.only(top: this.size.height * .005),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 0),
                    child: Text(
                      this.title,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: this.size.width * .3,
                          padding: EdgeInsets.only(top: this.size.height * .02),
                          child: Text(
                            book.desc!,
                            maxLines: 5,
                            style: TextStyle(
                              fontSize: 10,
                              color: kLightBlackColor,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: this.size.height * .015),
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: MaterialButton(
                            onPressed: readPress,
                            child: Text("Read", style: TextStyle(fontWeight: FontWeight.bold),),
                          ), 
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              size: 20,
                              color: isFav? Colors.redAccent : Colors.grey,
                            ),
                            onPressed: onPressed,
                        ), 
                        BookRating(score: book.rating!),
                      ],
                    )
                  ],
                )
              ],
            )
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.transparent,
              child: Image.network(
                book.imagePath!,
                height: double.infinity,
                alignment: Alignment.topRight,
                fit: BoxFit.fitWidth,
              ),
          )),
        ],
      ),
    );
  }
}

