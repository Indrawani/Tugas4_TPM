import 'package:flutter/material.dart';
import 'package:tugas4_tpm/halaman_utama.dart';
import 'package:tugas4_tpm/login_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'data_hotel.dart';

class HalamanDetail extends StatefulWidget {
  final int hotelIndex;

  const HalamanDetail({Key? key, required this.hotelIndex}) : super(key: key);

  @override
  State<HalamanDetail> createState() => _HalamanDetailState();
}

class _HalamanDetailState extends State<HalamanDetail> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final DataHotel detailHotel = hotelList[widget.hotelIndex];
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(detailHotel.name),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) {
                return const HalamanUtama();
              }),
                  (route) => false,
            );
          },
        ),
        centerTitle: true,
      ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            backgroundColor: colorScheme.surface,
            selectedItemColor: Colors.blue,
            unselectedItemColor: colorScheme.onSurface.withOpacity(.60),
            selectedLabelStyle: textTheme.caption,
            unselectedLabelStyle: textTheme.caption,
            onTap: (value) {
              if (value == 1) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              }
              // Respond to item press.
              setState(() => _currentIndex = value);
            },
            items: [
              BottomNavigationBarItem(
                title: Text('Halaman Utama'),
                icon: Icon(Icons.home),
              ),
              BottomNavigationBarItem(
                title: Text('Logout'),
                icon: Icon(Icons.logout),
              ),
            ],
          ),
      body: ListView(children: [
        Column(
          children: [
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    //bisa di slide
                    child: Container(
                      height: MediaQuery.of(context).size.height / 3,
                      child: PageView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Image.network(detailHotel.imageUrl[index]),
                          );
                        },
                        pageSnapping: true,
                        itemCount: detailHotel.imageUrl.length,
                      ),
                    ),
                  ),
                  Text(
                    detailHotel.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < int.parse(detailHotel.stars); i++)
                          const Icon(Icons.star, color: Colors.limeAccent),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 3, 0, 2),
                    child: Text(
                      'Location : ${detailHotel.location}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 3, 0, 2),
                    child: Text(
                      'Price : ${detailHotel.roomPrice}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: SizedBox(height: 400, child: _fasilitas()),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 30),
                child: ElevatedButton(
                    onPressed: () {
                      _launchURL(detailHotel.websiteLink);
                    },
                    child: Text("Website")))
          ],
        ),
      ]),
    ));
  }

  Widget _fasilitas() {
    DataHotel detaiData = hotelList[widget.hotelIndex];
    return ListView.builder(
      itemBuilder: (context, index) {
        return InkWell(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(IconData(
                        int.parse(detaiData.iconFacility[index]),
                        fontFamily: 'MaterialIcons')),
                    title: Text(detaiData.facility[index]),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      itemCount: detaiData.facility.length,
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
