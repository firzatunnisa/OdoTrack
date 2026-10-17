/// Kumpulan fungsi format tampilan yang dipakai bersama oleh semua modul.
///
/// Sebelumnya fungsi-fungsi ini ditulis ulang di masing-masing halaman
/// (_formatDate, _formatDateDisplay, _formatNumber, _formatThousand,
/// _formatCurrency, _formatKm). Sekarang cukup satu sumber di sini.
class Formatters {
  Formatters._(); // tidak perlu dibuat objeknya, cukup panggil Formatters.xxx()

  static const List<String> _bulanSingkat = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];

  static final RegExp _pemisahRibuan = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');

  /// 12450 -> "12.450"
  static String number(int value) {
    return value.toString().replaceAllMapped(
      _pemisahRibuan,
      (Match m) => '${m[1]}.',
    );
  }

  /// 150000 -> "Rp150.000"
  static String rupiah(int amount) => 'Rp${number(amount)}';

  /// DateTime(2026, 11, 12) -> "12 Nov 2026"
  static String date(DateTime value) {
    return '${value.day} ${_bulanSingkat[value.month - 1]} ${value.year}';
  }
}
