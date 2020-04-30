import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;
import 'coin_api.dart';

int BTCValue = 0;
int ETHValue = 0;
int LTCValue = 0;

String selectedCurrency = 'USD';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  @override
  void initState() {
    super.initState();
    getCoinData(selectedCurrency);
  }

  double valueOfCoin = 0.0;

  void getCoinData(selectedCurrency) async {
    var BTCData = await CoinAPI().getCoinData('BTC', selectedCurrency);
    var ETHData = await CoinAPI().getCoinData('ETH', selectedCurrency);
    var LTCData = await CoinAPI().getCoinData('LTC', selectedCurrency);

    double BTCRate = BTCData['rate'];
    double ETHRate = ETHData['rate'];
    double LTCRate = LTCData['rate'];

    setState(() {
      BTCValue = BTCRate.toInt();
      ETHValue = ETHRate.toInt();
      LTCValue = LTCRate.toInt();
    });
  }

  DropdownButton<String> getDropdownButton() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currencyValue in currenciesList) {
      var newDropdown = DropdownMenuItem(
        child: Text(currencyValue),
        value: currencyValue,
      );
      dropdownItems.add(newDropdown);
    }
    return DropdownButton<String>(
        value: selectedCurrency,
        items: dropdownItems,
        onChanged: (value) {
          getCoinData(value);
          setState(() {
            selectedCurrency = value;
          });
        });
  }

  getCuppertinoItems() {
    List<Text> pickerItems = [];
    for (String currencyValue in currenciesList) {
      var newPicker = Text(currencyValue);
      pickerItems.add(newPicker);
    }
    return CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        itemExtent: 32.0,
        onSelectedItemChanged: (selectedIndex) {
          print(selectedIndex);
        },
        children: pickerItems);
  }

  getPicker() {
    if (Platform.isIOS) {
      return getCuppertinoItems();
    } else if (Platform.isAndroid) {
      return getDropdownButton();
    }
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
            children: [
              CurrencyWidget('BTC', BTCValue),
              CurrencyWidget('ETH', ETHValue),
              CurrencyWidget('LTC', LTCValue),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker(),
          )
        ],
      ),
    );
  }
}

class CurrencyWidget extends StatelessWidget {
  final String coinType;
  final int coinValue;
  CurrencyWidget(this.coinType, this.coinValue);

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
            '1 $coinType = $coinValue $selectedCurrency',
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
