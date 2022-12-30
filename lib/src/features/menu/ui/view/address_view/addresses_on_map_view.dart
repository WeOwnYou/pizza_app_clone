import 'dart:async';

import 'package:address_repository/address_repository.dart';
import 'package:collection/collection.dart';
import 'package:dodo_clone/src/core/ui/navigation/service/router.dart';
import 'package:dodo_clone/src/core/ui/utils/extensions/date_time_extensions.dart';
import 'package:dodo_clone/src/core/ui/utils/res/res.dart';
import 'package:dodo_clone/src/core/ui/widgets/corporate_button.dart';
import 'package:dodo_clone/src/core/ui/widgets/platform_unique_widget.dart';
import 'package:dodo_clone/src/features/main/address_cubit/address_cubit.dart';
import 'package:dodo_clone/src/features/menu/bloc/menu_bloc/menu_bloc.dart';
import 'package:dodo_clone/src/features/menu/ui/widgets/map_main_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class AddressesOnMapView extends StatefulWidget {
  const AddressesOnMapView({
    Key? key,
    required this.addresses,
    required this.parentContext,
  }) : super(key: key);

  final List<Address> addresses;
  final BuildContext parentContext;

  @override
  State<AddressesOnMapView> createState() => _AddressesOnMapViewState();
}

class _AddressesOnMapViewState extends State<AddressesOnMapView> {
  late final DraggableScrollableController _draggableController;
  double barrierOpacity = 0;
  late Address selectedAddress;
  late List<Address> addressesWithLocation;
  late final YandexMapController _mapController;
  GlobalKey mapKey = GlobalKey();
  final List<MapObject<dynamic>> mapObjects = [];
  final clusterRestaurantObjId = const MapObjectId('restaurant_object_id');

  @override
  void initState() {
    super.initState();
    _draggableController = DraggableScrollableController()
      ..addListener(_draggableControllerListener);
    drawRestaurantsOnMap();
  }

  void _draggableControllerListener() {
    setState(() {
      barrierOpacity = _draggableController.size - 0.3;
    });
  }

  void drawRestaurantsOnMap() {
    addressesWithLocation =
        widget.addresses.where((element) => element.location != null).toList();
    selectedAddress =
        addressesWithLocation.firstWhereOrNull((element) => element.selected) ??
            addressesWithLocation.first;
    _generateRestaurantsCluster();
    // mapObjects.addAll(
    //   List.generate(
    //     addressesWithLocation.length,
    //     (index) => generateMapObject(index, addressesWithLocation[index]),
    //   ),
    // );
    setState(() {});
  }

