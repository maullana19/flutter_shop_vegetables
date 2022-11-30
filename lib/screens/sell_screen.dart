import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opem/provider/user_provider.dart';
import 'package:opem/widgets/drawer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart' as proveedor;
import 'package:xid/xid.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({Key? key}) : super(key: key);

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  TextEditingController productName = TextEditingController();
  TextEditingController productDescription = TextEditingController();
  TextEditingController productPrice = TextEditingController();
  TextEditingController productCity = TextEditingController();

  File? fileImage;
  ImagePicker _picker = ImagePicker();

  Future<void> chooseImage() async {
    final file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 440,
        maxHeight: 380,
        imageQuality: 40 //0 - 100
        );
    if (file?.path != null) {
      setState(() {
        fileImage = File(file!.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = proveedor.Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Jual Produk Mu"),
      ),
      drawer: GlobalDrawer(
        PageN: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            fileImage == null
                ? Center(
                    child: SizedBox(
                      width: 300,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          onPressed: () {
                            // print("LOGOBASE: "+logoBase64.toString());
                            chooseImage();
                          },
                          child: Text("Pilih Gambar")),
                    ),
                  )
                : fileImage != null
                    ? Container(
                        width: 200, height: 200, child: Image.file(fileImage!))
                    : Container(),
            SizedBox(
              height: 20,
            ),
            Center(
                child: SizedBox(
              width: 300,
              child: Container(
                  width: 200,
                  child: TextFormField(
                    controller: productName,
                    decoration: InputDecoration(
                        hintText: "Nama Produk",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  )),
            )),
            SizedBox(
              height: 20,
            ),
            Center(
                child: SizedBox(
              width: 300,
              child: Container(
                  width: 200,
                  child: TextFormField(
                    controller: productDescription,
                    decoration: InputDecoration(
                        hintText: "Deskripsi Produk",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  )),
            )),
            SizedBox(
              height: 20,
            ),
            Center(
                child: SizedBox(
              width: 300,
              child: Container(
                  width: 200,
                  child: TextFormField(
                    controller: productPrice,
                    decoration: InputDecoration(
                        hintText: "Harga",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  )),
            )),
            SizedBox(
              height: 20,
            ),
            Center(
                child: SizedBox(
              width: 300,
              child: Container(
                  width: 200,
                  child: TextFormField(
                    controller: productCity,
                    decoration: InputDecoration(
                        hintText: "Asal Kota Produk",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  )),
            )),
            SizedBox(
              height: 25,
            ),
            SizedBox(
              width: 300,
              height: 40,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () async {
                    var xid = Xid();

                    final responseStorage = Supabase.instance.client.storage
                        .from("product-images")
                        .upload(xid.toString(), fileImage!)
                        .then((value) async {
                      print(value.data.toString());

                      // final responseStorach = Supabase.instance.client.storage.from("product-images").getPublicUrl(userProvider.ID!).data.toString()
                      // print(Supabase.instance.client.storage
                      // .from("product-images")
                      // .getPublicUrl(userProvider.ID!)
                      // .data
                      // .toString());
                      final response = await Supabase.instance.client
                          .from("Products")
                          .insert({
                            "Pid": xid.toString(),
                            "title": productName.text,
                            "description": productDescription.text,
                            "price": double.parse(productPrice.text),
                            "owner": userProvider.ID,
                            "city": productCity.text,
                            "image": Supabase.instance.client.storage
                                .from("product-images")
                                .getPublicUrl(xid.toString())
                                .data
                                .toString(),
                          })
                          .execute()
                          .whenComplete(() {
                            Fluttertoast.showToast(msg: "Berhasil");
                            Navigator.pop(context);
                          });
                    });
                  },
                  child: Text("Jual")),
            ),
          ],
        ),
      ),
    );
  }
}
