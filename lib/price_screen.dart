import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:convert';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  String btcValue;
  String etcValue;
  String ltcValue;
  dynamic returnedValue;
  bool isLoading = true;

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          isLoading = true;
          getData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
        isLoading = true;
        getData();
      },
      children: pickerItems,
    );
  }

  void getData() async {
    returnedValue = await CoinData().getCoinData(selectedCurrency);
    if (returnedValue != null) {
      var decodedValue = jsonDecode(returnedValue);
      btcValue = decodedValue['btc'].toString();
      etcValue = decodedValue['eth'].toString();
      ltcValue = decodedValue['ltc'].toString();
      isLoading = false;
    } else {
      print('in null');
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CoinCard(
                  coinName: 'BTC',
                  coinValue: isLoading ? '?' : btcValue,
                  selectedCurrency: selectedCurrency),
              CoinCard(
                  coinName: 'ETH',
                  coinValue: isLoading ? '?' : etcValue,
                  selectedCurrency: selectedCurrency),
              CoinCard(
                  coinName: 'LTC',
                  coinValue: isLoading ? '?' : ltcValue,
                  selectedCurrency: selectedCurrency),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CoinCard extends StatelessWidget {
  const CoinCard({
    Key key,
    @required this.coinValue,
    @required this.coinName,
    @required this.selectedCurrency,
  }) : super(key: key);

  final String coinName;
  final String coinValue;
  final String selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $coinName = $coinValue $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
