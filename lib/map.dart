import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mr_deal_user/common_widgets/globals.dart';

import 'common_widgets/colors_widget.dart';
import 'common_widgets/font_size.dart';
import 'common_widgets/text_widget.dart';

class MapPage extends StatefulWidget {
  final String lat;
  final String long;
  const MapPage({Key? key, required this.lat, required this.long})
      : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late final LatLng _center;
  //  = LatLng(double.parse(widget.lat), MrDealGlobals.long);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    final marker = Marker(
      markerId: MarkerId('place_name'),
      position: _center,
      // LatLng(MrDealGlobals.lat, MrDealGlobals.long),
      // icon: BitmapDescriptor.,
      // infoWindow: InfoWindow(
      //   title: 'title',
      //   // snippet: 'address',
      // ),
    );

    setState(() {
      markers[MarkerId('place_name')] = marker;
    });
  }

  Widget _appbar() {
    return AppBar(
        backgroundColor: theme_color,
        centerTitle: false,
        automaticallyImplyLeading: true,
        flexibleSpace: Container(
            // decoration: const BoxDecoration(
            //   gradient: LinearGradient(
            //       begin: Alignment.topCenter,
            //       end: Alignment.bottomCenter,
            //       colors: <Color>[Color(0xff0e2c94), Color(0xff4abcf2)]),
            // ),
            ),
        title: const TextWidget(
          text: 'Map Direction',
          size: text_size_18,
          color: white_color,
        ));
  }

  @override
  void initState() {
    super.initState();
    _center = LatLng(double.parse(widget.lat), double.parse(widget.long));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: PreferredSize(
            child: _appbar(), preferredSize: const Size.fromHeight(60)),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          markers: markers.values.toSet(),
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
      ),
    );
  }
}
