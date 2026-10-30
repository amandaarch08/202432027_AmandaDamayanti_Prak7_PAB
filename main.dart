
import 'package:flutter/material.dart';

void main() {
  runApp(const DompetkuApp());
}

// ===============================
// WARNA APLIKASI
// ===============================

const Color sageGreen = Color(0xFF568F7A);
const Color softMint = Color(0xFFA8DCCB);
const Color cream = Color(0xFFF5F5E9);
const Color darkGreen = Color(0xFF344C43);

// ===============================
// MODEL KATEGORI
// ===============================

class Category {
  const Category(this.name, this.imagePath);

  final String name;
  final String imagePath;
}

const categories = [
  Category('Makanan', 'assets/images/makanan.png'),
  Category('Transportasi', 'assets/images/transportasi.png'),
  Category('Belanja', 'assets/images/belanja.png'),
  Category('Hiburan', 'assets/images/hiburan.png'),
  Category('Kesehatan', 'assets/images/kesehatan.png'),
];

// ===============================
// MODEL TRANSAKSI
// ===============================

class Expense {
  Expense(this.title, this.amount, this.category);

  final String title;
  final double amount;
  final Category category;
}

// ===============================
// FORMAT RUPIAH
// ===============================

String formatRupiah(double value) {
  final digits = value.toStringAsFixed(0);
  final buffer = StringBuffer();

  for (var i = 0; i < digits.length; i++) {
    final sisa = digits.length - i;
    buffer.write(digits[i]);

    if (sisa > 1 && sisa % 3 == 1) {
      buffer.write('.');
    }
  }

  return 'Rp $buffer';
}

// ===============================
// APLIKASI UTAMA
// ===============================

class DompetkuApp extends StatelessWidget {
  const DompetkuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dompetku',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: sageGreen,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: cream,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: cream,
          foregroundColor: darkGreen,
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      home: const DashboardPage(),
    );
  }
}

// ===============================
// DASHBOARD
// ===============================

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<Expense> _expenses = [
    Expense('Makan Siang', 25000, categories[0]),
    Expense('Ojek ke Kampus', 15000, categories[1]),
    Expense('Beli Buku', 85000, categories[2]),
    Expense('Nonton Bioskop', 50000, categories[3]),
    Expense('Kopi Susu', 18000, categories[0]),
  ];

  double get _total =>
      _expenses.fold(0, (sum, e) => sum + e.amount);

  Expense? get _largestExpense {
    if (_expenses.isEmpty) return null;

    return _expenses.reduce(
      (a, b) => a.amount >= b.amount ? a : b,
    );
  }

  Future<void> _openForm() async {
    final result = await Navigator.push<Expense>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddTransactionPage(),
      ),
    );

    if (result == null) return;

    setState(() {
      _expenses.add(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dompetku',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                ),
              ),
              Text(
                'Kelola pengeluaranmu dengan mudah',
                style: TextStyle(fontSize: 11),
              ),
            ],
          ),
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: sageGreen,
            unselectedLabelColor: Colors.grey,
            indicatorColor: sageGreen,
            tabs: [
              Tab(
                icon: Icon(Icons.receipt_long),
                text: 'Transaksi',
              ),
              Tab(
                icon: Icon(Icons.category),
                text: 'Kategori',
              ),
              Tab(
                icon: Icon(Icons.person),
                text: 'Profil',
              ),
              Tab(
                icon: Icon(Icons.bar_chart),
                text: 'Statistik',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TransaksiTab(
              expenses: _expenses,
              total: _total,
            ),
            KategoriTab(expenses: _expenses),
            const ProfilTab(),
            StatistikTab(expense: _largestExpense),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _openForm,
          backgroundColor: sageGreen,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add),
          label: const Text('Tambah'),
        ),
      ),
    );
  }
}

// ===============================
// TAB TRANSAKSI
// LISTVIEW.BUILDER
// ===============================

class TransaksiTab extends StatelessWidget {
  const TransaksiTab({
    super.key,
    required this.expenses,
    required this.total,
  });

