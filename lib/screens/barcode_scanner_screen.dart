import 'package:flutter/material.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  bool _isScanning = false;
  String _scanResult = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Scanner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flashlight_on),
            onPressed: _toggleFlash,
          ),
        ],
      ),
      body: Column(
        children: [
          // Camera Preview Placeholder
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(Icons.camera_alt, size: 64, color: Colors.grey),
                  ),
                  const Center(
                    child: Text(
                      'Camera Preview',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ),
                  // Scanning overlay
                  Center(
                    child: Container(
                      width: 250,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _isScanning ? Colors.green : Colors.red,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'Position barcode here',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Scan Result
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Scan Result:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _scanResult.isEmpty ? 'No barcode detected' : _scanResult,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _startScanning,
                        icon: Icon(_isScanning ? Icons.stop : Icons.play_arrow),
                        label: Text(_isScanning ? 'Stop' : 'Start Scan'),
                      ),
                      ElevatedButton.icon(
                        onPressed: _scanResult.isNotEmpty ? _addToCart : null,
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Add to Cart'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Recent Scans
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recent Scans:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.qr_code),
                            title: Text('Product ${1001 + index}'),
                            subtitle: Text('Scanned ${index + 1} min ago'),
                            trailing: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                // Add to cart
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startScanning() {
    setState(() {
      _isScanning = !_isScanning;
      if (_isScanning) {
        // Simulate scanning
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && _isScanning) {
            setState(() {
              _scanResult = '123456789012'; // Simulated barcode
              _isScanning = false;
            });
            _showProductDialog(_scanResult);
          }
        });
      }
    });
  }

  void _toggleFlash() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Flash toggle belum diimplementasi')),
    );
  }

  void _addToCart() {
    if (_scanResult.isNotEmpty) {
      // Add product to cart logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produk $_scanResult ditambahkan ke keranjang')),
      );
      Navigator.pop(context, _scanResult);
    }
  }

  void _showProductDialog(String barcode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Product Found'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Barcode: $barcode'),
            const SizedBox(height: 8),
            const Text('Product: Indomie Goreng'),
            const Text('Price: Rp 3,500'),
            const Text('Stock: 45'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _addToCart();
            },
            child: const Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}
