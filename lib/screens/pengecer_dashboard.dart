// lib/screens/pengecer_dashboard.dart
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../utils/dashboard_utils.dart';
import '../services/cart_service.dart';
import '../widgets/cart_badge_widget.dart';
import '../screens/checkout_screen.dart';

class PengecerDashboard extends StatefulWidget {
  final User user;

  const PengecerDashboard({Key? key, required this.user}) : super(key: key);

  @override
  _PengecerDashboardState createState() => _PengecerDashboardState();
}

class _PengecerDashboardState extends State<PengecerDashboard> {
  final TextEditingController _searchController = TextEditingController();
  final CartService _cartService = CartService();
  
  List<Map<String, dynamic>> _allProducts = [];
  List<Map<String, dynamic>> _filteredProducts = [];
  String _selectedCategory = 'Semua';

  @override
  void initState() {
    super.initState();
    _initializeProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _initializeProducts() {
    _allProducts = [
      {
        'id': 1,
        'name': 'Minyak Goreng Tropical 2L',
        'category': 'Minyak Goreng',
        'price': 25000,
        'image': 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=300&h=300&fit=crop',
        'icon': Icons.water_drop,
        'iconColor': Colors.amber,
        'backgroundColor': Colors.amber.shade50,
        'stock': 50,
        'unit': 'botol'
      },
      {
        'id': 2,
        'name': 'Beras Premium 5kg',
        'category': 'Beras',
        'price': 60000,
        'image': 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=300&h=300&fit=crop',
        'icon': Icons.grain,
        'iconColor': Colors.brown,
        'backgroundColor': Colors.brown.shade50,
        'stock': 30,
        'unit': 'karung'
      },
      {
        'id': 3,
        'name': 'Gula Pasir 1kg',
        'category': 'Gula',
        'price': 15000,
        'image': 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=300&h=300&fit=crop',
        'icon': Icons.apps,
        'iconColor': Colors.grey.shade700,
        'backgroundColor': Colors.grey.shade50,
        'stock': 100,
        'unit': 'pack'
      },
      {
        'id': 4,
        'name': 'Tepung Terigu 1kg',
        'category': 'Tepung',
        'price': 12000,
        'image': 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=300&h=300&fit=crop',
        'icon': Icons.scatter_plot,
        'iconColor': Colors.purple.shade300,
        'backgroundColor': Colors.purple.shade50,
        'stock': 75,
        'unit': 'pack'
      },
      {
        'id': 5,
        'name': 'Mie Instan Ayam Bawang',
        'category': 'Mie Instan',
        'price': 3500,
        'image': 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=300&h=300&fit=crop',
        'icon': Icons.ramen_dining,
        'iconColor': Colors.yellow.shade700,
        'backgroundColor': Colors.yellow.shade50,
        'stock': 200,
        'unit': 'pack'
      },
      {
        'id': 6,
        'name': 'Kopi Bubuk 200g',
        'category': 'Minuman',
        'price': 18000,
        'image': 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=300&h=300&fit=crop',
        'icon': Icons.coffee,
        'iconColor': Colors.brown.shade700,
        'backgroundColor': Colors.brown.shade100,
        'stock': 40,
        'unit': 'pack'
      },
      {
        'id': 7,
        'name': 'Teh Celup 25 sachet',
        'category': 'Minuman',
        'price': 8500,
        'image': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=300&h=300&fit=crop',
        'icon': Icons.local_cafe,
        'iconColor': Colors.green.shade700,
        'backgroundColor': Colors.green.shade50,
        'stock': 60,
        'unit': 'box'
      },
      {
        'id': 8,
        'name': 'Garam Dapur 500g',
        'category': 'Bumbu',
        'price': 4000,
        'image': 'https://images.unsplash.com/photo-1471943311424-646960669fbc?w=300&h=300&fit=crop',
        'icon': Icons.circle,
        'iconColor': Colors.blueGrey.shade400,
        'backgroundColor': Colors.blueGrey.shade50,
        'stock': 80,
        'unit': 'pack'
      },
      {
        'id': 9,
        'name': 'Kecap Manis 600ml',
        'category': 'Bumbu',
        'price': 13500,
        'image': 'https://images.unsplash.com/photo-1594498653385-d5172c532c00?w=300&h=300&fit=crop',
        'icon': Icons.opacity,
        'iconColor': Colors.brown.shade800,
        'backgroundColor': Colors.brown.shade50,
        'stock': 45,
        'unit': 'botol'
      },
      {
        'id': 10,
        'name': 'Susu UHT 1L',
        'category': 'Susu',
        'price': 16000,
        'image': 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=300&h=300&fit=crop',
        'icon': Icons.local_drink,
        'iconColor': Colors.blue.shade600,
        'backgroundColor': Colors.blue.shade50,
        'stock': 35,
        'unit': 'kotak'
      },
      {
        'id': 11,
        'name': 'Telur Ayam 1kg',
        'category': 'Protein',
        'price': 28000,
        'image': 'https://images.unsplash.com/photo-1518569656558-1f25e69d93d7?w=300&h=300&fit=crop',
        'icon': Icons.egg,
        'iconColor': Colors.orange.shade300,
        'backgroundColor': Colors.orange.shade50,
        'stock': 25,
        'unit': 'kg'
      },
      {
        'id': 12,
        'name': 'Sabun Cuci Piring 800ml',
        'category': 'Pembersih',
        'price': 11000,
        'image': 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=300&h=300&fit=crop',
        'icon': Icons.cleaning_services,
        'iconColor': Colors.cyan.shade600,
        'backgroundColor': Colors.cyan.shade50,
        'stock': 55,
        'unit': 'botol'
      }
    ];
    _filteredProducts = List.from(_allProducts);
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty && _selectedCategory == 'Semua') {
        _filteredProducts = List.from(_allProducts);
      } else {
        _filteredProducts = _allProducts.where((product) {
          final nameMatch = (product['name'] ?? '').toLowerCase().contains(query.toLowerCase());
          final categoryMatch = _selectedCategory == 'Semua' || product['category'] == _selectedCategory;
          return nameMatch && categoryMatch;
        }).toList();
      }
    });
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterProducts(_searchController.text);
  }

  List<String> _getCategories() {
    final categories = <String>{'Semua'};
    for (final product in _allProducts) {
      final category = product['category'];
      if (category != null && category.isNotEmpty) {
        categories.add(category);
      }
    }
    return categories.toList();
  }

  void _goToCheckout() {
    if (_cartService.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Keranjang masih kosong'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CheckoutScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Dashboard Pengecer'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          DashboardUtils.buildUserInfoBadge(widget.user),
          // Cart icon in AppBar (optional, since we have FAB)
          ListenableBuilder(
            listenable: _cartService,
            builder: (context, child) {
              return AppBarCartBadge(
                itemCount: _cartService.totalItems,
                onPressed: _goToCheckout,
                iconColor: Colors.white,
                badgeColor: Colors.red,
              );
            },
          ),
          DashboardUtils.buildPopupMenu(
            context, 
            widget.user, 
            (value) => DashboardUtils.handleMenuSelection(context, value, widget.user),
          ),
        ],
      ),
      body: Column(
        children: [
          // Compact Header Card
          Container(
            margin: const EdgeInsets.all(16),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade400, Colors.orange.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: Text(
                        widget.user.name[0],
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Halo, ${widget.user.name}!',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Selamat berbelanja produk terbaik',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListenableBuilder(
                      listenable: _cartService,
                      builder: (context, child) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildCompactStatCard('${_cartService.totalItems}', 'Keranjang', Colors.green.shade300),
                            const SizedBox(width: 8),
                            _buildCompactStatCard('${_allProducts.length}', 'Produk', Colors.blue.shade300),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Compact Search and Filter Section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    // Search Box
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Cari produk...',
                        hintStyle: const TextStyle(fontSize: 14),
                        prefixIcon: const Icon(Icons.search, color: Colors.orange, size: 20),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  _filterProducts('');
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.orange, width: 1.5),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 14),
                      onChanged: _filterProducts,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Compact Category Filter
                    SizedBox(
                      height: 32,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _getCategories().length,
                        itemBuilder: (context, index) {
                          final category = _getCategories()[index];
                          final isSelected = category == _selectedCategory;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: FilterChip(
                              label: Text(
                                category,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.orange,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (selected) => _filterByCategory(category),
                              backgroundColor: Colors.white,
                              selectedColor: Colors.orange,
                              checkmarkColor: Colors.white,
                              side: BorderSide(color: Colors.orange.shade300),
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 4),

          // Product Catalog
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: _filteredProducts.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                      padding: const EdgeInsets.only(bottom: 80), // Add bottom padding for FAB
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.8, // Adjusted since we removed description
                      ),
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = _filteredProducts[index];
                        return _buildProductCard(product);
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: ListenableBuilder(
        listenable: _cartService,
        builder: (context, child) {
          return CartFloatingActionButton(
            itemCount: _cartService.totalItems,
            onPressed: _goToCheckout,
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            badgeColor: Colors.red,
            heroTag: "cart_fab",
          );
        },
      ),
    );
  }

  Widget _buildCompactStatCard(String value, String title, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return ListenableBuilder(
      listenable: _cartService,
      builder: (context, child) {
        final isInCart = _cartService.hasItem(product['id']);
        final cartQuantity = _cartService.getItemQuantity(product['id']);
        
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: () => _showProductDetail(product),
            borderRadius: BorderRadius.circular(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      color: product['backgroundColor'] ?? Colors.grey.shade100,
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: Image.network(
                            product['image'] ?? '',
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: Icon(
                                  product['icon'],
                                  size: 60,
                                  color: product['iconColor'],
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(
                                  product['icon'],
                                  size: 60,
                                  color: product['iconColor'],
                                ),
                              );
                            },
                          ),
                        ),
                        // Stock Badge
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: (product['stock'] ?? 0) > 10 ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Stok: ${product['stock'] ?? 0}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        // Cart indicator if item is in cart
                        if (isInCart)
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '$cartQuantity',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                
                // Product Info (Removed description)
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name
                        Expanded(
                          child: Text(
                            product['name'] ?? 'Produk',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Price and Add Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Rp ${_formatCurrency(product['price'] ?? 0)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  Text(
                                    'per ${product['unit']}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Add to cart button or quantity controls
                            if (!isInCart)
                              SizedBox(
                                width: 32,
                                height: 32,
                                child: FloatingActionButton(
                                  mini: true,
                                  backgroundColor: Colors.orange,
                                  heroTag: "add_${product['id']}",
                                  onPressed: () => _addToCart(product),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              )
                            else
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildQuantityButton(
                                    icon: Icons.remove,
                                    onPressed: () => _cartService.decreaseQuantity(product['id']),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      '$cartQuantity',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  _buildQuantityButton(
                                    icon: Icons.add,
                                    onPressed: () => _cartService.increaseQuantity(product['id']),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(4),
      ),
      child: IconButton(
        icon: Icon(icon, size: 14, color: Colors.orange),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_basket_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Produk tidak ditemukan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coba ubah kata kunci pencarian\natau pilih kategori lain',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  void _showProductDetail(Map<String, dynamic> product) {
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
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: product['backgroundColor'] ?? Colors.grey.shade100,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product['image'] ?? '',
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: Icon(
                            product['icon'] ?? Icons.fastfood,
                            size: 40,
                            color: product['iconColor'] ?? Colors.grey,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            product['icon'] ?? Icons.fastfood,
                            size: 40,
                            color: product['iconColor'] ?? Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'] ?? 'Produk',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Kategori: ${product['category'] ?? 'Umum'}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Stok: ${product['stock'] ?? 0} ${product['unit'] ?? 'pcs'}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Rp ${_formatCurrency(product['price'] ?? 0)} / ${product['unit'] ?? 'pcs'}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _addToCart(product);
                    },
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Tambah ke Keranjang'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(Map<String, dynamic> product) {
    _cartService.addProductToCart(product);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name'] ?? 'Produk'} ditambahkan ke keranjang'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Lihat Keranjang',
          textColor: Colors.white,
          onPressed: _goToCheckout,
        ),
      ),
    );
  }

  String _formatCurrency(dynamic amount) {
    if (amount == null) return '0';
    final int value = amount is int ? amount : (amount is double ? amount.toInt() : 0);
    return value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}