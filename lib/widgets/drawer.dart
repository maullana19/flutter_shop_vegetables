import 'package:curved_drawer_fork/curved_drawer_fork.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:opem/screens/BOrders_screen.dart';
import 'package:opem/screens/SOrders_screen.dart';
import 'package:opem/screens/buy_screen.dart';
import 'package:opem/screens/login_screen.dart';
import 'package:opem/screens/myProducts_screen.dart';
import 'package:opem/screens/sell_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GlobalDrawer extends StatelessWidget {
  final PageN;
  const GlobalDrawer({Key? key, required this.PageN}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CurvedDrawer(
      index: PageN,
      buttonBackgroundColor: Color.fromARGB(255, 54, 53, 53),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      color: Colors.green,
      labelColor: Color.fromARGB(255, 255, 255, 255),
      items: <DrawerItem>[
        DrawerItem(icon: Icon(FontAwesome.cart_shopping), label: "Produk"),
        //Optional Label Text
        DrawerItem(
            icon: Icon(FontAwesome.circle_dollar_to_slot), label: "Jual"),
        DrawerItem(icon: Icon(FontAwesome.list_check), label: "My Products"),
        DrawerItem(icon: Icon(FontAwesome.handshake), label: "Keranjang"),
        DrawerItem(icon: Icon(Icons.local_shipping), label: "My Sell Orders"),
        DrawerItem(icon: Icon(Icons.logout), label: "Logout"),
      ],
      onTap: (index) {
        if (index == 0) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => BuyScreen()));
          });
        }
        if (index == 1) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => SellScreen()));
          });
        }
        if (index == 2) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => MyProductsScreen()));
          });
        }
        if (index == 3) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => BOrders()));
          });
        }
        if (index == 4) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => SOrders()));
          });
        }
        if (index == 4) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => SOrders()));
          });
        }
        if (index == 5) {
          Future.delayed(Duration(seconds: 1), () {
            Supabase.instance.client.auth.signOut();
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => LoginScreen()));
          });
        }
      },
    );
  }
}
