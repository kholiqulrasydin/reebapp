import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import 'package:reebapp/consttants.dart';
import 'package:reebapp/screens/details_screen.dart';
import 'package:reebapp/screens/reader.dart';
import 'package:reebapp/services/api/authentication.dart';
import 'package:reebapp/services/api/book.dart';
import 'package:reebapp/services/models/book.dart';
import 'package:reebapp/services/wrapper.dart';
import 'package:reebapp/widgets/book_rating.dart';
import 'package:reebapp/widgets/reading_card_list.dart';
import 'package:reebapp/widgets/two_side_rounded_button.dart';

import 'package:flutter/material.dart';

import 'components/sizeconfig.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Book> ? book;
  bool isLoggingOut = false;

  void initData() async {
    List<Book> bookList = [];
    bookList = await BookApi.mostlyRead();
    setState((){
      book = bookList;
    });
  }

  setLoggingOut(){
    setState((){
      isLoggingOut = !isLoggingOut;
    });
  }
  
  bool getTrue(){
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    initData();
    super.initState();
  }

  Future<void> refresh() async {
    initData();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(239, 246, 226, 1.0),
      body: SafeArea(
        child: isLoggingOut ? Splash(text: "Logging out\nErasing temp") : book != null ? book!.isEmpty ? const Center(child: Text("Buku kosong"),) : RefreshIndicator(
          onRefresh: refresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: SizeConfig.getSize(context, heightPercent: 2).height),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.headline5,
                                children: [
                                  TextSpan(
                                      text: "What are you \nreading ",
                                    style: TextStyle(
                                        color: kTextBoldColor,
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),
                                  TextSpan(
                                      text: "today?",
                                      style: TextStyle(
                                        color: kTextBoldColor,
                                        fontWeight: FontWeight.bold,
                                      ))
                                ],
                              ),
                            ),
                            IconButton(onPressed: () async { setLoggingOut(); await Authentication.signOut(); Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Wrapper()));}, icon: Icon(Icons.logout, color: kBlackColor,))
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        height: SizeConfig.getSize(context, heightPercent: 32.5).height,
                        width: double.infinity,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics()
                          ),
                          scrollDirection: Axis.horizontal,
                          itemCount: book!.length,
                          itemBuilder: (context, index){
                            final item = book![index];
                            return ReadingListCard(
                              image: item.imagePath!,
                              title: item.name!,
                              auth: item.author!,
                              rating: item.rating!,
                              isFavorite: item.isFavorite ?? false,
                              isRead: item.lastPageRead != 0,
                              pressFavorite: () async {
                                if(!(item.isFavorite ?? false)){
                                  await BookApi.addToFavorites(item.docId!);
                                  setState((){
                                    book![index].isFavorite = true;
                                  });
                                }else{
                                  await BookApi.deleteFromFavorites(item.docId!);
                                  setState((){
                                    book![index].isFavorite = false;
                                  });
                                }
                              },
                              // sizeConfig: SizeConfig.getSize(context, widthPercent: 40, heightPercent: 60),
                              pressDetails: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return DetailsScreen(book: item,);
                                    },
                                  ),
                                );
                              },
                              pressRead: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (contex) => Reader(book: item, initialPage: item.lastPageRead == 0 ? 1 : item.lastPageRead,)));
                              },
                            );
                          },
                        ),
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
                                      text: "Best of the ",
                                    style: TextStyle(
                                        color: kTextBoldColor,
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),
                                  TextSpan(
                                    text: "day",
                                    style: TextStyle(
                                        color: kTextBoldColor,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if(book!.first.rating! > 4.4)
                              bestOfTheDayCard(size, context, book!.first),
                            RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.headline5,
                                children: [
                                  TextSpan(
                                      text: "Continue ",
                                    style: TextStyle(
                                        color: kTextBoldColor,
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),
                                  TextSpan(
                                    text: "reading...",
                                    style: TextStyle(
                                        color: kTextBoldColor,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if(book!.where((element) => element.lastPageRead != 0 && element.totalPages != 0).toList().isNotEmpty)
                              SizedBox(
                                height: SizeConfig.getSize(context, heightPercent: 15).height,
                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                    itemCount: book!.where((element) => element.lastPageRead != 0 && element.totalPages != 0).toList().length,
                                    itemBuilder: (context, index){
                                      final item = book!.where((element) => element.lastPageRead != 0 && element.totalPages != 0).toList()[index];
                                      return ReadHistoryItem(size: size, book: item,);
                                    }
                                ),
                              ),
                            SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ) : const Center(child: CircularProgressIndicator(color: kBlackColor,)),
      ),
    );
  }

  Container bestOfTheDayCard(Size size, BuildContext context, Book book) {
    bool isRead = book.lastPageRead != 0;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      height: 245,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 24,
                top: 24,
                right: size.width * .35,
              ),
              height: 230,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFFCFCFC),
                borderRadius: BorderRadius.circular(29),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text(
                      "Indonesia Best For ${DateFormat('dd-M-yyyy').parse(DateTime.now().toString())}",
                      style: TextStyle(
                        fontSize: 9,
                        color: kLightBlackColor,
                      ),
                    ),
                  ),
                  Text(
                    book.name!,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    book.author!,
                    style: TextStyle(color: kLightBlackColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: BookRating(score: 4.9),
                        ),
                        Expanded(
                          child: Text(
                            book.desc!,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              color: kLightBlackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Image.network(
              book.imagePath!,
              width: size.width * .37,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SizedBox(
              height: 40,
              width: size.width * .3,
              child: TwoSideRoundedButton(
                text: isRead ? "Resume" : "Read",
                radious: 24,
                press: () {},
                color: isRead ? kProgressIndicator : kBlackColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReadHistoryItem extends StatelessWidget {
  const ReadHistoryItem({
    Key? key,
    required this.size,
    required this.book
  }) : super(key: key);

  final Size size;
  final Book book;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Container(
          height: 80,
          width: double.infinity,
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(38.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding:
                    EdgeInsets.only(left: 30, right: 20),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.end,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                book.name!,
                                style: TextStyle(
                                    color: kTextBoldColor,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                book.author!,
                                style: TextStyle(
                                  color: kLightBlackColor,
                                ),
                              ),
                              Align(
                                alignment:
                                Alignment.bottomRight,
                                child: Text(
                                  "last read ${book.lastPageRead} of ${book.totalPages}",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: kLightBlackColor,
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                            ],
                          ),
                        ),
                        Image.network(
                          book.imagePath!,
                          width: 55,
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 7,
                  width: size.width * (book.lastPageRead! / book.totalPages!),
                  decoration: BoxDecoration(
                    color: kProgressIndicator,
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
