import 'package:flutter/material.dart';

class PriceRecommendationScreen extends StatefulWidget {
  const PriceRecommendationScreen({super.key});

  @override
  State<PriceRecommendationScreen> createState() =>
      _PriceRecommendationScreenState();
}

class _PriceRecommendationScreenState extends State<PriceRecommendationScreen> {
  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Indomie Goreng',
      'currentPrice': 3500,
      'marketPrice': 3200,
      'recommendedPrice': 3400,
      'margin': 15,
      'competitorPrices': [3200, 3300, 3500, 3100],
      'sales': 120,
      'category': 'Makanan Instan',
    },
    {
      'name': 'Susu Ultra',
      'currentPrice': 12000,
      'marketPrice': 11500,
      'recommendedPrice': 11800,
      'margin': 20,
      'competitorPrices': [11000, 11500, 12000, 12500],
      'sales': 85,
      'category': 'Minuman',
    },
    {
      'name': 'Teh Botol',
      'currentPrice': 5000,
      'marketPrice': 4800,
      'recommendedPrice': 4900,
      'margin': 25,
      'competitorPrices': [4500, 4800, 5000, 5200],
      'sales': 95,
      'category': 'Minuman',
    },
  ];

  String _selectedCategory = 'Semua';

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _selectedCategory == 'Semua'
        ? _products
        : _products.where((p) => p['category'] == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekomendasi Harga Pintar'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshData),
        ],
      ),
      body: Column(
        children: [
          // Filter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text('Kategori: '),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: ['Semua', 'Makanan Instan', 'Minuman'].map((
                      category,
                    ) {
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
              ],
            ),
          ),

          // Summary Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Total Produk',
                    '${filteredProducts.length}',
                    Icons.inventory,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    'Rata-rata Margin',
                    '${_calculateAverageMargin(filteredProducts)}%',
                    Icons.trending_up,
                    Colors.green,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Product List
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                final priceDiff =
                    product['recommendedPrice'] - product['currentPrice'];
                final isRecommended = priceDiff != 0;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  color: isRecommended ? Colors.blue.shade50 : null,
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: isRecommended
                          ? Colors.blue
                          : Colors.grey,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(product['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Harga saat ini: Rp ${product['currentPrice']}'),
                        Text(
                          'Rekomendasi: Rp ${product['recommendedPrice']}',
                          style: TextStyle(
                            color: isRecommended ? Colors.blue : Colors.grey,
                            fontWeight: isRecommended
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    trailing: isRecommended
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: priceDiff > 0 ? Colors.red : Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              priceDiff > 0
                                  ? '+Rp $priceDiff'
                                  : 'Rp $priceDiff',
                              style: const TextStyle(
                                color: Color.fromARGB(255, 189, 126, 126),
                                fontSize: 12,
                              ),
                            ),
                          )
                        : const Icon(Icons.check_circle, color: Colors.green),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Harga Pasar Rata-rata:'),
                                Text('Rp ${product['marketPrice']}'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Margin Keuntungan:'),
                                Text('${product['margin']}%'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Penjualan (30 hari):'),
                                Text('${product['sales']} unit'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Harga Kompetitor:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: product['competitorPrices'].map<Widget>(
                                (price) {
                                  return Chip(
                                    label: Text('Rp $price'),
                                    backgroundColor:
                                        price == product['currentPrice']
                                        ? Colors.blue.shade100
                                        : Colors.grey.shade100,
                                  );
                                },
                              ).toList(),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        _applyRecommendation(product),
                                    child: const Text('Terapkan Rekomendasi'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => _customizePrice(product),
                                    child: const Text('Sesuaikan Manual'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  double _calculateAverageMargin(List<Map<String, dynamic>> products) {
    if (products.isEmpty) return 0;
    final totalMargin = products.fold<double>(0, (sum, p) => sum + p['margin']);
    return (totalMargin / products.length).roundToDouble();
  }

  void _refreshData() {
    // Simulate refreshing data
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data rekomendasi diperbarui')),
    );
  }

  void _applyRecommendation(Map<String, dynamic> product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Harga ${product['name']} diperbarui ke Rp ${product['recommendedPrice']}',
        ),
      ),
    );
  }

  void _customizePrice(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController(
          text: product['currentPrice'].toString(),
        );
        return AlertDialog(
          title: Text('Sesuaikan Harga ${product['name']}'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Harga Baru',
              border: OutlineInputBorder(),
              prefixText: 'Rp ',
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
                final newPrice =
                    int.tryParse(controller.text) ?? product['currentPrice'];
                setState(() {
                  product['currentPrice'] = newPrice;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Harga ${product['name']} diperbarui ke Rp $newPrice',
                    ),
                  ),
                );
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}
