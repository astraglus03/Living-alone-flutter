// import 'package:flutter/material.dart';
// import 'package:livingalone/common/const/text_styles.dart';
// import 'package:livingalone/common/const/colors.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geocoding/geocoding.dart';
//
// class LocationInfoCard extends StatefulWidget {
//   final String address;
//
//   const LocationInfoCard({
//     required this.address,
//     super.key,
//   });
//
//   @override
//   State<LocationInfoCard> createState() => _LocationInfoCardState();
// }
//
// class _LocationInfoCardState extends State<LocationInfoCard> {
//   GoogleMapController? mapController;
//   LatLng? _center;
//   Set<Marker> _markers = {};
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeMap();
//   }
//
//   Future<void> _initializeMap() async {
//     try {
//       // 주소를 위도/경도로 변환
//       List<Location> locations = await locationFromAddress(widget.address);
//       if (locations.isNotEmpty) {
//         final location = locations.first;
//         final position = LatLng(location.latitude, location.longitude);
//
//         setState(() {
//           _center = position;
//           _markers = {
//             Marker(
//               markerId: MarkerId('location'),
//               position: position,
//               infoWindow: InfoWindow(title: widget.address),
//             ),
//           };
//         });
//
//         // 지도 컨트롤러가 있다면 해당 위치로 이동
//         mapController?.animateCamera(
//           CameraUpdate.newCameraPosition(
//             CameraPosition(
//               target: position,
//               zoom: 15.0,
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       print('Error getting location: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 24).r,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '위치',
//             style: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
//           ),
//           16.verticalSpace,
//           Row(
//             children: [
//               Icon(
//                 Icons.location_on,
//                 size: 16.w,
//                 color: GRAY600_COLOR,
//               ),
//               8.horizontalSpace,
//               Expanded(
//                 child: Text(
//                   widget.address,
//                   style: AppTextStyles.body2.copyWith(
//                     color: GRAY800_COLOR,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           16.verticalSpace,
//           Container(
//             width: MediaQuery.of(context).size.width - 48.w,
//             height: 200.h,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8.r),
//               border: Border.all(
//                 color: GRAY200_COLOR,
//                 width: 1,
//               ),
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(8.r),
//               child: _center == null
//                   ? Center(
//                 child: CircularProgressIndicator(),
//               )
//                   : GoogleMap(
//                 onMapCreated: (controller) {
//                   mapController = controller;
//                 },
//                 initialCameraPosition: CameraPosition(
//                   target: _center!,
//                   zoom: 15.0,
//                 ),
//                 markers: _markers,
//                 zoomControlsEnabled: false,
//                 mapToolbarEnabled: false,
//                 myLocationButtonEnabled: false,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     mapController?.dispose();
//     super.dispose();
//   }
// }