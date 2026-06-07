import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../../core/theme/app_theme.dart';
import '../../models/user.dart';
import '../../services/user_service.dart';

class DetectionFlowScreen extends StatefulWidget {
  const DetectionFlowScreen({super.key});

  @override
  State<DetectionFlowScreen> createState() => _DetectionFlowScreenState();
}

class _DetectionFlowScreenState extends State<DetectionFlowScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  User? _user;
  Position? _currentPosition;
  bool _isLoadingMap = true;

  // Default initial position if location is not available
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(-6.1944, 106.8229),
    zoom: 14.0,
  );

  @override
  void initState() {
    super.initState();
    _loadUser();
    _getUserLocation();
  }

  Future<void> _loadUser() async {
    final user = await UserService.getLocalProfile();
    if (mounted) setState(() => _user = user);
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showError('Layanan lokasi dinonaktifkan.');
      setState(() => _isLoadingMap = false);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showError('Izin lokasi ditolak.');
        setState(() => _isLoadingMap = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showError('Izin lokasi ditolak secara permanen.');
      setState(() => _isLoadingMap = false);
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      _currentPosition = position;

      if (_controller.isCompleted) {
        final GoogleMapController mapController = await _controller.future;
        mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 14.0,
          ),
        ));
      }

      await _fetchNearbyPuskesmas(position.latitude, position.longitude);
    } catch (e) {
      _showError('Gagal mendapatkan lokasi: $e');
    } finally {
      if (mounted) setState(() => _isLoadingMap = false);
    }
  }

  Future<void> _fetchNearbyPuskesmas(double lat, double lng, {String? keyword}) async {
    // Show loading if we are searching
    if (mounted && keyword != null) {
      setState(() => _isLoadingMap = true);
    }

    // Optimize query: Avoid regex on server if possible, or add timeout
    final query = '''
      [out:json][timeout:10];
      (
        nwr["amenity"="clinic"](around:5000,$lat,$lng);
        nwr["amenity"="hospital"](around:5000,$lat,$lng);
        nwr["healthcare"="clinic"](around:5000,$lat,$lng);
      );
      out center;
    ''';

    final url = Uri.parse('https://overpass-api.de/api/interpreter');
    try {
      final response = await http.post(
        url, 
        body: {'data': query},
        headers: {
          'User-Agent': 'AuraHealthApp/1.0',
          'Accept': '*/*',
        }
      ).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final elements = data['elements'] as List;

        if (mounted) {
          setState(() {
            _markers.clear();
            for (var element in elements) {
              double? elat;
              double? elon;

              if (element['type'] == 'node') {
                elat = element['lat'];
                elon = element['lon'];
              } else if (element['center'] != null) {
                elat = element['center']['lat'];
                elon = element['center']['lon'];
              }

              if (elat == null || elon == null) continue;

              final tags = element['tags'] ?? {};
              final name = tags['name']?.toString() ?? 'Faskes / Klinik';

                // Hanya tampilkan puskesmas sesuai permintaan user
                if (!name.toLowerCase().contains('puskesmas')) {
                  continue;
                }

                // Local filtering for keyword
                if (keyword != null && keyword.isNotEmpty) {
                  if (!name.toLowerCase().contains(keyword.toLowerCase())) {
                    continue;
                  }
                }

                _markers.add(Marker(
                  markerId: MarkerId(element['id'].toString()),
                  position: LatLng(elat, elon),
                  infoWindow: InfoWindow(
                    title: name,
                    snippet: 'Melayani Deteksi Dini TBC',
                  ),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    name.toLowerCase().contains('puskesmas') 
                        ? BitmapDescriptor.hueGreen 
                        : BitmapDescriptor.hueRed
                  ),
                ));
            }
          });
        }
      } else {
        _showError('Gagal memuat faskes: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Koneksi timeout atau gagal memuat faskes.');
    } finally {
      if (mounted && keyword != null) {
        setState(() => _isLoadingMap = false);
      }
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _goToMyLocation() async {
    if (_currentPosition == null) {
      await _getUserLocation();
    } else if (_controller.isCompleted) {
      final GoogleMapController mapController = await _controller.future;
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          zoom: 14.0,
        ),
      ));
    }
  }

  Future<void> _findNearestPuskesmas() async {
    if (_currentPosition == null || _markers.isEmpty) {
      _showError('Lokasi Anda atau data puskesmas belum tersedia.');
      return;
    }

    Marker? nearestMarker;
    double minDistance = double.infinity;

    for (var marker in _markers) {
      final distance = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        marker.position.latitude,
        marker.position.longitude,
      );

      if (distance < minDistance) {
        minDistance = distance;
        nearestMarker = marker;
      }
    }

    if (nearestMarker != null) {
      if (_controller.isCompleted) {
        final GoogleMapController mapController = await _controller.future;
        mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: nearestMarker.position,
            zoom: 16.0,
          ),
        ));
        mapController.showMarkerInfoWindow(nearestMarker.markerId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Alur & Lokasi Deteksi',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: AppTheme.primaryColor,
              backgroundImage: _user?.avatarUrl != null
                  ? (_user!.avatarUrl!.startsWith('http')
                      ? CachedNetworkImageProvider(_user!.avatarUrl!) as ImageProvider
                      : null)
                  : null,
              child: _user?.avatarUrl == null
                  ? const Icon(Icons.person, color: Colors.white, size: 20)
                  : null,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Faskes Terdekat',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.primaryColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (_isLoadingMap) 
                  const SizedBox(
                    width: 16, 
                    height: 16, 
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryColor)
                  ),
              ],
            ),
            const SizedBox(height: 12),
            _buildFaskesMap(context),
            const SizedBox(height: 32),
            Text(
              'Langkah-langkah Deteksi',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 16),
            _buildDetectionSteps(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFaskesMap(BuildContext context) {
    return SizedBox(
      height: 260,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _currentPosition != null 
                ? CameraPosition(
                    target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                    zoom: 14.0,
                  ) 
                : _initialPosition,
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              gestureRecognizers: {
                Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
              },
              onMapCreated: (GoogleMapController controller) {
                if (!_controller.isCompleted) {
                  _controller.complete(controller);
                }
              },
            ),
            Positioned(
              top: 16,
              left: 16,
              right: 72,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari puskesmas atau klinik...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onSubmitted: (value) {
                    if (_currentPosition != null) {
                      _fetchNearbyPuskesmas(
                        _currentPosition!.latitude, 
                        _currentPosition!.longitude,
                        keyword: value,
                      );
                    }
                  },
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: _goToMyLocation,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.my_location, color: Colors.white),
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _findNearestPuskesmas,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.local_hospital, color: Colors.white, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Puskesmas Terdekat',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetectionSteps(BuildContext context) {
    final steps = [
      (
        'Langkah 1: Cek Gejala Mandiri',
        'Screening awal untuk mengetahui risiko TB Anda melalui beberapa pertanyaan singkat.',
      ),
      (
        'Langkah 2: Kunjungi Faskes',
        'Pemeriksaan fisik oleh tenaga medis di puskesmas atau klinik rujukan.',
      ),
      (
        'Langkah 3: Tes Dahak (TCM)',
        'Pengambilan sampel dahak untuk pengujian Tes Cepat Molekuler (TCM).',
      ),
      (
        'Langkah 4: Hasil Diagnosa',
        'Menerima dan berkonsultasi mengenai hasil tes TCM dari dokter.',
      ),
      (
        'Langkah 5: Mulai Pengobatan',
        'Jika positif, memulai rejimen pengobatan TB di bawah pengawasan faskes.',
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          for (var index = 0; index < steps.length; index++)
            _buildStepItem(
              context,
              number: index + 1,
              title: steps[index].$1,
              description: steps[index].$2,
              isLast: index == steps.length - 1,
            ),
        ],
      ),
    );
  }

  Widget _buildStepItem(
    BuildContext context, {
    required int number,
    required String title,
    required String description,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$number',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (!isLast)
              Container(width: 2, height: 54, color: Colors.grey.shade300),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

