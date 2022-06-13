import 'package:flutter/material.dart';
import 'package:reebapp/consttants.dart';
import 'package:reebapp/screens/components/sizeconfig.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateScreen extends StatefulWidget {
  final String updateUrl;
  const UpdateScreen({Key? key, required this.updateUrl}) : super(key: key);

  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {

  String urlUpdate = "";

  @override
  void initState() {
    getDownloadUrl();
    super.initState();
  }

  void getDownloadUrl() async {
    String _url = widget.updateUrl;
    setState(() => urlUpdate = _url);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: Container(
                height: SizeConfig.getSize(context, heightPercent: 90).height,
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.getSize(context, widthPercent: 10).width!),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: SizeConfig.getSize(context, heightPercent: 25).height,
                      child: Image.asset('assets/images/update.png'),
                    ),
                    SizedBox(height: SizeConfig.getSize(context, heightPercent: 3).height),
                    Text(
                      "Mohon perbaharui aplikasi anda untuk tetap bisa menggunakan layanan ini",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: SizeConfig.getSize(context, heightPercent: 1).height),
                    GestureDetector(
                      onTap: () async {
                        await launchUrl(Uri.parse(urlUpdate));
                      },
                      child: Text("Download Pembaharuan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: kBlackColor)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}