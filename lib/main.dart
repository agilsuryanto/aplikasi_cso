import 'package:flutter/material.dart';

void main() => runApp(CSOApp());

class CSOApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CSO & Kebersihan',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}

// ==================== LOGIN PAGE ====================
class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login(BuildContext context) {
    final username = usernameController.text;
    final password = passwordController.text;

    if ((username == 'admin' || username == 'cso') && password == '1234') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainHomePage(user: username)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login gagal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login CSO/Admin')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: usernameController, decoration: InputDecoration(labelText: 'Username')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () => _login(context), child: Text('Login')),
          ],
        ),
      ),
    );
  }
}

// ==================== MAIN HOMEPAGE ====================
class MainHomePage extends StatefulWidget {
  final String user;
  MainHomePage({required this.user});

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [JadwalPage(), ChecklistPage(), LaporanPage()];
  final List<String> _titles = ['Jadwal Harian', 'Checklist Tugas', 'Laporan Kerusakan'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex],
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: _pages[_currentIndex],
      floatingActionButton: _currentIndex == 2
          ? FloatingActionButton(
        onPressed: () {
          // Aksi jika perlu
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Jadwal'),
          BottomNavigationBarItem(icon: Icon(Icons.check_box), label: 'Checklist'),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Laporan'),
        ],
      ),
    );
  }
}

// ==================== JADWAL ====================
class JadwalPage extends StatelessWidget {
  final List<String> tugas = [
    'Menyapu halaman',
    'Mengepel lantai kelas',
    'Buang Sampah',
    'Bersihkan kaca',
    'Merapikan tanaman'
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tugas.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: ListTile(
            leading: Icon(Icons.task),
            title: Text(tugas[index]),
          ),
        );
      },
    );
  }
}

// ==================== CHECKLIST ====================
class ChecklistPage extends StatefulWidget {
  @override
  _ChecklistPageState createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  final Map<String, bool> checklist = {
    'Menyapu halaman': false,
    'Mengepel lantai kelas': false,
    'Buang Sampah': false,
    'Bersihkan kaca': false,
    'Merapikan tanaman': false,
  };

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: checklist.keys.map((task) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: CheckboxListTile(
            title: Text(task),
            value: checklist[task],
            onChanged: (val) {
              setState(() {
                checklist[task] = val!;
              });
            },
          ),
        );
      }).toList(),
    );
  }
}

// ==================== LAPORAN ====================
class LaporanPage extends StatefulWidget {
  @override
  _LaporanPageState createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  final TextEditingController laporanController = TextEditingController();
  List<String> laporanList = [];

  void submitLaporan() {
    if (laporanController.text.isNotEmpty) {
      setState(() {
        laporanList.add(laporanController.text);
        laporanController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: TextField(
            controller: laporanController,
            decoration: InputDecoration(
              labelText: 'Deskripsi Kerusakan',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: submitLaporan,
          child: Text('Kirim Laporan'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        ),
        Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: laporanList.length,
            itemBuilder: (context, index) => Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: ListTile(
                leading: Icon(Icons.warning, color: Colors.red),
                title: Text(laporanList[index]),
              ),
            ),
          ),
        )
      ],
    );
  }
}
