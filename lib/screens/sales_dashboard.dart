// lib/screens/sales_dashboard.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/user.dart';
import '../utils/dashboard_utils.dart';

class SalesDashboard extends StatefulWidget {
  final User user;

  const SalesDashboard({Key? key, required this.user}) : super(key: key);

  @override
  _SalesDashboardState createState() => _SalesDashboardState();
}

class _SalesDashboardState extends State<SalesDashboard> {
  final MapController _mapController = MapController();
  Position? _currentPosition;
  List<Marker> _markers = [];
  String _selectedFilter = 'Semua';
  bool _isLoading = true;
  String _mapStyle = 'OpenStreetMap';

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
      'contact': 'Budi Santoso',
      'lastVisit': '2 hari lalu',
      'orderValue': 'Rp 15.500.000'
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
      'contact': 'Siti Aisyah',
      'lastVisit': '1 hari lalu',
      'orderValue': 'Rp 22.300.000'
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
      'contact': 'Ahmad Rahman',
      'lastVisit': '5 hari lalu',
      'orderValue': 'Rp 8.750.000'
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
      'contact': 'Rina Marlina',
      'lastVisit': 'Hari ini',
      'orderValue': 'Rp 5.200.000'
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
      'contact': 'Joko Widodo',
      'lastVisit': '3 hari lalu',
      'orderValue': 'Rp 12.100.000'
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
      'contact': 'Keke Prasetyo',
      'lastVisit': '1 minggu lalu',
      'orderValue': 'Rp 6.800.000'
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
      'contact': 'Global Manager',
      'lastVisit': 'Hari ini',
      'orderValue': 'Rp 18.600.000'
    },
    {
      'id': 'iris_jaya',
      'name': 'Toko Iris Jaya',
      'address': 'Minimarket Area',
      'status': 'active',
      'lat': -6.1950,
      'lng': 106.8700,
      'color': Colors.green,
      'phone': '+62-21-8901234',
      'contact': 'Iris Jaya',
      'lastVisit': '2 hari lalu',
      'orderValue': 'Rp 9.400.000'
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
      
      // Move map to current location
      _mapController.move(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        13.0,
      );
    } catch (e) {
      print('Error getting location: $e');
      _setupMarkers();
    }
  }

  void _setupMarkers() {
    final markers = <Marker>[];
    
    // Add current location marker if available
    if (_currentPosition != null) {
      markers.add(
        Marker(
          point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          width: 60,
          height: 60,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.withOpacity(0.3),
              border: Border.all(color: Colors.blue, width: 3),
            ),
            child: const Icon(
              Icons.my_location,
              color: Colors.blue,
              size: 30,
            ),
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
            point: LatLng(point['lat'], point['lng']),
            width: 50,
            height: 50,
            child: GestureDetector(
              onTap: () => _showLocationDetail(point),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: point['color'],
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        );
      }
    }

    setState(() {
      _markers = markers;
      _isLoading = false;
    });
  }

  void _filterMarkers(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    _setupMarkers();
  }

  void _changeMapStyle(String style) {
    setState(() {
      _mapStyle = style;
    });
  }

  String _getTileLayerUrl() {
    switch (_mapStyle) {
      case 'Satellite':
        return 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';
      case 'Terrain':
        return 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png';
      case 'Dark':
        return 'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png';
      default:
        return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
    }
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
          PopupMenuButton<String>(
            icon: const Icon(Icons.layers),
            onSelected: _changeMapStyle,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'OpenStreetMap', child: Text('Peta Standar')),
              const PopupMenuItem(value: 'Satellite', child: Text('Satelit')),
              const PopupMenuItem(value: 'Terrain', child: Text('Terrain')),
              const PopupMenuItem(value: 'Dark', child: Text('Mode Gelap')),
            ],
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "summary",
            onPressed: () => _showDistributionSummary(),
            backgroundColor: Colors.green,
            mini: true,
            child: const Icon(Icons.list, color: Colors.white),
            tooltip: 'Ringkasan',
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "route",
            onPressed: () => _showOptimalRoute(),
            backgroundColor: Colors.blue,
            child: const Icon(Icons.route, color: Colors.white),
            tooltip: 'Rute Optimal',
          ),
        ],
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
                    onPressed: () => _showOptimalRoute(),
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
        
        // OpenStreetMap with flutter_map
        Expanded(
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(-6.2088, 106.8456), // Jakarta
              initialZoom: 12.0,
              minZoom: 5.0,
              maxZoom: 18.0,
              onTap: (tapPosition, point) {
                // Handle map tap if needed
              },
            ),
            children: [
              TileLayer(
                urlTemplate: _getTileLayerUrl(),
                userAgentPackageName: 'com.example.sales_dashboard',
                maxZoom: 18,
              ),
              MarkerLayer(
                markers: _markers,
              ),
              if (_currentPosition != null)
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                      radius: 100,
                      color: Colors.blue.withOpacity(0.1),
                      borderColor: Colors.blue.withOpacity(0.3),
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
            ],
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
    
    final point = _distributionPoints.firstWhere(
      (p) => p['name'].toLowerCase().contains(query.toLowerCase()) ||
             p['address'].toLowerCase().contains(query.toLowerCase()),
      orElse: () => {},
    );
    
    if (point.isNotEmpty) {
      _mapController.move(LatLng(point['lat'], point['lng']), 16.0);
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
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: point['color'],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
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
            
            // Status dan info tambahan
            Row(
              children: [
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
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Kunjungan: ${point['lastVisit']}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            Text(
              'Nilai Order: ${point['orderValue']}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _openMapsNavigation(point['lat'], point['lng'], point['name']);
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

  Future<void> _openMapsNavigation(double lat, double lng, String name) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&destination_place_id=$name';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      DashboardUtils.showSnackBar(context, 'Tidak dapat membuka aplikasi maps');
    }
  }

  Future<void> _makePhoneCall(String phone) async {
    final url = 'tel:$phone';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      DashboardUtils.showSnackBar(context, 'Tidak dapat melakukan panggilan');
    }
  }

  void _markAsVisited(Map<String, dynamic> point) {
    setState(() {
      point['status'] = 'delivered';
      point['color'] = Colors.blue;
      point['lastVisit'] = 'Hari ini';
    });
    _setupMarkers();
    DashboardUtils.showSnackBar(context, '${point['name']} ditandai sudah dikunjungi');
  }

  void _showOptimalRoute() {
    final activePoints = _distributionPoints.where((p) => p['status'] == 'active' || p['status'] == 'pending').toList();
    
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Rute Optimal Hari Ini',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              '${activePoints.length} lokasi yang perlu dikunjungi',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ...activePoints.take(3).map((point) => ListTile(
              leading: CircleAvatar(
                backgroundColor: point['color'],
                child: const Icon(Icons.location_on, color: Colors.white, size: 16),
              ),
              title: Text(point['name'], style: const TextStyle(fontSize: 14)),
              subtitle: Text('${point['address']} • ${point['orderValue']}', style: const TextStyle(fontSize: 12)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 12),
              onTap: () {
                Navigator.pop(context);
                _mapController.move(LatLng(point['lat'], point['lng']), 16.0);
                _showLocationDetail(point);
              },
            )),
            if (activePoints.length > 3)
              Text('... dan ${activePoints.length - 3} lokasi lainnya'),
          ],
        ),
      ),
    );
  }

  void _showDistributionSummary() {
    final activeCount = _distributionPoints.where((p) => p['status'] == 'active').length;
    final pendingCount = _distributionPoints.where((p) => p['status'] == 'pending').length;
    final deliveredCount = _distributionPoints.where((p) => p['status'] == 'delivered').length;
    
    final totalValue = _distributionPoints
        .map((p) => int.parse(p['orderValue'].replaceAll(RegExp(r'[^0-9]'), '')))
        .reduce((a, b) => a + b);

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
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Nilai Order:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    'Rp ${_formatCurrency(totalValue)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
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

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}