import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(-6.1944, 106.8229),
    zoom: 14.0,
  );

  @override
  void initState() {
    super.initState();
    _initMockFaskes();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await UserService.getLocalProfile();
    if (mounted) setState(() => _user = user);
  }

  void _initMockFaskes() {
    // Tambahkan beberapa marker dummy faskes di sekitar Jakarta
    setState(() {
      _markers.addAll([
        const Marker(
          markerId: MarkerId('faskes_1'),
          position: LatLng(-6.1950, 106.8200),
          infoWindow: InfoWindow(
            title: 'RSUD Tanah Abang',
            snippet: 'Tersedia Layanan TBC',
          ),
        ),
        const Marker(
          markerId: MarkerId('faskes_2'),
          position: LatLng(-6.1900, 106.8250),
          infoWindow: InfoWindow(
            title: 'Puskesmas Menteng',
            snippet: 'Klinik Paru & TBC',
          ),
        ),
        const Marker(
          markerId: MarkerId('faskes_3'),
          position: LatLng(-6.2000, 106.8300),
          infoWindow: InfoWindow(
            title: 'Klinik Pratama Sehat',
            snippet: 'Melayani Deteksi Dini TBC',
          ),
        ),
      ]);
    });
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
            Text(
              'Faskes Terdekat',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppTheme.primaryColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            _buildFaskesMap(context),
            const SizedBox(height: 32),
            Text(
              'Langkah-langkah Deteksi',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppTheme.primaryColor),
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
              initialCameraPosition: _initialPosition,
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              gestureRecognizers: {
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
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
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
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
            Positioned(
              left: 72,
              top: 112,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Puskesmas Kecamatan',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
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
