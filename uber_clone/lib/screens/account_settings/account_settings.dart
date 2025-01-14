
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/components/authentication_wrapper.dart';
import 'package:uber_clone/models/google_place.dart';
import 'package:uber_clone/models/user_data.dart';
import 'package:uber_clone/providers/profile_pictures_provider.dart';
import 'package:uber_clone/providers/settings/account_settings.dart';
import 'package:uber_clone/providers/user_data_provider.dart';
import 'package:uber_clone/screens/favorites_search//where_to_search.dart';
import 'package:uber_clone/services/firebase/authentication_service.dart';
import 'package:uber_clone/theme/palette.dart';


class AccountSettings extends StatefulWidget {

  static const String route = '/accountSettings';

  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {


  final TextStyle accountInfoStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    color: Colors.black
  );

  @override
  Widget build(BuildContext context) {
    final UserData user = Provider.of<UserDataProvider>(context, listen: false).userData!;
    //final File picture = Provider.of<ProfilePicturesProvider>(context, listen: false).profilePicture!;

    GooglePlace? home = Provider.of<FavoritePlacesProvider>(context).home;
    GooglePlace? work = Provider.of<FavoritePlacesProvider>(context).work;
    List<GooglePlace>? savedPlaces = Provider.of<FavoritePlacesProvider>(context).savedPlaces;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Account settings'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/editAccount'),
              style: Palette.greyElevatedStyleLeftPadding,
              child: Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: FileImage(Provider.of<ProfilePicturesProvider>(context, listen: false).profilePicture!),
                      backgroundColor: Colors.transparent,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.firstName + ' ' + user.lastName, style: accountInfoStyle,),
                          Text('+387 62 972 494', style: accountInfoStyle,),
                          Text(user.email, style: accountInfoStyle,)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Divider(color: Colors.grey, height: 20, thickness: 0.5,),
            Container(
                margin: EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text('Favorites', style: Theme.of(context).textTheme.headline3,)
                    ),
                    SizedBox(height: 25,),
                    ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        ElevatedButton.icon(
                          style: Palette.greyElevatedStyleLeftPadding,
                          onPressed: () async =>  Navigator.pushNamed(context, FavoritePlaceSearch.route, arguments: 'home'),
                          icon: Icon(Icons.home_filled, color: Colors.black,),
                          label: Row(
                            children: [
                              Text('Add Home', style: Theme.of(context).textTheme.headline3!.copyWith(fontWeight: FontWeight.w400)),
                              Spacer(),
                              home != null ?
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Text(home.placeName, style: Theme.of(context).textTheme.headline3!.copyWith(fontWeight: FontWeight.w400)))
                              : Container()
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          style: Palette.greyElevatedStyleLeftPadding,
                          onPressed: () async => Navigator.pushNamed(context, FavoritePlaceSearch.route, arguments: 'work'),
                          icon: Icon(Icons.work, color: Colors.black,),
                          label: Row(
                            children: [
                              Text('Add Work', style: Theme.of(context).textTheme.headline3!.copyWith(fontWeight: FontWeight.w400)),
                              Spacer(),
                              work != null ?
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: Text(work.placeName, style: Theme.of(context).textTheme.headline3!.copyWith(fontWeight: FontWeight.w400))
                              )
                              :
                              Container()
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: Palette.greyElevatedStyleLeftPadding,
                          onPressed: () async => Navigator.pushNamed(context, FavoritePlaceSearch.route, arguments: 'more'),
                          child: Text('More Saved places', style: TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.w400),),
                        )
                      ],
                    ),

                  ],
                )
            ),
            Divider(color: Colors.grey, height: 30, thickness: 0.5,),
            Container(
                margin: EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Text('Safety', style: Theme.of(context).textTheme.headline3),
                    ),
                    SizedBox(height: 25,),
                    ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        ElevatedButton.icon(
                            style: Palette.greyElevatedStyleAllPadding,
                            onPressed: () {},
                            icon: Icon(Icons.quick_contacts_dialer_rounded, color: Colors.black,),
                            label: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Manage Trusted Contacts', style: Theme.of(context).textTheme.headline3!.copyWith(fontWeight: FontWeight.w400)),
                                  Container(
                                    width: MediaQuery.of(context).size.width - 100,
                                    child: Text('Share your trip status with family and friends in a single tap',
                                      style: Theme.of(context).textTheme.headline4),
                                  ),
                                ],
                              ),
                            )
                        ),
                        ElevatedButton.icon(
                            style: Palette.greyElevatedStyleAllPadding,
                            onPressed: () async => await Navigator.pushNamed(context, '/rideVerification'),
                            icon: Icon(Icons.fiber_pin, color: Colors.black,),
                            label: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Verify Your Ride', style: Theme.of(context).textTheme.headline3),
                                  Container(
                                    width: MediaQuery.of(context).size.width - 100,
                                    child: Text('Use a PIN to make sure you get in the right car',
                                      style: Theme.of(context).textTheme.headline4,),
                                  ),
                                ],
                              ),
                            )
                        ),
                        ElevatedButton.icon(
                            style: Palette.greyElevatedStyleAllPadding,
                            onPressed: () {},
                            //TODO import custom icon
                            icon: Icon(Icons.car_rental, color: Colors.black,),
                            label: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('RideCheck', style: Theme.of(context).textTheme.headline3),
                                  Container(
                                    width: MediaQuery.of(context).size.width - 100,
                                    child: Text('Manage your RideCheck notifications',
                                    style: Theme.of(context).textTheme.headline4),
                                  ),
                                ],
                              ),
                            )
                        )
                      ],
                    )
                  ],
                )
            ),
            Divider(height: 30, thickness: 0.5, color: Colors.grey,),
            ElevatedButton(
                  style: Palette.greyElevatedStyleAllPadding,
                  onPressed: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Privacy', style: Theme.of(context).textTheme.headline3!.copyWith(fontWeight: FontWeight.w400),),
                      Text('Manage the data you share with us', style: Theme.of(context).textTheme.headline4,)
                    ],
                  )
              ),
            Divider(height: 30, color: Colors.grey, thickness: 0.5,),
            ElevatedButton(
                style: Palette.greyElevatedStyleAllPadding,
                onPressed: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Security', style: Theme.of(context).textTheme.headline3,),
                    Text('Control your account security with 2-step verification',
                        style: Theme.of(context).textTheme.headline4,
                    )
                  ],
                )
            ),
            Divider(height: 30, color: Colors.grey, thickness: 0.5,),
            ElevatedButton(
                style: Palette.greyElevatedStyleAllPadding,
                onPressed: () async {
                  await Provider.of<AuthenticationService>(context, listen: false).signOut();
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AuthenticationWrapper()), (_) => false);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sign out', style: Theme.of(context).textTheme.headline3,),
                  ],
                )
            ),
            SizedBox(height: 20,)

          ],
        )
      ),
    );
  }
}
