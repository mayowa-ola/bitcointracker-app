import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class CoinAPI {
  Future getCoinData(coin, currency) async {
    var url =
        'https://rest.coinapi.io/v1/exchangerate/$coin/$currency?apikey=5C679346-FE84-4397-BDCA-5F46930990A3';

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      return jsonResponse;
    } else {
      print(response.statusCode);
    }
  }
}
