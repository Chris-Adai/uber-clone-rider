import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uber_clone/models/chat_info.dart';
import 'package:uber_clone/models/driver.dart';
import 'package:uber_clone/providers/profile_pictures_provider.dart';
import 'package:uber_clone/providers/user_data_provider.dart';
import 'package:uber_clone/screens/chat/chat.dart';
class ChatListTile extends StatefulWidget {


  final ChatInfo chatInfo;

  ChatListTile({required this.chatInfo});

  @override
  _ChatListTileState createState() => _ChatListTileState();
}

class _ChatListTileState extends State<ChatListTile> {

  bool isFirstRun = true;



  @override
  void initState() {
    super.initState();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if ( isFirstRun) {

    }

  }

  @override
  Widget build(BuildContext context) {

    File? picture = Provider.of<ProfilePicturesProvider>(context, listen: false).driverProfilePictures![widget.chatInfo.firebaseUserId];
    if(picture == null) {
      picture = Provider.of<ProfilePicturesProvider>(context).driverProfilePictures![widget.chatInfo.firebaseUserId];
    }

  return picture == null ? Container() :
  ElevatedButton(
    onPressed: () async {
      Map<String, dynamic> map = {};
      map['driver'] = Driver.fromChatInfo(widget.chatInfo);
      map['user'] = Provider.of<UserDataProvider>(context, listen: false).userData;
      await Navigator.pushNamed(context, Chat.route, arguments: map);
    },
    style: ElevatedButton.styleFrom(
      primary: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0.0,
      onPrimary: Colors.grey[800],

    ),
    child: Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
              radius: 30.0,
              backgroundColor: Colors.transparent,
              backgroundImage: FileImage(picture)
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                        text: widget.chatInfo.firstName,
                        style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
                        children: [
                          TextSpan( text: ' ' + widget.chatInfo.lastName)
                        ]
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(widget.chatInfo.lastMessage, style: Theme.of(context).textTheme.headline1, overflow: TextOverflow.ellipsis,)
                ],
              ),
            ),
          ),
          Text(timeago.format(widget.chatInfo.lastMessageTimestamp.toDate(), locale: 'en_short'), style: Theme.of(context).textTheme.headline1,)
        ],
      ),
    ),
  );
  }


}
