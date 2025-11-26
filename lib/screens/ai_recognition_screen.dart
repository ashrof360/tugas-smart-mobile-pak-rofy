import 'package:flutter/material.dart';

class AiRecognitionScreen extends StatefulWidget {
  const AiRecognitionScreen({super.key});

  @override
  State<AiRecognitionScreen> createState() => _AiRecognitionScreenState();
}

class _AiRecognitionScreenState extends State<AiRecognitionScreen> {
  bool _isAnalyzing = false;
  String _recognizedProduct = '';
  double _confidence = 0.0;

  final List<Map<String, dynamic>> _recognizedProducts = [
    {'name': 'Indomie Goreng', 'confidence': 0.95, 'price': 3500},
    {'name': 'Teh Botol', 'confidence': 0.87, 'price': 5000},
    {'name': 'Susu Ultra', 'confidence': 0.92, 'price': 12000},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Product Recognition'),
        actions: [
          IconButton(icon: const Icon(Icons.info), onPressed: _showInfo),
        ],
      ),
      body: Column(
        children: [
          // Camera Preview
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(Icons.camera_alt, size: 64, color: Colors.grey),
                  ),
                  const Center(
                    child: Text(
                      'AI Camera View',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ),
                  if (_isAnalyzing)
                    const Center(child: CircularProgressIndicator()),
                  if (_recognizedProduct.isNotEmpty)
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(
                              _recognizedProduct,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Confidence: ${(_confidence * 100).toStringAsFixed(1)}%',
                              style: const TextStyle(
                                color: Color.fromARGB(255, 68, 48, 48),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Control Panel
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _startAnalysis,
                        icon: Icon(
                          _isAnalyzing ? Icons.stop : Icons.play_arrow,
                        ),
                        label: Text(
                          _isAnalyzing ? 'Stop Analysis' : 'Start Analysis',
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _recognizedProduct.isNotEmpty
                            ? _addToCart
                            : null,
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Add to Cart'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Recognition History
                  const Text(
                    'Recent Recognitions:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _recognizedProducts.length,
                      itemBuilder: (context, index) {
                        final product = _recognizedProducts[index];
                        return Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.smart_toy,
                              color: Colors.blue,
                            ),
                            title: Text(product['name']),
                            subtitle: Text(
                              'Confidence: ${(product['confidence'] * 100).toStringAsFixed(1)}%',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Rp ${product['price']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () => _addProductToCart(product),
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
            ),
          ),
        ],
      ),
    );
  }

  void _startAnalysis() {
    setState(() {
      _isAnalyzing = !_isAnalyzing;
      if (_isAnalyzing) {
        // Simulate AI analysis
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted && _isAnalyzing) {
            final randomProduct =
                _recognizedProducts[DateTime.now().millisecond %
                    _recognizedProducts.length];
            setState(() {
              _recognizedProduct = randomProduct['name'];
              _confidence = randomProduct['confidence'];
              _isAnalyzing = false;
            });
          }
        });
      } else {
        _recognizedProduct = '';
        _confidence = 0.0;
      }
    });
  }

  void _addToCart() {
    if (_recognizedProduct.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$_recognizedProduct ditambahkan ke keranjang')),
      );
      Navigator.pop(context, _recognizedProduct);
    }
  }

  void _addProductToCart(Map<String, dynamic> product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product['name']} ditambahkan ke keranjang')),
    );
  }

  void _showInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI Product Recognition'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fitur ini menggunakan computer vision untuk:'),
            SizedBox(height: 8),
            Text('• Mengidentifikasi produk secara otomatis'),
            Text('• Mengurangi kesalahan input manual'),
            Text('• Mempercepat proses checkout'),
            Text('• Mendukung berbagai jenis produk'),
            SizedBox(height: 16),
            Text(
              'Teknologi: TensorFlow Lite + Custom ML Model',
              style: TextStyle(fontWeight: FontWeight.bold),
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
}
