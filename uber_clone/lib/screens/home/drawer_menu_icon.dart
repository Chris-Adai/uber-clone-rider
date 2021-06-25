
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/providers/home_provider.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    bool isShown = Provider.of<HomeProvider>(context).isOverlayShown;

    return ClipOval(
      child: Material(
        color: isShown  ? Colors.transparent : Colors.white,
        child: InkWell(
          splashColor: Colors.black,
          child: SizedBox(
            height: 55,
            width: 55,
            child: Icon(Icons.menu, size: 40, color: !isShown ? Colors.black : Colors.white,),
          ),
          onTap: () => Scaffold.of(context).openDrawer(),
        ),
      ),
    );
  }
}
