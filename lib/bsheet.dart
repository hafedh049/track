// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:em/globals.dart';
import 'package:em/operation_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class BSheet extends StatefulWidget {
  const BSheet({super.key});

  @override
  State<BSheet> createState() => _BSheetState();
}

class _BSheetState extends State<BSheet> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _fromWhereController = TextEditingController();
  final GlobalKey _operationPhotoKey = GlobalKey();
  @override
  void dispose() {
    _amountController.dispose();
    _fromWhereController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _pickTypes = <Map<String, dynamic>>[
      <String, dynamic>{"type": "Camera", "icon": FontAwesomeIcons.camera, "func": getPictureFromCamera},
      <String, dynamic>{"type": "Gallery", "icon": FontAwesomeIcons.photoFilm, "func": getPictureFromGallery},
    ];
    super.initState();
  }

  String _nature = "+";
  final List<String> _natures = <String>["+", "-"];
  String _currency = "TND";
  String _currencyAbb = "TND";
  final List<Map<String, String>> _currencies = const <Map<String, String>>[
    <String, String>{"currency": "TND", "icon": "tnd.png", "abbriviation": "TND"},
    <String, String>{"currency": "Euro", "icon": "euro.png", "abbriviation": "€"},
    <String, String>{"currency": "Dollar", "icon": "dollar.png", "abbriviation": "\$"},
    <String, String>{"currency": "Pound", "icon": "pound.png", "abbriviation": "£"},
  ];
  late final List<Map<String, dynamic>> _pickTypes;

  File? _operationPicture;

  List<Map<String, dynamic>> actions(BuildContext context) {
    return <Map<String, dynamic>>[
      <String, dynamic>{"type": "CANCEL", "color": blue, "func": () => Navigator.pop(context)},
      <String, dynamic>{"type": "ADD OPERATION", "color": white.withOpacity(.4), "func": addOperation},
    ];
  }

  void clearOperationPicture() {
    _operationPhotoKey.currentState!.setState(() => _operationPicture = null);
  }

  Future<void> getPictureFromGallery() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      image = await FlutterImageCompress.compressAndGetFile(image.path, const Uuid().v8(), format: CompressFormat.png);
      if (image != null) {
        _operationPhotoKey.currentState!.setState(() => _operationPicture = File(image!.path));
      }
    }
  }

  Future<void> getPictureFromCamera() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      image = await FlutterImageCompress.compressAndGetFile(image.path, const Uuid().v8(), format: CompressFormat.png);
      if (image != null) {
        _operationPhotoKey.currentState!.setState(() => _operationPicture = File(image!.path));
      }
    }
  }

  Future<void> addOperation() async {
    if (!_amountController.text.contains(RegExp(r"(\d+|\d+\.\d+)"))) {
      Fluttertoast.showToast(msg: "Verify the amount field", backgroundColor: pigmentGreen);
    } else if (_fromWhereController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Check the title field, it is mandatory", backgroundColor: pigmentGreen);
    } else {
      try {
        database!.addOperation(OperationModel(operationDate: DateTime.now(), title: _fromWhereController.text.trim(), amount: _amountController.text.trim(), currency: _currencyAbb, nature: _nature, picture: _operationPicture == null ? (await rootBundle.load("assets/icon.png")).buffer.asUint8List() : _operationPicture!.readAsBytesSync()));
        Navigator.pop(context);
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString(), backgroundColor: pigmentGreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Currency", style: TextStyle(fontSize: 18)),
                      SizedBox(width: 10),
                      Text("*", style: TextStyle(fontSize: 18, color: red)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          for (final Map<String, String> currency_ in _currencies)
                            InkWell(
                              splashColor: transparent,
                              radius: 40,
                              onTap: () => _(() {
                                _currency = currency_["currency"]!;
                                _currencyAbb = currency_["abbriviation"]!;
                              }),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  AnimatedContainer(
                                    duration: 500.ms,
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: currency_["currency"] == _currency ? emerald : pigmentGreen.withOpacity(.3)),
                                    child: Center(child: Image.asset("assets/${currency_['icon']}", width: 30, height: 30)),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(currency_["currency"]!, style: TextStyle(fontSize: 14, color: currency_["currency"] == _currency ? white : white.withOpacity(.5))),
                                ],
                              ),
                            )
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Nature", style: TextStyle(fontSize: 18)),
                      SizedBox(width: 10),
                      Text("*", style: TextStyle(fontSize: 18, color: red)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          for (final String nature_ in _natures)
                            InkWell(
                              splashColor: transparent,
                              radius: 40,
                              onTap: () => _(() => _nature = nature_),
                              child: AnimatedContainer(
                                duration: 500.ms,
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(shape: BoxShape.circle, color: nature_ == _nature ? emerald : pigmentGreen.withOpacity(.3)),
                                child: Center(child: Icon(nature_ == "+" ? FontAwesomeIcons.plus : FontAwesomeIcons.minus)),
                              ),
                            )
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Amount", style: TextStyle(fontSize: 18)),
                      SizedBox(width: 10),
                      Text("*", style: TextStyle(fontSize: 18, color: red)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.grey.shade900),
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    child: TextFormField(
                      onTapOutside: (PointerDownEvent event) => FocusScope.of(context).unfocus(),
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r"[\d\.]"))],
                      decoration: const InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("From WHERE ?", style: TextStyle(fontSize: 18)),
                      SizedBox(width: 10),
                      Text("*", style: TextStyle(fontSize: 18, color: red)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.grey.shade900),
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    child: TextFormField(
                      onTapOutside: (PointerDownEvent event) => FocusScope.of(context).unfocus(),
                      controller: _fromWhereController,
                      decoration: const InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text("Photo", style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 10),
                      const Text("(Optional)", style: TextStyle(fontSize: 18, color: blue)),
                      StatefulBuilder(
                        key: _operationPhotoKey,
                        builder: (BuildContext context, void Function(void Function()) _) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            if (_operationPicture != null) const SizedBox(width: 10),
                            if (_operationPicture != null)
                              const Stack(
                                alignment: AlignmentDirectional.center,
                                children: <Widget>[Icon(FontAwesomeIcons.certificate, size: 20, color: blue), Icon(FontAwesomeIcons.check, color: white, size: 15)],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      for (final Map<String, dynamic> type in _pickTypes)
                        InkWell(
                          splashColor: transparent,
                          radius: 40,
                          onTap: () => type["func"](),
                          child: AnimatedContainer(
                            duration: 500.ms,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: pigmentGreen.withOpacity(.3)),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(type["icon"], size: 15),
                                  const SizedBox(width: 10),
                                  Text(type["type"], style: const TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              for (final Map<String, dynamic> actionButton in actions(context))
                InkWell(
                  splashColor: transparent,
                  radius: 40,
                  onTap: actionButton["func"],
                  child: AnimatedContainer(
                    duration: 500.ms,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: actionButton["color"]),
                    child: Center(
                      child: Text(actionButton["type"], style: const TextStyle(fontSize: 14)),
                    ),
                  ),
                )
            ],
          )
        ],
      ),
    );
  }
}
