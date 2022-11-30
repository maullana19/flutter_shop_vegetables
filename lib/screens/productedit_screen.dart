import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xid/xid.dart';

class ProductEditScreen extends StatefulWidget {
  final title;
  final description;
  final price;
  final id;
  final image;
  final Pid;
  const ProductEditScreen(
      {Key? key,
      required this.Pid,
      required this.title,
      required this.description,
      required this.price,
      required this.id,
      required this.image})
      : super(key: key);

  @override
  State<ProductEditScreen> createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  TextEditingController productTitleET = TextEditingController();
  TextEditingController productDescET = TextEditingController();
  TextEditingController productPriceET = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Edit/Delete Produck"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Image.network(widget.image),
              SizedBox(
                height: 10,
              ),
              Center(
                  child: Container(
                      child: TextFormField(
                controller: productTitleET,
                decoration: InputDecoration(hintText: widget.title),
              ))),
              SizedBox(
                height: 10,
              ),
              Center(
                  child: Container(
                      child: TextFormField(
                controller: productDescET,
                decoration: InputDecoration(hintText: widget.description),
              ))),
              SizedBox(
                height: 10,
              ),
              Center(
                  child: Container(
                      child: TextFormField(
                controller: productPriceET,
                decoration: InputDecoration(hintText: widget.price.toString()),
              ))),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 220,
                    height: 40,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () async {
                          if (productTitleET.text != null &&
                              productTitleET.text != "" &&
                              productDescET.text != null &&
                              productDescET.text != "" &&
                              productPriceET.text != null &&
                              productPriceET.text != "") {
                            final response = await Supabase.instance.client
                                .from("Products")
                                .update({
                                  if (productTitleET.text != null &&
                                      productTitleET.text != "")
                                    "title": productTitleET.text,
                                  if (productDescET.text != null &&
                                      productDescET.text != "")
                                    "description": productDescET.text,
                                  if (productPriceET.text != null &&
                                      productPriceET.text != "")
                                    "price": double.parse(productPriceET.text),
                                })
                                .eq("id", widget.id)
                                .execute()
                                .whenComplete(() {
                                  Navigator.pop(context);
                                  Fluttertoast.showToast(msg: "UPDATED");
                                });
                          } else {
                            Fluttertoast.showToast(
                                msg: "Must complete at least 1 field");
                          }
                        },
                        child: Text("Update")),
                  ),
                  SizedBox(
                    height: 25,
                    width: 40,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade400),
                      onPressed: () async {
                        timetochoose(context);
                      },
                      child: Text("Hapus")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  timetochoose(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget continueButton = TextButton(
      child: Text("Delete"),
      onPressed: () async {
        final response = await Supabase.instance.client
            .from("Products")
            .delete()
            .eq("id", widget.id)
            .execute()
            .whenComplete(() async {
          final responseImage = await Supabase.instance.client.storage
              .from("product-images")
              .remove([widget.Pid]).whenComplete(() {
            Fluttertoast.showToast(msg: "DELETED");
            Navigator.of(context, rootNavigator: true).pop('dialog');
            Navigator.pop(context);
          });
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Remove post"),
      content: Text("Are you sure?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
