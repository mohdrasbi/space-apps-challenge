import 'package:app/chart_temperature.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class InteractiveMap extends StatefulWidget {
  const InteractiveMap({super.key});

  @override
  State<InteractiveMap> createState() => _InteractiveMapState();
}

class _InteractiveMapState extends State<InteractiveMap>
    with TickerProviderStateMixin {
  int _currentLayer = 0;
  Marker? _currentMaker;

  final List<LayerData> _layers = [
    LayerData(
      'MODIS_Aqua_L2_Sea_Surface_Temp_Day',
      'Sea Surface Temperature',
      Colors.purple[900]!,
      Colors.red[900]!,
    ),
    LayerData(
      'MODIS_Water_Mask',
      'Global 250m Water Map',
      Colors.cyan[200]!,
      Colors.cyan[200]!,
    ),
    LayerData(
      'AMSRU2_Cloud_Liquid_Water_Day',
      'Cloud Liquid Water Path',
      Colors.green[50]!,
      Colors.green[900]!,
    ),
    LayerData(
      'CYGNSS_L3_Wind_Speed_SDR_Daily',
      'Wind Speed',
      Colors.blue[900]!,
      Colors.red[900]!,
    ),
  ];

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void onTap(LatLng point) {
    setState(() {
      _currentMaker = Marker(
        point: point,
        builder: (ctx) => const Icon(
          Icons.location_on,
          color: Colors.red,
          size: 35.0,
        ),
      );
    });

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 1000,
          child: Center(
            child: Scaffold(
              appBar: AppBar(
                bottom: TabBar(
                  controller: _tabController,
                  tabs: const <Widget>[
                    Tab(
                      icon: Icon(Icons.waves),
                      text: 'Endangered Species',
                    ),
                    Tab(
                      icon: Icon(Icons.thermostat),
                      text: 'Sea Weather',
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: const <Widget>[
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Card(
                            color: Colors.white,
                            child: Row(
                              children: <Widget>[
                                Image(
                                  image: AssetImage('assets/whale.jpg'),
                                  width: 150,
                                ),
                                SizedBox(
                                  width: 40,
                                ),
                                Text(
                                  'Humpback Whale',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Card(
                            color: Colors.white,
                            child: Row(
                              children: <Widget>[
                                Image(
                                  image: AssetImage('assets/dolphin.jpg'),
                                  width: 150,
                                ),
                                SizedBox(
                                  width: 40,
                                ),
                                Text(
                                  'Dolphin',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Text(
                      "Sea Weather",
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Map(_currentLayer),
      body: Stack(
        children: [
          Map(_layers[_currentLayer].id, _currentMaker, onTap),
          Positioned(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    color: Colors.white,
                    width: 250,
                    child: DropdownButton(
                      dropdownColor: Colors.white,
                      focusColor: Colors.white,
                      value: _currentLayer,
                      items: _layers
                          .map(
                            (l) => DropdownMenuItem(
                              value: _layers.indexOf(l),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(l.name),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _currentLayer = value as int;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: 250,
                    height: 15,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[
                          _layers[_currentLayer].startColor,
                          _layers[_currentLayer].endColor,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 1000,
                color: Colors.white,
                child: Scaffold(
                  appBar: AppBar(),
                  body: Center(
                    child: Column(
                      children: <Widget>[
                        ChartTemperature(),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(
          Icons.info,
          size: 30,
        ),
      ),
    );
  }
}

class Map extends StatelessWidget {
  // const WMSLayerPage({Key? key}) : super(key: key);

  final String _currentLayerId;
  final Marker? _currentMaker;
  final Function _onTap;

  Map(this._currentLayerId, this._currentMaker, this._onTap);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          center: const LatLng(23.5880, 58.3829),
          zoom: 5,
          onTap: (tapPosition, point) {
            _onTap(point);
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'dev.fleaflet.flutter_map.example',
          ),
          TileLayer(
            backgroundColor: Colors.transparent,
            wmsOptions: WMSTileLayerOptions(
              baseUrl:
                  'https://gibs.earthdata.nasa.gov/wms/epsg4326/best/wms.cgi?',
              layers: [
                _currentLayerId,
              ],
              // crs: const Epsg4326(),
              version: '1.3.0',
              format: 'image/png',
              otherParameters: const {
                'service': 'WMS',
                'request': 'GetMap',
                'STYLE': 'default',
                // 't': '2023-10-5-T22',
              },
            ),
            tileProvider: CachedNetworkTileProvider(),
          ),
          MarkerLayer(
            markers: _currentMaker != null ? [_currentMaker!] : [],
          ),
        ],
      ),
    );
  }
}

class CachedNetworkTileProvider extends TileProvider {
  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    return CachedNetworkImageProvider(getTileUrl(coordinates, options));
  }
}

class LayerData {
  String id;
  String name;
  Color startColor;
  Color endColor;

  LayerData(this.id, this.name, this.startColor, this.endColor);
}
