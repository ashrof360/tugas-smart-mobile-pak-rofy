import 'package:flutter/material.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final List<Map<String, dynamic>> _customers = [
    {
      'name': 'Ahmad Surya',
      'phone': '081234567890',
      'email': 'ahmad@example.com',
      'points': 250,
      'totalSpent': 150000,
      'lastVisit': '2024-01-15',
      'transactions': 12,
    },
    {
      'name': 'Siti Nurhaliza',
      'phone': '081987654321',
      'email': 'siti@example.com',
      'points': 180,
      'totalSpent': 120000,
      'lastVisit': '2024-01-14',
      'transactions': 8,
    },
    {
      'name': 'Budi Santoso',
      'phone': '081345678901',
      'email': 'budi@example.com',
      'points': 320,
      'totalSpent': 200000,
      'lastVisit': '2024-01-13',
      'transactions': 15,
    },
  ];

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Pelanggan'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _addCustomer),
          IconButton(
            icon: const Icon(Icons.qr_code),
            onPressed: _scanLoyaltyCard,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari pelanggan...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),

          // Customer Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Pelanggan',
                    '${_customers.length}',
                    Icons.people,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Total Poin',
                    '${_customers.fold<int>(0, (sum, c) => sum + (c['points'] as int))}',
                    Icons.stars,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Customer List
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCustomers.length,
              itemBuilder: (context, index) {
                final customer = _filteredCustomers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        customer['name'][0].toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(customer['name']),
                    subtitle: Text(customer['phone']),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Email:'),
                                Text(customer['email']),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Poin Loyalty:'),
                                Text(
                                  '${customer['points']} poin',
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total Belanja:'),
                                Text(
                                  'Rp ${customer['totalSpent']}',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Kunjungan Terakhir:'),
                                Text(customer['lastVisit']),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Jumlah Transaksi:'),
                                Text('${customer['transactions']} kali'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _sendPromo(customer),
                                    icon: const Icon(Icons.send),
                                    label: const Text('Kirim Promo'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () =>
                                        _viewTransactionHistory(customer),
                                    icon: const Icon(Icons.history),
                                    label: const Text('Riwayat'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _addCustomer,
        child: const Icon(Icons.person_add),
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredCustomers {
    if (_searchController.text.isEmpty) {
      return _customers;
    }
    final query = _searchController.text.toLowerCase();
    return _customers.where((customer) {
      return customer['name'].toLowerCase().contains(query) ||
          customer['phone'].contains(query) ||
          customer['email'].toLowerCase().contains(query);
    }).toList();
  }

  Widget _buildStatCard(
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

  void _addCustomer() {
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController();
        final phoneController = TextEditingController();
        final emailController = TextEditingController();

        return AlertDialog(
          title: const Text('Tambah Pelanggan Baru'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    phoneController.text.isNotEmpty) {
                  setState(() {
                    _customers.add({
                      'name': nameController.text,
                      'phone': phoneController.text,
                      'email': emailController.text,
                      'points': 0,
                      'totalSpent': 0,
                      'lastVisit': DateTime.now().toString().split(' ')[0],
                      'transactions': 0,
                    });
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pelanggan berhasil ditambahkan'),
                    ),
                  );
                }
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  void _scanLoyaltyCard() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Scan kartu loyalty belum diimplementasi')),
    );
  }

  void _sendPromo(Map<String, dynamic> customer) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Promo dikirim ke ${customer['name']}')),
    );
  }

  void _viewTransactionHistory(Map<String, dynamic> customer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Riwayat Transaksi ${customer['name']}'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: customer['transactions'],
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.receipt),
                title: Text('Transaksi #${1001 + index}'),
                subtitle: Text('Rp ${(index + 1) * 25000}'),
                trailing: Text(
                  '${DateTime.now().subtract(Duration(days: index)).toString().split(' ')[0]}',
                ),
              );
            },
          ),
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
