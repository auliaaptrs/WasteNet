class BankSampahProfile {
  final String bankId;
  final String namaBank;
  final String namaPJ;
  final String telepon;
  final String alamat;
  final String kelurahan;
  final String kecamatan;
  final String kota;
  final String provinsi;
  final int kapasitas;

  BankSampahProfile({
    required this.bankId,
    required this.namaBank,
    required this.namaPJ,
    required this.telepon,
    required this.alamat,
    required this.kelurahan,
    required this.kecamatan,
    required this.kota,
    required this.provinsi,
    required this.kapasitas,
  });

  factory BankSampahProfile.fromJson(Map<String, dynamic> json) {
    return BankSampahProfile(
      bankId: json['bank_id'] as String,
      namaBank: json['nama_bank'] as String,
      namaPJ: json['nama_pj'] as String,
      telepon: json['telepon'] as String,
      alamat: json['alamat'] as String,
      kelurahan: json['kelurahan'] as String,
      kecamatan: json['kecamatan'] as String,
      kota: json['kota'] as String,
      provinsi: json['provinsi'] as String,
      kapasitas: json['kapasitas'] as int,
    );
  }

  // Tambahkan method copyWith di bawah ini:
  BankSampahProfile copyWith({
    String? bankId,
    String? namaBank,
    String? namaPJ,
    String? telepon,
    String? alamat,
    String? kelurahan,
    String? kecamatan,
    String? kota,
    String? provinsi,
    int? kapasitas,
  }) {
    return BankSampahProfile(
      bankId: bankId ?? this.bankId,
      namaBank: namaBank ?? this.namaBank,
      namaPJ: namaPJ ?? this.namaPJ,
      telepon: telepon ?? this.telepon,
      alamat: alamat ?? this.alamat,
      kelurahan: kelurahan ?? this.kelurahan,
      kecamatan: kecamatan ?? this.kecamatan,
      kota: kota ?? this.kota,
      provinsi: provinsi ?? this.provinsi,
      kapasitas: kapasitas ?? this.kapasitas,
    );
  }
}
