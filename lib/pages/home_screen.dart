import 'dart:convert';

import 'package:coincap/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? _deviceHeight, _devicewidth;

  HTTPService? _http;

  @override
  void initState() {
    super.initState();
    _http = GetIt.instance.get<HTTPService>();
  }

  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _devicewidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _selectedCoinDropdown(),
            _datawidget(),
          ],
        ),
      )),
    );
  }

  Widget _selectedCoinDropdown() {
    List<String> _coins = ["bitcoin"];
    List<DropdownMenuItem> _items = _coins
        .map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w600),
            ),
          ),
        )
        .toList();
    return DropdownButton(
      value: _coins.first,
      items: _items,
      onChanged: (_value) {},
      dropdownColor: Color.fromRGBO(83, 88, 206, 1.0),
      iconSize: 30,
      icon: const Icon(
        Icons.arrow_drop_down_sharp,
        color: Colors.white,
      ),
      underline: Container(), //to remove the underline of the drop down button
    );
  }

  // Here is the use of Circular Progress Indicator which can be used for future works
  Widget _datawidget() {
    return FutureBuilder(
      future: _http!.get("/coins/bitcoin"),
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
          Map _data = jsonDecode(
            _snapshot.data.toString(),
          );
          num _usdPrice = _data["market_data"]["current_price"]["usd"];
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _currentPriceWidget(_usdPrice),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      },
    );
  }

  Widget _currentPriceWidget(num _rate) {
    return Text(
      "${_rate.toStringAsFixed(2)} USD",
      style: TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}
