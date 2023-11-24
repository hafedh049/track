import 'package:em/classes.dart';
import 'package:em/operation_model.dart';
import 'package:flutter/material.dart';

const Color emerald = Color.fromRGBO(33, 211, 117, 1);
const Color pigmentGreen = Color.fromRGBO(8, 160, 69, 1);
const Color transparent = Colors.transparent;
const Color white = Colors.white;
const Color red = Colors.red;
const Color blue = Colors.blue;

double total = .0;

List<OperationModel> tracking = <OperationModel>[];
ObjectBoxDatabase? database;
final GlobalKey<AnimatedListState> animatedListKey = GlobalKey<AnimatedListState>();
