import 'package:flutter/material.dart';
import 'barcode_scanner_screen.dart';
import 'ai_recognition_screen.dart';
import 'digital_receipt_screen.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({super.key});

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  final List<Map<String, dynamic>> _cart = [];
  final _searchController = TextEditingController();
  double _total = 0;
  double _tax = 0;
  final double _discount = 0;
  late List<Map<String, dynamic>> _filteredProducts;

  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Indomie Goreng',
      'price': 3500,
      'stock': 50,
      'image': 'https://m.media-amazon.com/images/I/710yLnSkQgL._SL1200_.jpg',
      'category': 'Makanan',
    },
    {
      'name': 'Susu Ultra',
      'price': 12000,
      'stock': 20,
      'image':
          'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/92/MTA-2556632/ultra_ultra-milk-full-cream-susu-uht--250-ml-_full02.jpg',
      'category': 'Minuman',
    },
    {
      'name': 'Teh Botol',
      'price': 5000,
      'stock': 30,
      'image':
          'https://down-id.img.susercontent.com/file/49297a42c61bd0e08575d5de8a21bb1c',
      'category': 'Minuman',
    },
    {
      'name': 'Roti Tawar',
      'price': 15000,
      'stock': 15,
      'image':
          'https://ceklist.id/wp-content/uploads/2022/09/1-Roti-Tawar-Enak-Merk-Sari-Roti-Roti-Tawar-Gandum-150x150@2x.jpg',
      'category': 'Makanan',
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredProducts = List.from(_products);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Point of Sale'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: _scanBarcode,
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: _aiRecognition,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLargeScreen = constraints.maxWidth > 600;
          final crossAxisCount = constraints.maxWidth > 400 ? 3 : 2;
          final productFontSize = isLargeScreen ? 11.0 : 13.0;
          final priceFontSize = isLargeScreen ? 9.0 : 11.0;
          final cartTitleFontSize = isLargeScreen ? 10.0 : 14.0;
          final totalFontSize = isLargeScreen ? 10.0 : 14.0;

          if (isLargeScreen) {
            return Row(
              children: [
                // Product List
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Cari produk...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onChanged: _filterProducts,
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(8),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: 1.0,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = _filteredProducts[index];
                            return Card(
                              child: InkWell(
                                onTap: () => _addToCart(product),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Product Image
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          color: Colors.grey.shade200,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.network(
                                            product['image'],
                                            fit: BoxFit.cover,
                                            loadingBuilder:
                                                (
                                                  context,
                                                  child,
                                                  loadingProgress,
                                                ) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return const Center(
                                                    child: SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child:
                                                          CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                          ),
                                                    ),
                                                  );
                                                },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return const Icon(
                                                    Icons.inventory,
                                                    size: 30,
                                                    color: Colors.grey,
                                                  );
                                                },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Flexible(
                                        child: Text(
                                          product['name'],
                                          style: TextStyle(
                                            fontSize: productFontSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Rp ${product['price']}',
                                        style: TextStyle(
                                          fontSize: priceFontSize,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Cart
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: const Color.fromARGB(255, 102, 64, 64),
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          color: Colors.blue.shade50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart,
                                size: 24,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Keranjang',
                                style: TextStyle(
                                  fontSize: cartTitleFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _cart.length,
                            itemBuilder: (context, index) {
                              final item = _cart[index];
                              return ListTile(
                                title: Text(item['name']),
                                subtitle: Text(
                                  'Rp ${item['price']} x ${item['quantity']}',
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      iconSize: 20,
                                      onPressed: () =>
                                          _updateQuantity(index, -1),
                                    ),
                                    Text('${item['quantity']}'),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      iconSize: 20,
                                      onPressed: () =>
                                          _updateQuantity(index, 1),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      iconSize: 20,
                                      onPressed: () => _removeFromCart(index),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: const Color.fromARGB(255, 133, 87, 87),
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Subtotal:'),
                                  Text(
                                    'Rp ${_calculateSubtotal().toStringAsFixed(0)}',
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Diskon:'),
                                  Text('Rp $_discount'),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Pajak (10%):'),
                                  Text('Rp ${_tax.toStringAsFixed(0)}'),
                                ],
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Rp ${_total.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: totalFontSize,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _cart.isEmpty
                                      ? null
                                      : _showPaymentDialog,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                  child: const Text('Bayar'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Mobile layout: Column
            return Column(
              children: [
                // Product List
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Cari produk...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onChanged: _filterProducts,
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(8),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: 1.0,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = _filteredProducts[index];
                            return Card(
                              child: InkWell(
                                onTap: () => _addToCart(product),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Product Image
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          color: Colors.grey.shade200,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.network(
                                            product['image'],
                                            fit: BoxFit.cover,
                                            loadingBuilder:
                                                (
                                                  context,
                                                  child,
                                                  loadingProgress,
                                                ) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return const Center(
                                                    child: SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child:
                                                          CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                          ),
                                                    ),
                                                  );
                                                },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return const Icon(
                                                    Icons.inventory,
                                                    size: 30,
                                                    color: Colors.grey,
                                                  );
                                                },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Flexible(
                                        child: Text(
                                          product['name'],
                                          style: TextStyle(
                                            fontSize: productFontSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Rp ${product['price']}',
                                        style: TextStyle(
                                          fontSize: priceFontSize,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Cart
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          color: Colors.blue.shade50,
                          child: Text(
                            '🛒',
                            style: TextStyle(
                              fontSize: cartTitleFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _cart.length,
                            itemBuilder: (context, index) {
                              final item = _cart[index];
                              return ListTile(
                                title: Text(item['name']),
                                subtitle: Text(
                                  'Rp ${item['price']} x ${item['quantity']}',
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      iconSize: 20,
                                      onPressed: () =>
                                          _updateQuantity(index, -1),
                                    ),
                                    Text('${item['quantity']}'),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      iconSize: 20,
                                      onPressed: () =>
                                          _updateQuantity(index, 1),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      iconSize: 20,
                                      onPressed: () => _removeFromCart(index),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Subtotal:'),
                                  Text(
                                    'Rp ${_calculateSubtotal().toStringAsFixed(0)}',
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Diskon:'),
                                  Text('Rp $_discount'),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Pajak (10%):'),
                                  Text('Rp ${_tax.toStringAsFixed(0)}'),
                                ],
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Rp ${_total.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: totalFontSize,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _cart.isEmpty
                                      ? null
                                      : _showPaymentDialog,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                  child: const Text('Bayar'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  void _filterProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts = List.from(_products);
    } else {
      _filteredProducts = _products
          .where(
            (product) =>
                product['name'].toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    setState(() {});
  }

  void _addToCart(Map<String, dynamic> product) {
    final existingIndex = _cart.indexWhere(
      (item) => item['name'] == product['name'],
    );
    if (existingIndex >= 0) {
      _cart[existingIndex]['quantity']++;
    } else {
      _cart.add({...product, 'quantity': 1});
    }
    _calculateTotal();
  }

  void _updateQuantity(int index, int change) {
    _cart[index]['quantity'] += change;
    if (_cart[index]['quantity'] <= 0) {
      _cart.removeAt(index);
    }
    _calculateTotal();
  }

  void _removeFromCart(int index) {
    _cart.removeAt(index);
    _calculateTotal();
  }

  double _calculateSubtotal() {
    return _cart.fold(
      0,
      (sum, item) => sum + (item['price'] * item['quantity']),
    );
  }

  void _calculateTotal() {
    final subtotal = _calculateSubtotal();
    _tax = subtotal * 0.1; // 10% tax
    _total = subtotal - _discount + _tax;
    setState(() {});
  }

  void _scanBarcode() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BarcodeScannerScreen()),
    );
    if (result != null && mounted) {
      // Add scanned product to cart
      _addToCart(result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Produk ${result['name']} ditambahkan ke keranjang'),
        ),
      );
    }
  }

  void _aiRecognition() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AiRecognitionScreen()),
    );
    if (result != null && mounted) {
      // Add recognized product to cart
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produk $result ditambahkan ke keranjang')),
      );
    }
  }

  void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Metode Pembayaran'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.money),
                title: const Text('Tunai'),
                onTap: () => _processPayment('Tunai'),
              ),
              ListTile(
                leading: const Icon(Icons.qr_code),
                title: const Text('QRIS'),
                onTap: () => _processPayment('QRIS'),
              ),
              ListTile(
                leading: const Icon(Icons.account_balance),
                title: const Text('Transfer'),
                onTap: () => _processPayment('Transfer'),
              ),
              ListTile(
                leading: const Icon(Icons.phone_android),
                title: const Text('E-Wallet'),
                onTap: () => _processPayment('E-Wallet'),
              ),
              ListTile(
                leading: const Icon(Icons.qr_code_scanner),
                title: const Text('Barcode'),
                onTap: () => _processPayment('Barcode'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _processPayment(String method) {
    if (method == 'Barcode') {
      _scanPaymentBarcode();
    } else {
      _finalizePayment(method);
    }
  }

  void _scanPaymentBarcode() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BarcodeScannerScreen()),
    );
    if (result != null && mounted) {
      _finalizePayment('Barcode');
    }
  }

  void _finalizePayment(String method) {
    Navigator.pop(context);

    // Create transaction data
    final transaction = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'date': DateTime.now().toString().split(' ')[0],
      'time': TimeOfDay.now().format(context),
      'cashier': 'Admin',
      'items': _cart
          .map(
            (item) => {
              'name': item['name'],
              'price': item['price'],
              'quantity': item['quantity'],
            },
          )
          .toList(),
      'subtotal': _calculateSubtotal(),
      'discount': _discount,
      'tax': _tax,
      'total': _total,
      'paymentMethod': method,
      'paid': method == 'Tunai'
          ? _total
          : _total, // Assume exact payment for demo
      'change': method == 'Tunai' ? 0 : 0,
    };

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pembayaran dengan $method berhasil')),
    );

    // Navigate to digital receipt
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DigitalReceiptScreen(transaction: transaction),
      ),
    );

    // Clear cart
    _cart.clear();
    _calculateTotal();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
