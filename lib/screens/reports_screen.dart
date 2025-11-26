import 'package:flutter/material.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedPeriod = 'Hari Ini';
  final List<String> _periods = [
    'Hari Ini',
    'Minggu Ini',
    'Bulan Ini',
    'Tahun Ini',
  ];

  final Map<String, dynamic> _reportData = {
    'totalSales': 2500000,
    'totalTransactions': 45,
    'totalProfit': 750000,
    'topProducts': [
      {'name': 'Indomie Goreng', 'sales': 120, 'revenue': 420000},
      {'name': 'Teh Botol', 'sales': 95, 'revenue': 475000},
      {'name': 'Susu Ultra', 'sales': 85, 'revenue': 1020000},
    ],
    'dailySales': [50000, 75000, 60000, 85000, 95000, 120000, 150000],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Penjualan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportReport,
          ),
          IconButton(icon: const Icon(Icons.share), onPressed: _shareReport),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period Selector
            Row(
              children: [
                const Text('Periode: '),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedPeriod,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: _periods.map((period) {
                      return DropdownMenuItem(
                        value: period,
                        child: Text(period),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPeriod = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Total Penjualan',
                    'Rp ${_reportData['totalSales']}',
                    Icons.attach_money,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    'Jumlah Transaksi',
                    '${_reportData['totalTransactions']}',
                    Icons.receipt,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Keuntungan',
                    'Rp ${_reportData['totalProfit']}',
                    Icons.trending_up,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    'Rata-rata/Transaksi',
                    'Rp ${(_reportData['totalSales'] / _reportData['totalTransactions']).round()}',
                    Icons.analytics,
                    Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Sales Chart (Placeholder)
            const Text(
              'Grafik Penjualan Harian',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text('Grafik penjualan akan ditampilkan di sini'),
              ),
            ),
            const SizedBox(height: 24),

            // Top Products
            const Text(
              'Produk Terlaris',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildTopProductsList(),

            const SizedBox(height: 24),

            // Profit & Loss
            const Text(
              'Laporan Laba Rugi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildProfitRow(
                      'Pendapatan Penjualan',
                      _reportData['totalSales'],
                      isPositive: true,
                    ),
                    _buildProfitRow(
                      'Harga Pokok Penjualan',
                      (_reportData['totalSales'] * 0.7).round(),
                      isPositive: false,
                    ),
                    const Divider(),
                    _buildProfitRow(
                      'Laba Kotor',
                      (_reportData['totalSales'] * 0.3).round(),
                      isPositive: true,
                    ),
                    _buildProfitRow(
                      'Biaya Operasional',
                      (_reportData['totalSales'] * 0.15).round(),
                      isPositive: false,
                    ),
                    _buildProfitRow(
                      'Pajak',
                      (_reportData['totalSales'] * 0.05).round(),
                      isPositive: false,
                    ),
                    const Divider(thickness: 2),
                    _buildProfitRow(
                      'Laba Bersih',
                      _reportData['totalProfit'],
                      isPositive: true,
                      isBold: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Export Options
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _exportPDF,
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Export PDF'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _exportExcel,
                    icon: const Icon(Icons.table_chart),
                    label: const Text('Export Excel'),
                    style: ElevatedButton.styleFrom(
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

  Widget _buildTopProductsList() {
    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _reportData['topProducts'].length,
        itemBuilder: (context, index) {
          final product = _reportData['topProducts'][index];
          return ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(product['name']),
            subtitle: Text('${product['sales']} unit terjual'),
            trailing: Text(
              'Rp ${product['revenue']}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfitRow(
    String label,
    int amount, {
    bool isPositive = true,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '${isPositive ? '' : '-'}Rp $amount',
            style: TextStyle(
              color: isPositive ? Colors.green : Colors.red,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _exportReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export laporan belum diimplementasi')),
    );
  }

  void _shareReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share laporan belum diimplementasi')),
    );
  }

  void _exportPDF() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export PDF belum diimplementasi')),
    );
  }

  void _exportExcel() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export Excel belum diimplementasi')),
    );
  }
}
