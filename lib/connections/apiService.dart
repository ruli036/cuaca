import 'package:get/get.dart';

class ApiService extends GetConnect{
  final String baseUrl = 'https://data.bmkg.go.id/DataMKG/MEWS/DigitalForecast/';

  // Setup timeout dan header default jika perlu
  ApiService() {
    httpClient.baseUrl = baseUrl;
    httpClient.timeout = const Duration(seconds: 10);
    httpClient.defaultContentType = 'application/json';
  }
  // Contoh method GET untuk mengambil data
  Future<Response<dynamic>> getData(String endpoint) async {
    try {
      final response = await get(endpoint);

      if (response.status.hasError) {
        // Tangani error dari server atau koneksi
        handleError(response.statusCode, "Error");
        // Mengembalikan response kosong atau dengan error jika diperlukan
        return Response(statusCode: response.statusCode, statusText: response.statusText);
      } else {
        // Proses data jika respons berhasil
        print('Success: ${response.body}');
        return response;
      }
    } catch (e) {
      // Tangani timeout atau kesalahan jaringan
      handleError(null, e.toString());
      // Mengembalikan response kosong atau dengan error jika diperlukan
      return Response(statusCode: null, statusText: e.toString());
    }
  }

  // Contoh method POST
  Future<Response> postData(String endpoint, Map<String, dynamic> body) async {
    final response = await post(endpoint, body);
    return response;
  }

  void handleError(int? statusCode, String errorMessage) {
    if (statusCode == null) {
      // Kesalahan jaringan atau timeout
      print('Network error or timeout: $errorMessage');
      // Tampilkan pesan kesalahan kepada pengguna atau log
    } else {
      // Kesalahan dari server, misalnya 404, 500, dll.
      print('Error $statusCode: $errorMessage');
      // Tampilkan pesan kesalahan kepada pengguna atau log
    }
  }

}