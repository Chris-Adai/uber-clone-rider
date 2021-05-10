
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/providers/home_provider.dart';
class RideNow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return Positioned(
     top: 100,
     left: 20,
     child: Container(
       decoration: BoxDecoration(
           borderRadius: BorderRadius.only(
             topRight: Radius.circular(20),
             topLeft: Radius.circular(20),
           )
       ),
       child: Container(
         margin: EdgeInsets.only(top: 10),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           children: [
             Text("Ready when you are", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500, letterSpacing: 0.8, fontFamily: 'OnePlusSans'),),
             Container(
               margin: EdgeInsets.only(top: 10),
               child: LimitedBox(
                 maxWidth: MediaQuery.of(context).size.width * 0.7,
                 child: Text('Here to help you move safely in the new every day', style: TextStyle(color: Colors.white, fontSize: 16), maxLines: 2,)
               ),
             ),
             GestureDetector(
               onTap: () => Provider.of<HomeProvider>(context, listen: false).updateOverlay(),
               child: Container(
                 margin: EdgeInsets.only(top: 10),
                 padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                 decoration: BoxDecoration(
                   color: Colors.black,
                   borderRadius: BorderRadius.circular(20)
                 ),
                 child: Center(child: Text('Ride now', style: TextStyle(color: Colors.white),))
               ),
             ),
           ],
         ),
       ),
     ),
   );
  }
}
