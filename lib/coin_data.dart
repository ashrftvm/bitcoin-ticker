import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const bitcoinAverageURL =
    'https://apiv2.bitcoinaverage.com/indices/global/ticker';

class CoinData {
  Future<dynamic> getCoinData(userCurrency) async {
    var currencyValues;
    var btc = await http.get('$bitcoinAverageURL/BTC$userCurrency');
    var ltc = await http.get('$bitcoinAverageURL/LTC$userCurrency');
    var eth = await http.get('$bitcoinAverageURL/ETH$userCurrency');

    if (btc.statusCode == 200 &&
        ltc.statusCode == 200 &&
        eth.statusCode == 200) {
      var newbtc = jsonDecode(btc.body);
      var neweth = jsonDecode(eth.body);
      var newltc = jsonDecode(ltc.body);
      currencyValues = {
        'btc': newbtc['last'],
        'eth': neweth['last'],
        'ltc': newltc['last'],
      };
      currencyValues = json.encode(currencyValues);
      return currencyValues;
    } else {
      return null;
    }
  }
}
