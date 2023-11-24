import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:date_format/date_format.dart';
import 'package:em/bsheet.dart';
import 'package:em/error.dart';
import 'package:em/functions.dart';
import 'package:em/globals.dart';
import 'package:em/operation_model.dart';
import 'package:em/wait.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lottie/lottie.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    FlutterNativeSplash.remove();
    super.initState();
  }

  final GlobalKey _totalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Column(
        children: <Widget>[
          const SizedBox(height: 60),
          SizedBox(
            height: 300,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                LottieBuilder.asset("assets/bubble.json"),
                StatefulBuilder(key: _totalKey, builder: (BuildContext context, void Function(void Function()) _) => AnimatedFlipCounter(duration: 1.seconds, thousandSeparator: ",", fractionDigits: 2, textStyle: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold), value: total, decimalSeparator: ",", suffix: " DT")),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<OperationModel>>(
              stream: database!.getAllOperations(),
              builder: (BuildContext context, AsyncSnapshot<List<OperationModel>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    final List<OperationModel> operations = snapshot.data!;
                    operations.sort((a, b) => -a.operationDate.compareTo(b.operationDate));
                    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) => _totalKey.currentState!.setState(() => total = calculateIncome(operations)));
                    return ListView.separated(
                      key: animatedListKey,
                      itemBuilder: (BuildContext context, int index) => Dismissible(
                        key: ValueKey<DateTime>(operations[index].operationDate),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (DismissDirection direction) => database!.deleteOperation(operations.firstWhere((OperationModel element) => element.operationDate == operations[index].operationDate).id),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: const Color.fromARGB(255, 46, 46, 46)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(child: Row(children: <Widget>[Flexible(child: Text(operations[index].title, style: const TextStyle(fontSize: 22)))])),
                                  const SizedBox(width: 20),
                                  Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: operations[index].nature == "-" ? red : emerald, borderRadius: BorderRadius.circular(3)), child: Text(operations[index].currency == "TND" ? "${operations[index].nature} ${operations[index].amount} ${operations[index].currency}" : "${operations[index].nature} ${operations[index].currency}${operations[index].amount}")),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Row(children: <Widget>[
                                    Flexible(child: Text(formatDate(operations[index].operationDate, <String>[D, ", ", dd, " ", M, " ", yyyy, " - ", hh, ":", nn, " ", am])))
                                  ])),
                                  const Spacer(),
                                  Container(width: 40, height: 40, decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)), child: Image.memory(operations[index].picture)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ).animate().fade(delay: (index * 200).ms),
                      separatorBuilder: (BuildContext context, int index) => const Divider(color: pigmentGreen, thickness: .2, height: .2, indent: 25, endIndent: 25),
                      itemCount: operations.length,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                    );
                  } else {
                    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) => _totalKey.currentState!.setState(() => total = 0));
                    return Animate(child: LottieBuilder.asset("assets/empty.json")).fade().slide();
                  }
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Waiting();
                } else {
                  return ErrorD(error: snapshot.error.toString());
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: InkWell(
        onTap: () async => await showModalBottomSheet(context: context, isDismissible: true, enableDrag: true, showDragHandle: true, builder: (BuildContext context) => const BSheet()),
        splashColor: emerald,
        child: Container(
          decoration: const BoxDecoration(shape: BoxShape.circle, color: emerald),
          width: 50,
          height: 50,
          margin: const EdgeInsets.only(bottom: 16),
          alignment: AlignmentDirectional.bottomEnd,
          child: Center(child: Container(decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).colorScheme.background), width: 20, height: 20)),
        ).animate(onComplete: (AnimationController controller) => controller.repeat(reverse: true)).scale(duration: 1.5.seconds, begin: const Offset(1, 1), end: const Offset(1.2, 1.2)),
      ),
    );
  }
}
