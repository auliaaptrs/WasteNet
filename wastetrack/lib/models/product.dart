class Product {
  String jenis;
  String nama;
  int harga;
  double jumlah;
  String satuan;

  Product({
    required this.jenis,
    required this.nama,
    required this.harga,
    required this.jumlah,
    required this.satuan,
  });

  int get total => (harga * jumlah).round();
}
