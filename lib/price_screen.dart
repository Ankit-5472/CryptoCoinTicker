import 'package:bitcoin_ticker/services/networking.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;
import 'services/crypto_card.dart';


class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}
class _PriceScreenState extends State<PriceScreen> {
  String apiKey = '443D752C-71DC-416C-BCDD-45DC38087CB4';
  String apiUrl = 'https://rest.coinapi.io/v1/exchangerate';
  //String selectedCurrency = 'INR';
  int bitCoinRate = 0;
  int ethCoinRate = 0;
  int lateCoinRate = 0;
  String currencySelectByUser = 'INR';

   DropdownButton<String> androidPicker(){
     List<DropdownMenuItem<String>> dropDownItems = [];
     for(String currency in currenciesList){
       var newItem =DropdownMenuItem(
         child: Text(currency),
         value: currency,
       );
       dropDownItems.add(newItem);
     }
     return DropdownButton<String>(
         value: currencySelectByUser,
         items: dropDownItems,
         onChanged: (value){
           setState(() {
             currencySelectByUser = value!;
             getCoinValue();
           });
         });
   }
   CupertinoPicker iosPicker(){
     List<Text> pickerItems = [];
     for(String currency in currenciesList){
       pickerItems.add(Text(currency));
     }
     return CupertinoPicker(
       backgroundColor: Colors.lightBlue,
       itemExtent: 32.0,
       onSelectedItemChanged: (value){
         setState(() {
           currencySelectByUser = currenciesList[value];
           getCoinValue();
         });;
       },
       children:
       pickerItems,
     );
   }

  void getCoinValue() async{
    String url = '$apiUrl/BTC/$currencySelectByUser?apikey=$apiKey';
    NetworkHelper networkHelper = NetworkHelper(url);
    var currencyData = await networkHelper.getCoinValue();
    double rate = currencyData['rate'];
    setState(() {
      if(rate==null){
        bitCoinRate = 0;
        return;
      }
      bitCoinRate = rate.toInt();
    });
  }

  @override
  void initState() {
    super.initState();
    getCoinValue();
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
            cryptoCard(value: bitCoinRate, selectedCurrency: currencySelectByUser, cryptoCurrency: 'BTC'),
            cryptoCard(value: ethCoinRate, selectedCurrency: currencySelectByUser, cryptoCurrency: 'ETH'),
            cryptoCard(value: lateCoinRate, selectedCurrency: currencySelectByUser, cryptoCurrency: 'LTC'),
          ],
        ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidPicker(),
          ),
      ],
      ),
    );
  }
}

