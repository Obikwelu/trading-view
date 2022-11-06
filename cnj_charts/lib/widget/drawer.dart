import 'package:cnj_charts/models/candles.dart';
import 'package:cnj_charts/screens/cardano.dart';
import 'package:cnj_charts/screens/ethereum.dart';
import 'package:cnj_charts/screens/home.dart';
import 'package:cnj_charts/screens/solana.dart';
import 'package:flutter/material.dart';

class CryptoDrawer extends StatelessWidget {
  const CryptoDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 200,
      backgroundColor: Colors.black,
      child: ListView(
        children: [
          ListTile(
            title: const Text(
              "BITCOIN/USD",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            onTap: () {
              wickList = [];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => const Home(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text(
              "SOLANA/USD",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            onTap: () {
              wickList = [];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => const Solana(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text(
              "ETHEREUM/USD",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            onTap: () {
              wickList = [];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => const Ethereum(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text(
              "CARDANO/USD",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            onTap: () {
              wickList = [];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => const Cardano(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
