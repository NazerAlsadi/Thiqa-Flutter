import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../providers/advertises.dart';


class CarousalImg extends StatefulWidget {
  @override
  _CarousalImgState createState() => _CarousalImgState();
}

class _CarousalImgState extends State<CarousalImg> {
  var _isInit = true;
  // ignore: unused_field
  int _current = 0;

  @override
  void didChangeDependencies() {
    if(_isInit){
      Provider.of<Advertises>(context).fetchAdvertises();
    }
    _isInit =false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final advProvider = Provider.of<Advertises>(context);
  
    List loadedList = advProvider.advertises;
    //print(loadedList.length);
   

    return Column(
      children: [
        Container(
          child: loadedList.length == 0 ? Container():
           CarouselSlider.builder(
            itemCount: loadedList.length,
            itemBuilder: (BuildContext context, int itemIndex) => Container(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: ClipRRect(
                //borderRadius: BorderRadius.circular(20),
                
                child: Image.network(
                 'http://thiqa-az.com/upload/advertise_imgs/'+(loadedList[itemIndex].pictureUrl).toString()
                 ,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            options: CarouselOptions(
                height: 150,
                viewportFraction: 1,
                autoPlay: true,
                // aspectRatio: 1.0,
                onPageChanged: (index, reason) {
                  setState(() {
                   // print(index);
                    _current = index;
                  });
                }),
          ),
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: loadedList.map((url) {
        //     int index = loadedList.indexOf(url);
        //     return Container(
        //       width: 10.0,
        //       height: 10.0,
        //       margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        //       decoration: BoxDecoration(
        //         shape: BoxShape.circle,
        //         color: _current == index ? Colors.blue[700] : Colors.grey,
        //       ),
        //     );
        //   }).toList(),
        // ),
      ],
    );
  }
}
