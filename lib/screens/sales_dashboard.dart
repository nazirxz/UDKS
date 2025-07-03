// lib/screens/sales_dashboard.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/user.dart';
import '../utils/dashboard_utils.dart';

class SalesDashboard extends StatefulWidget {
  final User user;

  const SalesDashboard({Key? key, required this.user}) : super(key: key);

  @override
  _SalesDashboardState createState() => _SalesDashboardState();
}

class _SalesDashboardState extends State<SalesDashboard> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  Set<Marker> _markers = {};
  String _selectedFilter = 'Semua';
  bool _isLoading = true;

  // Data titik distribusi dengan koordinat real Jakarta
  final List<Map<String, dynamic>> _distributionPoints = [
    {
      'id': 'mitra_industrial',
      'name': 'PT. Mitra Industrial',
      'address': 'Chrome Teknologi',
      'status': 'active',
      'lat': -6.2088,
      'lng': 106.8456,
      'color': Colors.green,
      'phone': '+62-21-1234567',
      'contact': 'Budi Santoso'
    },
    {
      'id': 'virtus_ventura',
      'name': 'PT. Virtus Ventura',
      'address': 'Toko Potensial',
      'status': 'active',
      'lat': -6.2000,
      'lng': 106.8600,
      'color': Colors.green,
      'phone': '+62-21-2345678',
      'contact': 'Siti Aisyah'
    },
    {
      'id': 'sks',
      'name': 'PT. SKS',
      'address': 'Kawasan Industri',
      'status': 'pending',
      'lat': -6.2150,
      'lng': 106.8500,
      'color': Colors.orange,
      'phone': '+62-21-3456789',
      'contact': 'Ahmad Rahman'
    },
    {
      'id': 'amie_cake',
      'name': 'Amie Cake',
      'address': 'Jl. Kenanga No. 45',
      'status': 'delivered',
      'lat': -6.2200,
      'lng': 106.8300,
      'color': Colors.blue,
      'phone': '+62-21-4567890',
      'contact': 'Rina Marlina'
    },
    {
      'id': 'kavling_dpr',
      'name': 'Kavling DPR 9',
      'address': 'Kompleks DPR Blok 9',
      'status': 'active',
      'lat': -6.2300,
      'lng': 106.8400,
      'color': Colors.green,
      'phone': '+62-21-5678901',
      'contact': 'Joko Widodo'
    },
    {
      'id': 'keke_travel',
      'name': 'Keke Travel',
      'address': 'Loves Sempol Area',
      'status': 'pending',
      'lat': -6.2400,
      'lng': 106.8250,
      'color': Colors.orange,
      'phone': '+62-21-6789012',
      'contact': 'Keke Prasetyo'
    },
    {
      'id': 'global_store',
      'name': 'Global Store',
      'address': 'Mall Global Lt. 2',
      'status': 'delivered',
      'lat': -6.2500,
      'lng': 106.8550,
      'color': Colors.blue,
      'phone': '+62-21-7890123',
      'contact': 'Global Manager'
    },
    {
      'id': 'iris_jaya',
      'name': 'Toko Iris Jaya',
      'address': 'Minimartket Area',
      'status': 'active',
      'lat': -6.1950,
      'lng': 106.8700,
      'color': Colors.green,
      'phone': '+62-21-8901234',
      'contact': 'Iris Jaya'
    },
  ];

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    final permission = await Permission.location.request();
    if (permission == PermissionStatus.granted) {
      _getCurrentLocation();
    } else {
      _setupMarkers();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });
      _setupMarkers();
    } catch (e) {
      print('Error getting location: $e');
      _setupMarkers();
    }
  }

  void _setupMarkers() {
    final markers = <Marker>{};
    
    // Add current location marker if available
    if (_currentPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(
            title: 'Lokasi Saya',
            snippet: 'Posisi saat ini',
          ),
        ),
      );
    }

    // Add distribution points markers
    for (final point in _distributionPoints) {
      if (_selectedFilter == 'Semua' || 
          point['status'] == _selectedFilter.toLowerCase()) {
        markers.add(
          Marker(
            markerId: MarkerId(point['id']),
            position: LatLng(point['lat'], point['lng']),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              _getMarkerColor(point['status']),
            ),
            infoWindow: InfoWindow(
              title: point['name'],
              snippet: point['address'],
            ),
            onTap: () => _showLocationDetail(point),
          ),
        );
      }
    }

    setState(() {
      _markers = markers;
      _isLoading = false;
    });
  }

  double _getMarkerColor(String status) {
    switch (status) {
      case 'active':
        return BitmapDescriptor.hueGreen;
      case 'pending':
        return BitmapDescriptor.hueOrange;
      case 'delivered':
        return BitmapDescriptor.hueBlue;
      default:
        return BitmapDescriptor.hueRed;
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    
    // Move camera to Jakarta center or current location
    final target = _currentPosition != null
        ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
        : const LatLng(-6.2088, 106.8456); // Jakarta center
        
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: 12.0),
      ),
    );
  }

  void _filterMarkers(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    _setupMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Sales'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
            tooltip: 'Lokasi Saya',
          ),
          DashboardUtils.buildUserInfoBadge(widget.user),
          DashboardUtils.buildPopupMenu(
            context, 
            widget.user, 
            (value) => DashboardUtils.handleMenuSelection(context, value, widget.user),
          ),
        ],
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _buildMapPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDistributionSummary(),
        backgroundColor: Colors.green,
        child: const Icon(Icons.list, color: Colors.white),
        tooltip: 'Daftar Distribusi',
      ),
    );
  }

  Widget _buildMapPage() {
    return Column(
      children: [
        // Header dengan search dan filter
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.green.shade50,
          child: Column(
            children: [
              // Search bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Cari lokasi distribusi...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.directions),
                    onPressed: () => _showDirectionsDialog(),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onSubmitted: _searchLocation,
              ),
              const SizedBox(height: 12),
              // Filter buttons
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('Semua', _selectedFilter == 'Semua'),
                    _buildFilterChip('Aktif', _selectedFilter == 'active'),
                    _buildFilterChip('Pending', _selectedFilter == 'pending'),
                    _buildFilterChip('Selesai', _selectedFilter == 'delivered'),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Google Map
        Expanded(
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: LatLng(-6.2088, 106.8456), // Jakarta
              zoom: 12.0,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
            mapToolbarEnabled: true,
            compassEnabled: true,
            trafficEnabled: true, // Show traffic condition
            mapType: MapType.normal,
            onTap: (LatLng position) {
              // Handle map tap if needed
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.green,
            fontSize: 12,
          ),
        ),
        selected: isSelected,
        onSelected: (bool selected) {
          _filterMarkers(label == 'Aktif' ? 'active' : 
                       label == 'Pending' ? 'pending' :
                       label == 'Selesai' ? 'delivered' : 'Semua');
        },
        backgroundColor: Colors.white,
        selectedColor: Colors.green,
        checkmarkColor: Colors.white,
        side: BorderSide(color: Colors.green.shade300),
      ),
    );
  }

  void _searchLocation(String query) {
    if (query.isEmpty) return;
    
    // Find matching distribution point
    final point = _distributionPoints.firstWhere(
      (p) => p['name'].toLowerCase().contains(query.toLowerCase()) ||
             p['address'].toLowerCase().contains(query.toLowerCase()),
      orElse: () => {},
    );
    
    if (point.isNotEmpty) {
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(point['lat'], point['lng']),
            zoom: 16.0,
          ),
        ),
      );
      _showLocationDetail(point);
    }
  }

  void _showLocationDetail(Map<String, dynamic> point) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: point['color'],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        point['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        point['address'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Kontak: ${point['contact']}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: point['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Status: ${point['status'].toUpperCase()}',
                style: TextStyle(
                  color: point['color'],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _openGoogleMaps(point['lat'], point['lng'], point['name']);
                    },
                    icon: const Icon(Icons.directions, size: 18),
                    label: const Text('Navigasi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _makePhoneCall(point['phone']);
                    },
                    icon: const Icon(Icons.phone, size: 18),
                    label: const Text('Telepon'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _markAsVisited(point);
                },
                icon: const Icon(Icons.check_circle, size: 18),
                label: const Text('Tandai Sudah Dikunjungi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openGoogleMaps(double lat, double lng, String name) {
    // In a real app, you would use url_launcher to open Google Maps
    DashboardUtils.showSnackBar(context, 'Membuka Google Maps ke $name');
  }

  void _makePhoneCall(String phone) {
    // In a real app, you would use url_launcher to make phone call
    DashboardUtils.showSnackBar(context, 'Menelepon $phone');
  }

  void _markAsVisited(Map<String, dynamic> point) {
    setState(() {
      point['status'] = 'delivered';
      point['color'] = Colors.blue;
    });
    _setupMarkers();
    DashboardUtils.showSnackBar(context, '${point['name']} ditandai sudah dikunjungi');
  }

  void _showDirectionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rute Optimal'),
        content: const Text('Menghitung rute optimal ke semua lokasi...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showDistributionSummary() {
    final activeCount = _distributionPoints.where((p) => p['status'] == 'active').length;
    final pendingCount = _distributionPoints.where((p) => p['status'] == 'pending').length;
    final deliveredCount = _distributionPoints.where((p) => p['status'] == 'delivered').length;

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Ringkasan Distribusi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSummaryCard('Aktif', activeCount, Colors.green),
                _buildSummaryCard('Pending', pendingCount, Colors.orange),
                _buildSummaryCard('Selesai', deliveredCount, Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}