  final List<Expense> expenses;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            color: sageGreen,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Total Pengeluaran',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    formatRupiah(total),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${expenses.length} transaksi tercatat',
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Riwayat Transaksi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: darkGreen,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final e = expenses[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: Image.asset(
                    e.category.imagePath,
                    width: 45,
                    height: 45,
                  ),
                  title: Text(
                    e.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(e.category.name),
                  trailing: Text(
                    formatRupiah(e.amount),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: sageGreen,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ===============================
// TAB KATEGORI
// GRIDVIEW.BUILDER 2 KOLOM
// ===============================

class KategoriTab extends StatelessWidget {
  const KategoriTab({
    super.key,
    required this.expenses,
  });

  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) {
        final c = categories[index];

        final items = expenses
            .where((e) => e.category == c)
            .toList();

        final subtotal = items.fold<double>(
          0,
          (sum, e) => sum + e.amount,
        );

        return Card(
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  c.imagePath,
                  width: 65,
                  height: 65,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
                Text(
                  c.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: darkGreen,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${items.length} transaksi',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 5),
                Text(
                  formatRupiah(subtotal),
                  style: const TextStyle(
                    color: sageGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ===============================
// TAB PROFIL
// IMAGE.NETWORK DAN IMAGE.ASSET
// ===============================

class ProfilTab extends StatelessWidget {
  const ProfilTab({super.key});

  static const coverUrl =
      'https://raw.githubusercontent.com/flutter/website/main/examples/layout/lakes/step6/images/lake.jpg';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 30),
      children: [
        Image.network(
          coverUrl,
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;

            return const SizedBox(
              height: 180,
              child: Center(
                child: CircularProgressIndicator(
                  color: sageGreen,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return const SizedBox(
              height: 180,
              child: Center(
                child: Icon(
                  Icons.broken_image,
                  size: 48,
                  color: sageGreen,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        const Center(
          child: CircleAvatar(
            radius: 50,
            backgroundColor: softMint,
            backgroundImage: AssetImage(
              'assets/images/avatar.png',
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Center(
          child: Text(
            'Mahasiswa PAB',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: darkGreen,
            ),
          ),
        ),
        const Center(
          child: Text(
            'Institut Teknologi PLN',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(
                    Icons.school,
                    color: sageGreen,
                  ),
                  title: Text('Program Studi'),
                  subtitle: Text('Sistem Informasi'),
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(
                    Icons.book,
                    color: sageGreen,
                  ),
                  title: Text('Mata Kuliah'),
                  subtitle: Text(
                    'Pemrograman Aplikasi Bergerak',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ===============================
// TAB STATISTIK
// TRANSAKSI NOMINAL TERBESAR
// ===============================

class StatistikTab extends StatelessWidget {
  const StatistikTab({
    super.key,
    required this.expense,
  });

  final Expense? expense;

  @override
  Widget build(BuildContext context) {
    if (expense == null) {
      return const Center(
        child: Text('Belum ada transaksi.'),
      );
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.emoji_events,
                  color: Color(0xFFD6A548),
                  size: 65,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Pengeluaran Terbesar',
                  style: TextStyle(
                    color: darkGreen,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Image.asset(
                  expense!.category.imagePath,
                  width: 90,
                  height: 90,
                ),
                const SizedBox(height: 15),
                Text(
                  expense!.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  expense!.category.name,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 15),
                Text(
                  formatRupiah(expense!.amount),
                  style: const TextStyle(
                    fontSize: 26,
                    color: sageGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===============================
// FORM TAMBAH TRANSAKSI
// ===============================

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() =>
      _AddTransactionPageState();
}

class _AddTransactionPageState
    extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  Category _selectedCategory = categories.first;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(
      _amountController.text.trim(),
    );

    Navigator.pop(
      context,
      Expense(
        _titleController.text.trim(),
        amount,
        _selectedCategory,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Transaksi'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Judul transaksi',
                prefixIcon: const Icon(Icons.edit),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              validator: (v) {
                return v == null || v.trim().isEmpty
                    ? 'Judul wajib diisi'
                    : null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nominal',
                prefixIcon: const Icon(
                  Icons.payments,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Nominal wajib diisi';
                }

                final n = double.tryParse(v.trim());

                if (n == null || n <= 0) {
                  return 'Nominal harus angka > 0';
                }

                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Category>(
              initialValue: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Kategori',
                prefixIcon: const Icon(Icons.category),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              items: [
                for (final c in categories)
                  DropdownMenuItem(
                    value: c,
                    child: Row(
                      children: [
                        Image.asset(
                          c.imagePath,
                          width: 28,
                          height: 28,
                        ),
                        const SizedBox(width: 10),
                        Text(c.name),
                      ],
                    ),
                  ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.save),
              label: const Text('Simpan Transaksi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: sageGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
