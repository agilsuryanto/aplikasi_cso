import 'package:flutter/material.dart';


void main() => runApp(CSOApp());

class CSOApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CSO & Kebersihan',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        scaffoldBackgroundColor: Color(0xFFFFFCFC),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}

Map<String, String> akunTerdaftar = {
  'admin': '1234',
  'cso': '1234',
};

// ==================== LOGIN PAGE ====================
class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login(BuildContext context) {
    final username = usernameController.text;
    final password = passwordController.text;

    if (akunTerdaftar.containsKey(username) &&
        akunTerdaftar[username] == password) {
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

  void _goToRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png', height: 120),
                SizedBox(height: 20),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _login(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: Size(double.infinity, 48),
                  ),
                  child: Text('Login'),
                ),
                TextButton(
                  onPressed: () => _goToRegister(context),
                  child: Text('Belum punya akun? Daftar di sini'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// ==================== ADMIN PAGE ====================
class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<String> semuaLaporan = [
    'Kipas angin rusak di kelas 7A',
    'Kaca pecah di lantai 2',
    'Sampah menumpuk di taman belakang'
  ];

  Map<String, bool> laporanStatus = {};

  @override
  void initState() {
    super.initState();
    for (var laporan in semuaLaporan) {
      laporanStatus[laporan] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text('Daftar Laporan Kerusakan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          ...semuaLaporan.map((laporan) => Card(
            child: CheckboxListTile(
              title: Text(laporan),
              subtitle: Text('Status: ' +
                  (laporanStatus[laporan]! ? 'Selesai' : 'Belum Ditindaklanjuti')),
              value: laporanStatus[laporan],
              onChanged: (val) {
                setState(() {
                  laporanStatus[laporan] = val!;
                });
              },
            ),
          )),
        ],
      ),
    );
  }
}

// ==================== REGISTER PAGE ====================
class RegisterPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _register(BuildContext context) {
    final username = usernameController.text;
    final password = passwordController.text;

    if (akunTerdaftar.containsKey(username)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username sudah terdaftar')),
      );
    } else if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username dan Password tidak boleh kosong')),
      );
    } else {
      akunTerdaftar[username] = password;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registrasi berhasil! Silakan login.')),
      );
      Navigator.pop(context); // Kembali ke halaman login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrasi')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username Baru',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _register(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text('Daftar'),
            ),
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Apakah Anda yakin ingin logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => LoginPage()),
                    (route) => false,
              );
            },
            child: Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }


  final List<Widget> _pages = [JadwalPage(), ChecklistPage(), LaporanPage()];
  final List<String> _titles = [
    'Jadwal Harian',
    'Checklist Tugas',
    'Laporan Kerusakan'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 30),
            SizedBox(width: 10),
            Text(
              _titles[_currentIndex],
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context);
            },
          )
        ],
      ),
      body: _pages[_currentIndex],
      floatingActionButton: _currentIndex == 2
          ? FloatingActionButton(
        onPressed: () {},
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
          BottomNavigationBarItem(
              icon: Icon(Icons.check_box), label: 'Checklist'),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Laporan'),
        ],
      ),
    );
  }
}

// ==================== JADWAL ====================
class JadwalPage extends StatelessWidget {
  final Map<String, List<String>> jadwal = {
    'Area Kelas': [
      'Menyapu lantai',
      'Mengepel lantai',
      'Membersihkan dan Mengeelap Meja + Kursi',
      'Membersikan Langit langit',
      'Mengelap Kaca dan Dinding'
    ],
    'Gedung Bagian Dalam': [
      'Membersihkan Tralis, Dinding dan Lantai',
      'Menyapu lantai',
      'Mengepel lantai'
    ],
    'Gedung Bagian Luar': [
      'Membersihkan kaca jendela',
      'Membersihkan atap',
      'Menyiram tanaman'
    ],
  };

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: jadwal.entries.map((entry) {
        return Card(
          margin: EdgeInsets.all(12),
          child: ExpansionTile(
            title: Text(entry.key,
                style: TextStyle(fontWeight: FontWeight.bold)),
            children:
            entry.value.map((task) => ListTile(title: Text(task))).toList(),
          ),
        );
      }).toList(),
    );
  }
}

// ==================== CHECKLIST ====================
class ChecklistPage extends StatefulWidget {
  @override
  _ChecklistPageState createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  final Map<String, Map<String, bool>> checklist = {
    'Area Kelas': {
      'Menyapu lantai': false,
      'Mengepel lantai': false,
      'Membersihkan meja dan kursi': false,
    },
    'Gedung Bagian Dalam': {
      'Membersihkan tralis, dinding dan lantai': false,
      'Menyapu lantai': false,
      'Mengepel lantai': false,
    },
    'Gedung Bagian Luar': {
      'Membersihkan kaca jendela': false,
      'Membersihkan atap': false,
      'Menyiram tanaman': false,
    },
  };

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: checklist.entries.map((entry) {
        return Card(
          margin: EdgeInsets.all(12),
          child: ExpansionTile(
            title: Text(entry.key,
                style: TextStyle(fontWeight: FontWeight.bold)),
            children: entry.value.keys.map((task) {
              return CheckboxListTile(
                title: Text(task),
                value: entry.value[task],
                onChanged: (val) {
                  setState(() {
                    entry.value[task] = val!;
                  });
                },
              );
            }).toList(),
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
              fillColor: Colors.white,
              filled: true,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: submitLaporan,
          child: Text('Kirim Laporan'),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: Size(double.infinity, 48)),
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
