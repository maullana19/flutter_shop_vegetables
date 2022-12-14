import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opem/stream/stream.dart';
import 'package:opem/widgets/drawer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart' as proveedor;

import '../provider/user_provider.dart';
import 'buy_screen.dart';

class SOrders extends StatefulWidget {
  const SOrders({Key? key}) : super(key: key);

  @override
  State<SOrders> createState() => _SOrdersState();
}

class _SOrdersState extends State<SOrders> {
  List<OrdersStream> lista = [];

  @override
  Widget build(BuildContext context) {
    var userProvider = proveedor.Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Order Penjualan"),
      ),
      drawer: GlobalDrawer(
        PageN: 4,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 0,
              ),
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: Supabase.instance.client
                        .from('Orders')
                        .stream([userProvider.ID!, "seller"])
                        .execute()
                        .handleError((e) => {
                              print('error $e'),
                            }),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Text('Error');
                      } else {
                        lista = [];
                        for (var data in snapshot.data!) {
                          lista.add(OrdersStream.fromJson(data));
                        }
                        return ListView.builder(
                          itemCount: lista.length,
                          itemBuilder: (BuildContext context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: SizedBox(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Center(
                                            child: Text(
                                          "Nama Produk : ${lista[index].name}",
                                          style: GoogleFonts.roboto(
                                              color: Colors.black,
                                              fontSize: 22),
                                        )),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      CachedNetworkImage(
                                        imageUrl: lista[index].image,
                                        errorWidget: (context, url, error) =>
                                            lista[index].image != null
                                                ? Image.network(
                                                    lista[index].image)
                                                : Text(
                                                    "the image cant be load"),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                          child: Text(
                                        "Pembeli ID : ${lista[index].buyer}",
                                        style: GoogleFonts.roboto(
                                            color: Colors.black, fontSize: 12),
                                      )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                          child: Text(
                                        "Total Harga RP ${lista[index].price.toString()}",
                                        style: GoogleFonts.roboto(
                                            color: Colors.black, fontSize: 12),
                                      )),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      lista[index].sended == false
                                          ? ElevatedButton(
                                              onPressed: () async {
                                                final response = await Supabase
                                                    .instance.client
                                                    .from("Orders")
                                                    .update({
                                                      "sended": true,
                                                    })
                                                    .eq("seller",
                                                        lista[index].seller)
                                                    .eq("id", lista[index].id)
                                                    .execute()
                                                    .whenComplete(() {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                                  BuyScreen()));
                                                      Fluttertoast.showToast(
                                                          msg: "SHIPPED");
                                                    });
                                              },
                                              child: Text("Order Shipped"))
                                          : Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Container(
                                                  width: 300,
                                                  height: 30,
                                                  color: Colors.green,
                                                  child: Center(
                                                    child: Text(
                                                      "Orderan Dikirm",
                                                      style: TextStyle(
                                                        color: Colors.white70,
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                              // child: ListTile(
                              //   leading: CircleAvatar(
                              //     child: Text(
                              //       lista[index].title
                              //     ),
                              //   ),
                              //   title: Text(
                              //     lista[index].description,
                              //   ),
                              //   trailing: Image.network(
                              //     lista[index].price.toString(),
                              //   ),
                              // ),
                            );
                          },
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
      // body: FutureBuilder<PostgrestResponse<dynamic>>(future: Supabase.instance.client.from("TEST").select().execute()
      //     ,builder: (context,AsyncSnapshot snapshot){
      //   if(!snapshot.hasData){
      //     return Text("NO DATA");
      //   }
      //   return ListView.builder(
      //       itemCount: snapshot.data.length==null?0:snapshot.data.length,
      //       itemBuilder: (context,index){
      //         return Container(
      //           child: Column(children: [
      //             Text(snapshot.data[index]["id"]),
      //             Text(snapshot.data[index]["title"]),
      //             Text(snapshot.data[index]["description"]),
      //             Text(snapshot.data[index]["owner"]),
      //             Text(snapshot.data[index]["city"]),
      //             Text(snapshot.data[index]["price"].toString()),
      //           ],),
      //         );
      //   });
      // }),
    );
  }
}
