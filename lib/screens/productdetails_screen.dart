import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:opem/provider/user_provider.dart';
import 'package:provider/provider.dart' as proveedor;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xid/xid.dart';
import 'package:http/http.dart' as http;

class ProductDetailsScreen extends StatefulWidget {
  final title;
  final price;
  final description;
  final owner;
  final image;
  final city;
  const ProductDetailsScreen(
      {Key? key,
      required this.city,
      required this.title,
      required this.price,
      required this.description,
      required this.owner,
      required this.image})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  File? fileWaiting;
  String? imageId;
  bool _absorbing = false;
  var pathing;

  @override
  Widget build(BuildContext context) {
    var userProvider = proveedor.Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Keterangan Produk"),
      ),
      body: AbsorbPointer(
        absorbing: _absorbing,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Center(
                      child: Container(
                          child: CachedNetworkImage(
                    imageUrl: widget.image,
                  ))),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      widget.title,
                      style: TextStyle(color: Colors.black, fontSize: 25),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      "Asal Kota  : " + widget.city,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        widget.description,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Harga : Rp " + widget.price.toString(),
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: SizedBox(
                      height: 50,
                      width: 330,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () async {
                          EasyLoading.show(status: "Loadings");
                          setState(() {
                            _absorbing = true;
                          });
                          var xid = Xid();

                          final response = await Supabase.instance.client
                              .from("Orders")
                              .insert({
                                "Oid": xid.toString(),
                                "name": widget.title,
                                "price": double.parse(widget.price.toString()),
                                "buyer": userProvider.ID,
                                "seller": widget.owner,
                                "image": widget.image,
                                "sended": false,
                              })
                              .execute()
                              .whenComplete(() {
                                Navigator.pop(context);
                                EasyLoading.showSuccess("Sukses");
                                setState(() {
                                  _absorbing = false;
                                });
                              });
                        },
                        child: Text(
                          "Beli",
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
