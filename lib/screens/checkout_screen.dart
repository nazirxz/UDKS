// lib/screens/checkout_screen.dart
import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../services/cart_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CartService _cartService = CartService();
  final TextEditingController _voucherController = TextEditingController();
  
  String _selectedShipping = 'Standard Delivery';
  String _selectedPayment = 'Cash on Delivery';
  bool _isVoucherApplied = false;
  int _discountAmount = 0;

  final List<Map<String, dynamic>> _shippingOptions = [
    {
      'title': 'Standard Delivery',
      'subtitle': '2-3 business days',
      'price': 15000,
      'icon': Icons.local_shipping,
    },
    {
      'title': 'Express Delivery', 
      'subtitle': 'Same day delivery',
      'price': 25000,
      'icon': Icons.speed,
    },
    {
      'title': 'Free Delivery',
      'subtitle': '5-7 business days',
      'price': 0,
      'icon': Icons.card_giftcard,
    },
  ];

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'title': 'Cash on Delivery',
      'subtitle': 'Pay when you receive',
      'icon': Icons.money,
    },
    {
      'title': 'Bank Transfer',
      'subtitle': 'Transfer to our account',
      'icon': Icons.account_balance,
    },
    {
      'title': 'E-Wallet',
      'subtitle': 'OVO, GoPay, Dana',
      'icon': Icons.account_balance_wallet,
    },
    {
      'title': 'Credit Card',
      'subtitle': 'Visa, MasterCard',
      'icon': Icons.credit_card,
    },
  ];

  @override
  void dispose() {
    _voucherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListenableBuilder(
        listenable: _cartService,
        builder: (context, child) {
          if (_cartService.isEmpty) {
            return _buildEmptyCart();
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Summary Section
                      _buildOrderSummary(),
                      const SizedBox(height: 16),
                      
                      // Shipping Options Section
                      _buildShippingOptions(),
                      const SizedBox(height: 16),
                      
                      // Payment Method Section
                      _buildPaymentMethods(),
                      const SizedBox(height: 16),
                      
                      // Voucher Section
                      _buildVoucherSection(),
                      const SizedBox(height: 16),
                      
                      // Price Breakdown Section
                      _buildPriceBreakdown(),
                    ],
                  ),
                ),
              ),
              
              // Bottom Section with Total and Place Order Button
              _buildBottomSection(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Keranjang Kosong',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan produk ke keranjang\nuntuk melakukan pemesanan',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Mulai Belanja'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.receipt_long, color: Colors.orange),
                const SizedBox(width: 8),
                const Text(
                  'Items Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_cartService.totalItems} item${_cartService.totalItems > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...(_cartService.items.map((item) => _buildOrderItem(item)).toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(CartItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Product Image/Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: item.backgroundColor ?? Colors.grey.shade100,
            ),
            child: item.image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        item.icon ?? Icons.fastfood,
                        color: item.iconColor ?? Colors.grey,
                        size: 24,
                      ),
                    ),
                  )
                : Icon(
                    item.icon ?? Icons.fastfood,
                    color: item.iconColor ?? Colors.grey,
                    size: 24,
                  ),
          ),
          const SizedBox(width: 12),
          
          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.quantity} ${item.unit} × Rp ${_formatCurrency(item.price)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          
          // Quantity Controls
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildQuantityButton(
                icon: Icons.remove,
                onPressed: () => _cartService.decreaseQuantity(item.productId),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  '${item.quantity}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildQuantityButton(
                icon: Icons.add,
                onPressed: () => _cartService.increaseQuantity(item.productId),
              ),
            ],
          ),
          
          const SizedBox(width: 8),
          
          // Total Price
          Text(
            'Rp ${_formatCurrency(item.totalPrice)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, size: 18),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    );
  }

  Widget _buildShippingOptions() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.local_shipping, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Pilihan Pengiriman',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._shippingOptions.map((option) => _buildShippingOption(option)),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingOption(Map<String, dynamic> option) {
    final isSelected = _selectedShipping == option['title'];
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => setState(() => _selectedShipping = option['title']),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.orange : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
            color: isSelected ? Colors.orange.shade50 : null,
          ),
          child: Row(
            children: [
              Icon(
                option['icon'],
                color: isSelected ? Colors.orange : Colors.grey.shade600,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option['title'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.orange : Colors.black87,
                      ),
                    ),
                    Text(
                      option['subtitle'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                option['price'] == 0 
                    ? 'Gratis' 
                    : 'Rp ${_formatCurrency(option['price'])}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.orange : Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              Radio<String>(
                value: option['title'],
                groupValue: _selectedShipping,
                onChanged: (value) => setState(() => _selectedShipping = value!),
                activeColor: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.payment, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Metode Pembayaran',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._paymentMethods.map((method) => _buildPaymentMethod(method)),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod(Map<String, dynamic> method) {
    final isSelected = _selectedPayment == method['title'];
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => setState(() => _selectedPayment = method['title']),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.orange : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
            color: isSelected ? Colors.orange.shade50 : null,
          ),
          child: Row(
            children: [
              Icon(
                method['icon'],
                color: isSelected ? Colors.orange : Colors.grey.shade600,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method['title'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.orange : Colors.black87,
                      ),
                    ),
                    Text(
                      method['subtitle'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Radio<String>(
                value: method['title'],
                groupValue: _selectedPayment,
                onChanged: (value) => setState(() => _selectedPayment = value!),
                activeColor: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVoucherSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.local_offer, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Masukkan Voucher',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _voucherController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan kode voucher',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.orange),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _applyVoucher,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('Terapkan'),
                ),
              ],
            ),
            if (_isVoucherApplied) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Voucher berhasil diterapkan!',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      '- Rp ${_formatCurrency(_discountAmount)}',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPriceBreakdown() {
    final subtotal = _cartService.totalPrice;
    final shippingCost = _getSelectedShippingCost();
    final tax = (subtotal * 0.1).round();
    final discount = _discountAmount;
    final total = subtotal + shippingCost + tax - discount;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rincian Harga',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildPriceRow('Subtotal', subtotal),
            _buildPriceRow('Ongkos Kirim', shippingCost),
            _buildPriceRow('Pajak (10%)', tax),
            if (discount > 0) _buildPriceRow('Diskon', -discount, isDiscount: true),
            const Divider(height: 20),
            _buildPriceRow('Total', total, isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, int amount, {bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black87 : Colors.grey.shade700,
            ),
          ),
          Text(
            '${isDiscount ? '-' : ''}Rp ${_formatCurrency(amount.abs())}',
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal 
                  ? Colors.orange 
                  : isDiscount 
                      ? Colors.green 
                      : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    final total = _calculateFinalTotal();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Pembayaran:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Rp ${_formatCurrency(total)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Place Order',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _applyVoucher() {
    final voucherCode = _voucherController.text.trim().toLowerCase();
    
    // Simple voucher validation (you can expand this)
    if (voucherCode == 'discount10') {
      setState(() {
        _isVoucherApplied = true;
        _discountAmount = (_cartService.totalPrice * 0.1).round();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Voucher berhasil diterapkan! Diskon 10%'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (voucherCode == 'freeship') {
      setState(() {
        _isVoucherApplied = true;
        _discountAmount = _getSelectedShippingCost();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Voucher berhasil diterapkan! Gratis ongkir'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (voucherCode.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kode voucher tidak valid'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  int _getSelectedShippingCost() {
    final selectedOption = _shippingOptions.firstWhere(
      (option) => option['title'] == _selectedShipping,
      orElse: () => _shippingOptions.first,
    );
    return selectedOption['price'] ?? 0;
  }

  int _calculateFinalTotal() {
    final subtotal = _cartService.totalPrice;
    final shippingCost = _getSelectedShippingCost();
    final tax = (subtotal * 0.1).round();
    final discount = _discountAmount;
    return subtotal + shippingCost + tax - discount;
  }

  void _placeOrder() {
    // Show order confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Pesanan'),
        content: Text(
          'Yakin ingin memesan ${_cartService.totalItems} item dengan total Rp ${_formatCurrency(_calculateFinalTotal())}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processOrder();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Ya, Pesan'),
          ),
        ],
      ),
    );
  }

  void _processOrder() {
    // Here you would typically:
    // 1. Send order data to server
    // 2. Process payment
    // 3. Clear cart
    // 4. Show success message
    // 5. Navigate to order confirmation
    
    // For demo, we'll just show success message and clear cart
    _cartService.clearCart();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pesanan berhasil dibuat! Terima kasih.'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
    
    // Navigate back to dashboard
    Navigator.pop(context);
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}