  Future<void> _onMapCreated(YandexMapController yandexMapController) async {
    _mapController = yandexMapController;
    addressesWithLocation =
        widget.addresses.where((address) => address.location != null).toList();
    final selectedAddress =
        addressesWithLocation.firstWhereOrNull((element) => element.selected) ??
            addressesWithLocation.first;
    await _mapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
            longitude: selectedAddress.location!.lon,
            latitude: selectedAddress.location!.lat,
          ),
        ),
      ),
    );
    await _mapController.moveCamera(CameraUpdate.zoomTo(17));
  }

  void zoomIn() {
    _mapController.moveCamera(
      CameraUpdate.zoomIn(),
      animation: const MapAnimation(duration: 0.7),
    );
  }

  void zoomOut() {
    _mapController.moveCamera(
      CameraUpdate.zoomOut(),
      animation: const MapAnimation(duration: 0.7),
    );
  }

  void _generateRestaurantsCluster() {
    // mapObjects.addAll(
    //   List.generate(
    //     addressesWithLocation.length,
    //     (index) => generateMapObject(index, addressesWithLocation[index]),
    //   ),
    // );
    // if (mapObjects.any((el) => el.mapId == clusterRestaurantObjId)) {
    //   return;
    // }
    if (mapObjects.isNotEmpty) mapObjects.clear();
    mapObjects.add(
      ClusterizedPlacemarkCollection(
        mapId: clusterRestaurantObjId,
        radius: 30,
        minZoom: 15,
        onClusterAdded: (self, cluster) async {
          return cluster.copyWith(
            appearance: cluster.appearance.copyWith(
              icon: PlacemarkIcon.single(
                PlacemarkIconStyle(
                  image: BitmapDescriptor.fromAssetImage(AppIcons.mapPin),
                  scale: 3,
                ),
              ),
            ),
          );
        },
        placemarks: List.generate(
          addressesWithLocation.length,
          (index) {
            final address = addressesWithLocation[index];
            return PlacemarkMapObject(
              mapId: MapObjectId('dynamic_icon_placemark$index'),
              point: Point(
                latitude: address.location!.lat,
                longitude: address.location!.lon,
              ),
              onTap: (self, point) {
                final oldIndex = addressesWithLocation
                    .indexWhere((element) => element.selected);
                if (address.selected) {
                  addressesWithLocation[index] =
                      addressesWithLocation[index].copyWith(selected: false);
                } else {
                  addressesWithLocation[index] =
                      addressesWithLocation[index].copyWith(selected: true);
                }
                if (index != oldIndex &&
                    oldIndex > -1 &&
                    addressesWithLocation[oldIndex].selected) {
                  addressesWithLocation[oldIndex] =
                      addressesWithLocation[oldIndex].copyWith(selected: false);
                }
                _generateRestaurantsCluster();
                selectedAddress = addressesWithLocation[index];
                setState(() {});
              },
              opacity: 0.95,
              icon: PlacemarkIcon.single(
                PlacemarkIconStyle(
                  scale: address.selected ? 0.4 : 0.2,
                  image: BitmapDescriptor.fromAssetImage(
                    AppIcons.locationOrange,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> showMyLocation() async {
    if (await locationPermissionNotGranted) {
      _showMessage(
        context,
        const Text('Location permission was NOT granted'),
      );
      return;
    }
    final mediaQuery = MediaQuery.of(context);
    final height =
        mapKey.currentContext!.size!.height * mediaQuery.devicePixelRatio;
    final width =
        mapKey.currentContext!.size!.width * mediaQuery.devicePixelRatio;
    await _mapController.toggleUserLayer(
      visible: true,
      autoZoomEnabled: true,
      anchor: UserLocationAnchor(
        course: Offset(0.5 * width, 0.5 * height),
        normal: Offset(0.5 * width, 0.5 * height),
      ),
    );
  }

  Future<bool> get locationPermissionNotGranted async {
    return !(await Permission.location.request().isGranted);
  }

  void _showMessage(BuildContext context, Text text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: text));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        YandexMap(
          key: mapKey,
          poiLimit: 0,
          onMapCreated: _onMapCreated,
          mapObjects: mapObjects,
          onUserLocationAdded: (view) async {
            return view.copyWith(
              pin: view.pin.copyWith(
                icon: PlacemarkIcon.single(
                  PlacemarkIconStyle(
                    image: BitmapDescriptor.fromAssetImage(
                      AppIcons.mapMe,
                    ),
                  ),
                ),
              ),
              arrow: view.arrow.copyWith(
                icon: PlacemarkIcon.single(
                  PlacemarkIconStyle(
                    image: BitmapDescriptor.fromAssetImage(
                      AppIcons.mapArrow,
                    ),
                  ),
                ),
              ),
              accuracyCircle: view.accuracyCircle.copyWith(
                fillColor: Colors.transparent,
                strokeColor: Colors.transparent,
              ),
            );
          },
        ),
        if (barrierOpacity > 0.03)
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: ColoredBox(color: Colors.black.withOpacity(barrierOpacity)),
          ),
        Align(
          alignment: Alignment.centerRight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              MapMainButton(
                icon: const Icon(
                  Icons.add,
                  size: 25,
                  color: AppColors.mainBgOrange,
                ),
                onTap: zoomIn,
              ),
              MapMainButton(
                icon: const Icon(
                  Icons.remove,
                  size: 25,
                  color: AppColors.mainBgOrange,
                ),
                onTap: zoomOut,
              ),
              MapMainButton(
                icon: PlatformUniqueWidget(
                  iosBuilder: (context) => const Icon(
                    CupertinoIcons.location,
                    color: AppColors.mainBgOrange,
                  ),
                  androidBuilder: (context) => const FaIcon(
                    FontAwesomeIcons.locationArrow,
                    size: 25,
                    color: AppColors.mainBgOrange,
                  ),
                ),
                onTap: showMyLocation,
              ),
            ],
          ),
        ),
        _BuildBottomPanelWidget(
          draggableController: _draggableController,
          addressIndex: addressesWithLocation
              .indexWhere((element) => element.id == selectedAddress.id),
          selectedAddress: selectedAddress,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: ColoredBox(
            color: Colors.white,
            child: CorporateButton(
              isActive: true,
              child: const Text(
                'Забрать здесь',
                style: TextStyle(fontSize: 18),
              ),
              widthFactor: 0.9,
              onTap: () {
                widget.parentContext.read<AddressCubit>().changeSelectedAddress(
                      addressesWithLocation.firstWhereOrNull(
                            (element) => element.selected,
                          ) ??
                          widget.addresses.first,
                    );
                widget.parentContext
                    .read<MenuBloc>()
                    .add(const MenuUpdateByAddressEvent());
                AppRouter.instance().pop();
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _BuildBottomPanelWidget extends StatelessWidget {
  final int addressIndex;
  final Address selectedAddress;
  final DraggableScrollableController draggableController;
  const _BuildBottomPanelWidget({
    required this.addressIndex,
    required this.selectedAddress,
    required this.draggableController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: draggableController,
      minChildSize: 0.3,
      initialChildSize: 0.3,
      maxChildSize: 0.97,
      snap: true,
      snapSizes: const [
        0.3,
        0.97,
      ],
      builder: (context, controller) {
        return DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: kMainHorizontalPadding),
            controller: controller,
            children: [
              Center(
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(
                    vertical: kMainHorizontalPadding + 10,
                  ),
                  width: 40,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              Text(
                '${selectedAddress.city}-${addressIndex + 1}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(selectedAddress.addressFormatted),
              const SizedBox(
                height: 10,
              ),
              Text(
                selectedAddress.workingHours?.openInfo ?? '',
                style: const TextStyle(
                  color: AppColors.mainBgOrange,
                  fontSize: 12,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Время работы',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '${selectedAddress.workingHours?.startTime} - ${selectedAddress.workingHours?.endTime} ежедневно',
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              if (selectedAddress.phone != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Телефон',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      selectedAddress.phone!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.mainBgOrange,
                      ),
                    ),
                  ],
                )
            ],
          ),
        );
      },
    );
  }
}
