import 'package:flutter/material.dart';
import 'price_recommendation_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Indomie Goreng',
      'stock': 45,
      'minStock': 10,
      'price': 3500,
      'category': 'Makanan',
      'lastRestock': '2024-01-15',
      'sales': 120,
    },
    {
      'name': 'Susu Ultra',
      'stock': 8,
      'minStock': 15,
      'price': 12000,
      'category': 'Minuman',
      'lastRestock': '2024-01-10',
      'sales': 85,
    },
    {
      'name': 'Teh Botol',
      'stock': 25,
      'minStock': 20,
      'price': 5000,
      'category': 'Minuman',
      'lastRestock': '2024-01-12',
      'sales': 95,
    },
    {
      'name': 'Roti Tawar',
      'stock': 5,
      'minStock': 12,
      'price': 15000,
      'category': 'Makanan',
      'lastRestock': '2024-01-08',
      'sales': 60,
    },
  ];

  String _selectedCategory = 'Semua';
  final List<String> _categories = ['Semua', 'Makanan', 'Minuman'];

  @override
  Widget build(BuildContext context) {
    final lowStockProducts = _products
        .where((p) => p['stock'] <= p['minStock'])
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Inventori'),
        actions: [
          IconButton(
            icon: const Icon(Icons.attach_money),
            onPressed: _showPriceRecommendations,
          ),
          IconButton(icon: const Icon(Icons.add), onPressed: _addProduct),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: _scanProduct,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter and Search
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Kategori',
                      border: OutlineInputBorder(),
                    ),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _predictStock,
                  icon: const Icon(Icons.analytics),
                  label: const Text('Prediksi'),
                ),
              ],
            ),
          ),

          // Low Stock Alert
          if (lowStockProducts.isNotEmpty)
            Container(
              color: Colors.red.shade50,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${lowStockProducts.length} produk stok rendah',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Show low stock details
                    },
                    child: const Text('Lihat Detail'),
                  ),
                ],
              ),
            ),

          // Product List
          Expanded(
            child: ListView.builder(
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                final isLowStock = product['stock'] <= product['minStock'];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  color: isLowStock ? Colors.red.shade50 : null,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isLowStock ? Colors.red : Colors.blue,
                      child: Text(
                        product['stock'].toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(product['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Kategori: ${product['category']}'),
                        Text('Harga: Rp ${product['price']}'),
                        Text('Penjualan: ${product['sales']} unit'),
                        Text('Terakhir restock: ${product['lastRestock']}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editProduct(product),
                        ),
                        IconButton(
                          icon: const Icon(Icons.inventory),
                          onPressed: () => _restockProduct(product),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProduct,
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredProducts {
    if (_selectedCategory == 'Semua') {
      return _products;
    }
    return _products.where((p) => p['category'] == _selectedCategory).toList();
  }

  void _addProduct() {
    // Navigate to add product screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tambah produk belum diimplementasi')),
    );
  }

  void _editProduct(Map<String, dynamic> product) {
    // Navigate to edit product screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit ${product['name']} belum diimplementasi')),
    );
  }

  void _restockProduct(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text('Restock ${product['name']}'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Jumlah tambah stok',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = int.tryParse(controller.text) ?? 0;
                setState(() {
                  product['stock'] += amount;
                  product['lastRestock'] = DateTime.now().toString().split(
                    ' ',
                  )[0];
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Stok ${product['name']} ditambah $amount'),
                  ),
                );
              },
              child: const Text('Restock'),
            ),
          ],
        );
      },
    );
  }

  void _scanProduct() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Scan produk belum diimplementasi')),
    );
  }

  void _predictStock() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Prediksi Kebutuhan Stok'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _products.map((product) {
            final prediction = (product['sales'] * 1.2)
                .round(); // Simple prediction
            return ListTile(
              title: Text(product['name']),
              subtitle: Text('Prediksi: $prediction unit untuk bulan depan'),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showPriceRecommendations() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PriceRecommendationScreen(),
      ),
    );
  }
}
