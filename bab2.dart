enum Peran { Developer, NetworkEngineer, Manager }
enum KategoriProduk { DataManagement, NetworkAutomation }
enum FaseProyek { Perencanaan, Pengembangan, Evaluasi }

// Model Produk Digital
class ProdukDigital {
  String namaProduk;
  double harga;
  KategoriProduk kategori;

  ProdukDigital({required this.namaProduk, required this.harga, required this.kategori}) {
    if (kategori == KategoriProduk.NetworkAutomation && harga < 200000) {
      throw Exception("Harga produk NetworkAutomation harus minimal 200.000");
    } else if (kategori == KategoriProduk.DataManagement && harga >= 200000) {
      throw Exception("Harga produk DataManagement harus di bawah 200.000");
    }
  }

  void terapkanDiskon(int jumlahPenjualan) {
    if (kategori == KategoriProduk.NetworkAutomation && jumlahPenjualan > 50) {
      double hargaDiskon = harga * 0.85;
      harga = (hargaDiskon < 200000) ? 200000 : hargaDiskon;
      print("Diskon diterapkan! Harga baru untuk ${namaProduk}: Rp$harga");
    }
  }
}

// Karyawan dan Subklas untuk Karyawan Tetap dan Kontrak
abstract class Karyawan {
  String nama;
  int umur;
  Peran peran;
  
  Karyawan(this.nama, {required this.umur, required this.peran});
  
  void bekerja();
}

class KaryawanTetap extends Karyawan {
  KaryawanTetap(String nama, {required int umur, required Peran peran}) : super(nama, umur: umur, peran: peran);
  
  @override
  void bekerja() {
    print("$nama yang merupakan karyawan tetap sedang bekerja sebagai $peran.");
  }
}

class KaryawanKontrak extends Karyawan {
  KaryawanKontrak(String nama, {required int umur, required Peran peran}) : super(nama, umur: umur, peran: peran);
  
  @override
  void bekerja() {
    print("$nama yang merupakan karyawan kontrak sedang bekerja sebagai $peran.");
  }
}

// Mixin untuk Evaluasi Kinerja
mixin Kinerja on Karyawan {
  int produktivitas = 50;  // Default produktivitas awal

  void evaluasiBulanan() {
    if (peran == Peran.Manager && produktivitas < 85) {
      print("Peringatan: Produktivitas manager harus di atas 85.");
    }
    produktivitas = (produktivitas < 100) ? produktivitas + 5 : 100; // Maksimal produktivitas 100
  }
}

// Kelas Perusahaan
class Perusahaan {
  List<Karyawan> karyawanAktif = [];
  List<Karyawan> karyawanNonAktif = [];
  static const int maxKaryawan = 20;

  void tambahKaryawan(Karyawan karyawan) {
    if (karyawanAktif.length >= maxKaryawan) {
      print("Batas maksimum karyawan aktif telah tercapai.");
    } else {
      karyawanAktif.add(karyawan);
      print("Karyawan ${karyawan.nama} ditambahkan sebagai ${karyawan.peran}");
    }
  }

  void karyawanResign(Karyawan karyawan) {
    if (karyawanAktif.remove(karyawan)) {
      karyawanNonAktif.add(karyawan);
      print("Karyawan ${karyawan.nama} telah resign dan dipindahkan ke daftar non-aktif.");
    } else {
      print("Karyawan ${karyawan.nama} tidak ditemukan di daftar aktif.");
    }
  }
}

// Kelas Proyek
class Proyek {
  FaseProyek fase = FaseProyek.Perencanaan;
  int hariBerjalan = 0;
  List<Karyawan> timProyek = [];

  void tambahKaryawan(Karyawan karyawan) {
    timProyek.add(karyawan);
  }

  void transisiFase() {
    if (fase == FaseProyek.Perencanaan && timProyek.length >= 5) {
      fase = FaseProyek.Pengembangan;
      print("Fase proyek berpindah ke Pengembangan.");
    } else if (fase == FaseProyek.Pengembangan && hariBerjalan > 45) {
      fase = FaseProyek.Evaluasi;
      print("Fase proyek berpindah ke Evaluasi.");
    } else {
      print("Transisi fase tidak memenuhi persyaratan.");
    }
  }
}

// Fungsi Utama
void main() {
  // Membuat produk digital
  ProdukDigital produk1 = ProdukDigital(namaProduk: "Data Analysis", harga: 150000, kategori: KategoriProduk.DataManagement);
  ProdukDigital produk2 = ProdukDigital(namaProduk: "Network Tool", harga: 250000, kategori: KategoriProduk.NetworkAutomation);

  // Menerapkan diskon pada produk kedua jika memenuhi syarat
  produk2.terapkanDiskon(60);

  // Membuat karyawan tetap dan kontrak
  KaryawanTetap karyawanTetap = KaryawanTetap("Alice", umur: 30, peran: Peran.Manager);
  KaryawanKontrak karyawanKontrak = KaryawanKontrak("Bob", umur: 25, peran: Peran.Developer);

  // Menambahkan karyawan ke perusahaan
  Perusahaan perusahaan = Perusahaan();
  perusahaan.tambahKaryawan(karyawanTetap);
  perusahaan.tambahKaryawan(karyawanKontrak);

  // Karyawan melakukan resign
  perusahaan.karyawanResign(karyawanTetap);

  // Membuat proyek dan mengelola fase
  Proyek proyek = Proyek();
  proyek.tambahKaryawan(karyawanKontrak);
  proyek.hariBerjalan = 50; // Hari berjalan lebih dari 45 hari
  proyek.transisiFase();  // Cek transisi fase

  // Menampilkan daftar produk
  print("\nDaftar Produk Perusahaan:");
  print("- ${produk1.namaProduk} | Harga: Rp${produk1.harga} | Kategori: ${produk1.kategori}");
  print("- ${produk2.namaProduk} | Harga: Rp${produk2.harga} | Kategori: ${produk2.kategori}");
}