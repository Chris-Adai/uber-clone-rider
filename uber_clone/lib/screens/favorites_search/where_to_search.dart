
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' as getx;
import 'package:provider/provider.dart';
import 'package:uber_clone/components/google_place_item.dart';
import 'package:uber_clone/constants/api_key.dart' as api;
import 'package:uber_clone/getx_controllers/utils_controller.dart';
import 'package:uber_clone/models/google_place.dart';
import 'package:uber_clone/providers/settings/account_settings.dart';
import 'package:uuid/uuid.dart';

class FavoritePlaceSearch extends StatefulWidget {

  static const String route = '/whereToSearch';
  final String type;

  FavoritePlaceSearch({required this.type});

  @override
  _FavoritePlaceSearchState createState() => _FavoritePlaceSearchState();
}

class _FavoritePlaceSearchState extends State<FavoritePlaceSearch> {


  final UtilsController utilsController = getx.Get.find();


  final TextEditingController controller = TextEditingController();
  List<GooglePlace> places = <GooglePlace>[];
  String inputValue = '';
  final String token = Uuid().v4();


  Future<void> getPlaces(String input) async{

    if(input.isEmpty) {
      setState(() {
        this.places.clear();
      });
      return;
    }

    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String type = '(regions)';

    String request = '$baseURL?input=$input&key=${api.apiKey}&type=$type&sessiontoken=$token&fields=geometry';
    Response response = await Dio().get(request);
    dynamic predictions = response.data['predictions'];

    List<GooglePlace> places = <GooglePlace>[];

    for(int i = 0; i < predictions.length; i++) {
      String description = predictions[i]['description'];
      print(predictions[i]);
      places.add(GooglePlace.fromDescription(description));
    }


    setState(() {
      this.places.clear();
      this.places = places;
    });
    }


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    print('build is called' + DateTime.now().toString());
    return Scaffold(
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.black
        ),
        child: SafeArea(
          child: Container(
            //margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BackButton(),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 15),
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                          ),
                          child: TextField(
                            controller: controller,
                            onChanged: (String text) {
                              if( inputValue.compareTo(text) != 0) {
                                getPlaces(text);
                                inputValue = text;
                              }
                            },
                            style: const TextStyle(color: Colors.black),
                            cursorColor: Colors.teal.shade800,
                            cursorHeight: 24,
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              labelText: 'Where to?',
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  if(inputValue.compareTo('') == 0)
                                    return;
                                  controller.clear();
                                  setState(() {
                                    inputValue = '';
                                    places.clear();
                                  });
                                },
                                child: Icon(Icons.cancel_outlined, size: 28,)
                              ),
                                contentPadding: EdgeInsets.only(left: 5, bottom: 5),
                                isDense: true,
                                filled: true,
                                fillColor: const Color(0xffededed),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,

                                hintText: 'New York',
                                hintStyle: const TextStyle(color: Colors.grey, fontSize: 18)
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: places.length,
                    itemBuilder: (context, int index) =>
                        InkWell(
                          onTap: () async{
                            if( utilsController.connectivity.value == ConnectivityResult.wifi || utilsController.connectivity.value == ConnectivityResult.mobile) {
                              await Provider.of<FavoritePlacesProvider>(context, listen: false).setPlace(places.elementAt(index), widget.type);
                              Navigator.pop(context);
                            }
                          },
                          child: GooglePlaceItem(place: places.elementAt(index))
                        )
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
