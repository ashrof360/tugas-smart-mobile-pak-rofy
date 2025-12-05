import 'package:flutter/material.dart';
import 'barcode_scanner_screen.dart';
import 'inventory_screen.dart';
import 'reports_screen.dart';
import 'digital_receipt_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: _showNotifications,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettings,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Today's Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Penjualan Hari Ini',
                    'Rp 2.500.000',
                    Icons.attach_money,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    'Transaksi',
                    '45',
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
                    'Produk Terlaris',
                    'Indomie Goreng',
                    Icons.trending_up,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    'Stok Kritis',
                    '3 Produk',
                    Icons.warning,
                    Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quick Actions
            const Text(
              'Aksi Cepat',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickAction('Scan Barcode', Icons.qr_code_scanner, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BarcodeScannerScreen(),
                    ),
                  );
                }),
                _buildQuickAction('Tambah Produk', Icons.add_box, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InventoryScreen(),
                    ),
                  );
                }),
                _buildQuickAction('Cetak Struk', Icons.print, _printReceipt),
                _buildQuickAction('Laporan', Icons.analytics, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReportsScreen(),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 24),

            // Recent Transactions
            const Text(
              'Transaksi Terbaru',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildRecentTransactions(),

            const SizedBox(height: 24),

            // Low Stock Alert
            const Text(
              'Peringatan Stok Rendah',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildLowStockAlerts(),
          ],
        ),
      ),
    );
  }

  void _showNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifikasi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            ListTile(
              leading: Icon(Icons.warning, color: Colors.red),
              title: Text('Stok Indomie Goreng rendah'),
              subtitle: Text('Stok tersisa: 2'),
            ),
            ListTile(
              leading: Icon(Icons.attach_money, color: Colors.green),
              title: Text('Penjualan hari ini mencapai target'),
              subtitle: Text('Rp 2.500.000'),
            ),
            ListTile(
              leading: Icon(Icons.inventory, color: Colors.blue),
              title: Text('Produk baru ditambahkan'),
              subtitle: Text('Chitato Lite'),
            ),
          ],
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

  void _showSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pengaturan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur profil belum diimplementasi'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifikasi'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pengaturan notifikasi belum diimplementasi'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.print),
              title: const Text('Printer'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pengaturan printer belum diimplementasi'),
                  ),
                );
              },
            ),
          ],
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

  void _printReceipt() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cetak Struk'),
        content: const Text(
          'Fitur cetak struk akan segera hadir. Untuk sementara, gunakan struk digital.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const DigitalReceiptScreen(transaction: {}),
                ),
              );
            },
            child: const Text('Lihat Struk Digital'),
          ),
        ],
      ),
    );
  }

  void _restockProduct(String productName) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text('Restock $productName'),
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
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Stok $productName ditambah $amount')),
                );
              },
              child: const Text('Restock'),
            ),
          ],
        );
      },
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

  Widget _buildQuickAction(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.blue, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.receipt),
            title: Text('Transaksi #${1001 + index}'),
            subtitle: Text('Rp ${(index + 1) * 25000}'),
            trailing: Text(
              '${DateTime.now().subtract(Duration(hours: index)).hour}:00',
            ),
          );
        },
      ),
    );
  }

  Widget _buildLowStockAlerts() {
    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) {
          final products = ['Indomie Goreng', 'Susu Ultra', 'Teh Botol'];
          final stocks = [2, 1, 3];
          return ListTile(
            leading: const Icon(Icons.warning, color: Colors.red),
            title: Text(products[index]),
            subtitle: Text('Stok tersisa: ${stocks[index]}'),
            trailing: ElevatedButton(
              onPressed: () => _restockProduct(products[index]),
              child: const Text('Restock'),
            ),
          );
        },
      ),
    );
  }
}
