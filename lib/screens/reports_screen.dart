import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart' as excel_pkg;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Export Laporan'),
          content: const Text('Pilih format export:'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _exportPDF();
              },
              child: const Text('PDF'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _exportExcel();
              },
              child: const Text('Excel'),
            ),
          ],
        );
      },
    );
  }

  void _shareReport() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/laporan_penjualan.pdf');

      if (await file.exists()) {
        await Share.shareXFiles([XFile(file.path)], text: 'Laporan Penjualan');
      } else {
        // Generate PDF first if it doesn't exist
        _exportPDF();
        await Future.delayed(
          const Duration(seconds: 1),
        ); // Wait for PDF to be generated
        await Share.shareXFiles([XFile(file.path)], text: 'Laporan Penjualan');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal share laporan')));
    }
  }

  void _exportPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Laporan Penjualan',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text('Periode: $_selectedPeriod'),
              pw.SizedBox(height: 20),
              pw.Text(
                'Ringkasan:',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text('Total Penjualan: Rp ${_reportData['totalSales']}'),
              pw.Text('Jumlah Transaksi: ${_reportData['totalTransactions']}'),
              pw.Text('Keuntungan: Rp ${_reportData['totalProfit']}'),
              pw.SizedBox(height: 20),
              pw.Text(
                'Produk Terlaris:',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              ...(_reportData['topProducts'] as List).map((product) {
                return pw.Text(
                  '${product['name']}: ${product['sales']} unit - Rp ${product['revenue']}',
                );
              }),
              pw.SizedBox(height: 20),
              pw.Text(
                'Laporan Laba Rugi:',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text('Pendapatan Penjualan: Rp ${_reportData['totalSales']}'),
              pw.Text(
                'Harga Pokok Penjualan: -Rp ${(_reportData['totalSales'] * 0.7).round()}',
              ),
              pw.Text(
                'Laba Kotor: Rp ${(_reportData['totalSales'] * 0.3).round()}',
              ),
              pw.Text(
                'Biaya Operasional: -Rp ${(_reportData['totalSales'] * 0.15).round()}',
              ),
              pw.Text(
                'Pajak: -Rp ${(_reportData['totalSales'] * 0.05).round()}',
              ),
              pw.Text(
                'Laba Bersih: Rp ${_reportData['totalProfit']}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ],
          );
        },
      ),
    );

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/laporan_penjualan.pdf');
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF berhasil disimpan di ${file.path}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal export PDF')));
    }
  }

  void _exportExcel() async {
    var excel = excel_pkg.Excel.createExcel();
    var sheet = excel['Laporan'];

    // Header
    sheet.appendRow([excel_pkg.TextCellValue('Laporan Penjualan')]);
    sheet.appendRow([
      excel_pkg.TextCellValue('Periode'),
      excel_pkg.TextCellValue(_selectedPeriod),
    ]);
    sheet.appendRow([excel_pkg.TextCellValue('')]);

    // Summary
    sheet.appendRow([excel_pkg.TextCellValue('Ringkasan')]);
    sheet.appendRow([
      excel_pkg.TextCellValue('Total Penjualan'),
      excel_pkg.TextCellValue('Rp ${_reportData['totalSales']}'),
    ]);
    sheet.appendRow([
      excel_pkg.TextCellValue('Jumlah Transaksi'),
      excel_pkg.TextCellValue('${_reportData['totalTransactions']}'),
    ]);
    sheet.appendRow([
      excel_pkg.TextCellValue('Keuntungan'),
      excel_pkg.TextCellValue('Rp ${_reportData['totalProfit']}'),
    ]);
    sheet.appendRow([excel_pkg.TextCellValue('')]);

    // Top Products
    sheet.appendRow([excel_pkg.TextCellValue('Produk Terlaris')]);
    sheet.appendRow([
      excel_pkg.TextCellValue('Nama Produk'),
      excel_pkg.TextCellValue('Unit Terjual'),
      excel_pkg.TextCellValue('Pendapatan'),
    ]);
    for (var product in _reportData['topProducts']) {
      sheet.appendRow([
        excel_pkg.TextCellValue(product['name']),
        excel_pkg.TextCellValue('${product['sales']}'),
        excel_pkg.TextCellValue('Rp ${product['revenue']}'),
      ]);
    }
    sheet.appendRow([excel_pkg.TextCellValue('')]);

    // Profit & Loss
    sheet.appendRow([excel_pkg.TextCellValue('Laporan Laba Rugi')]);
    sheet.appendRow([
      excel_pkg.TextCellValue('Pendapatan Penjualan'),
      excel_pkg.TextCellValue('Rp ${_reportData['totalSales']}'),
    ]);
    sheet.appendRow([
      excel_pkg.TextCellValue('Harga Pokok Penjualan'),
      excel_pkg.TextCellValue(
        '-Rp ${(_reportData['totalSales'] * 0.7).round()}',
      ),
    ]);
    sheet.appendRow([
      excel_pkg.TextCellValue('Laba Kotor'),
      excel_pkg.TextCellValue(
        'Rp ${(_reportData['totalSales'] * 0.3).round()}',
      ),
    ]);
    sheet.appendRow([
      excel_pkg.TextCellValue('Biaya Operasional'),
      excel_pkg.TextCellValue(
        '-Rp ${(_reportData['totalSales'] * 0.15).round()}',
      ),
    ]);
    sheet.appendRow([
      excel_pkg.TextCellValue('Pajak'),
      excel_pkg.TextCellValue(
        '-Rp ${(_reportData['totalSales'] * 0.05).round()}',
      ),
    ]);
    sheet.appendRow([
      excel_pkg.TextCellValue('Laba Bersih'),
      excel_pkg.TextCellValue('Rp ${_reportData['totalProfit']}'),
    ]);

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/laporan_penjualan.xlsx');
      await file.writeAsBytes(excel.encode()!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Excel berhasil disimpan di ${file.path}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal export Excel')));
    }
  }
}
