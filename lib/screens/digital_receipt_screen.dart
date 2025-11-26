import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DigitalReceiptScreen extends StatefulWidget {
  final Map<String, dynamic> transaction;

  const DigitalReceiptScreen({super.key, required this.transaction});

  @override
  State<DigitalReceiptScreen> createState() => _DigitalReceiptScreenState();
}

class _DigitalReceiptScreenState extends State<DigitalReceiptScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Struk Digital'),
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: _shareReceipt),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadReceipt,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Screenshot(
          controller: _screenshotController,
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Header
                  const Center(
                    child: Text(
                      'KASIR CERDAS',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Jl. Contoh No. 123, Jakarta',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Telp: (021) 1234567',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),

                  // Transaction Info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('No. Transaksi:'),
                      Text('#${widget.transaction['id'] ?? '001'}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tanggal:'),
                      Text(
                        widget.transaction['date'] ??
                            DateTime.now().toString().split(' ')[0],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Waktu:'),
                      Text(
                        widget.transaction['time'] ??
                            TimeOfDay.now().format(context),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Kasir:'),
                      Text(widget.transaction['cashier'] ?? 'Admin'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),

                  // Items
                  const Text(
                    'Detail Pembelian',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ..._buildItemList(),

                  const Divider(),

                  // Totals
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal:'),
                      Text('Rp ${widget.transaction['subtotal'] ?? 0}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Diskon:'),
                      Text('Rp ${widget.transaction['discount'] ?? 0}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Pajak (10%):'),
                      Text('Rp ${widget.transaction['tax'] ?? 0}'),
                    ],
                  ),
                  const Divider(thickness: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'TOTAL:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Rp ${widget.transaction['total'] ?? 0}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Payment Info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Metode Pembayaran:'),
                      Text(widget.transaction['paymentMethod'] ?? 'Tunai'),
                    ],
                  ),
                  if (widget.transaction['paymentMethod'] == 'Tunai') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Bayar:'),
                        Text('Rp ${widget.transaction['paid'] ?? 0}'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Kembali:'),
                        Text('Rp ${widget.transaction['change'] ?? 0}'),
                      ],
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Footer
                  const Center(
                    child: Text(
                      'Terima Kasih Atas Kunjungan Anda!',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Barang yang sudah dibeli tidak dapat dikembalikan',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // QR Code for digital verification
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(Icons.qr_code, size: 48, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Scan untuk verifikasi digital',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _sendViaWhatsApp,
                icon: const Icon(Icons.message),
                label: const Text('Kirim WhatsApp'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _sendViaEmail,
                icon: const Icon(Icons.email),
                label: const Text('Kirim Email'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildItemList() {
    final items =
        widget.transaction['items'] as List<Map<String, dynamic>>? ?? [];
    return items.map((item) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Expanded(flex: 3, child: Text(item['name'] ?? '')),
            Expanded(flex: 1, child: Text('${item['quantity'] ?? 0}x')),
            Expanded(
              flex: 2,
              child: Text(
                'Rp ${item['price'] ?? 0}',
                textAlign: TextAlign.right,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'Rp ${(item['price'] ?? 0) * (item['quantity'] ?? 0)}',
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  void _shareReceipt() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share struk belum diimplementasi')),
    );
  }

  void _downloadReceipt() async {
    final image = await _screenshotController.capture();
    if (image != null) {
      try {
        final directory = await getTemporaryDirectory();
        final imagePath =
            '${directory.path}/receipt_${DateTime.now().millisecondsSinceEpoch}.png';
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(image);

        await Share.shareXFiles([XFile(imagePath)], text: 'Struk Pembelian');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Struk berhasil dibagikan')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal membagikan struk')),
          );
        }
      }
    }
  }

  void _sendViaWhatsApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kirim via WhatsApp belum diimplementasi')),
    );
  }

  void _sendViaEmail() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kirim via Email belum diimplementasi')),
    );
  }
}
