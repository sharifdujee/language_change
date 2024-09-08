import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/main.dart';
import 'package:weather/shared/color.dart';
import 'package:weather/shared/text_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

class ScreenOne extends StatefulWidget {
  const ScreenOne({super.key});

  @override
  State<ScreenOne> createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController feeController = TextEditingController();
  final TextEditingController actualFeeController = TextEditingController();
  DateTime _dateTime = DateTime.now();
  var formatedDate = DateFormat('yyy-MM-dd');
  String selectedDate = '';
  bool isRevisit = false;
  List<bool> isSelected = [true, false];


void selectedDateTime()async{
  final DateTime? newDate = await showDatePicker(
      context: context, firstDate: DateTime.now().subtract(const Duration(days: 90)), lastDate: _dateTime);
  if(newDate != null){
    setState(() {
      _dateTime = newDate;
      selectedDate = formatedDate.format(newDate);
      if(isRevisit){
        _calculateActualFee();
      }
    });
  }

}
  int calculateTimeDifference(String appointmentDate){
  if(appointmentDate.isEmpty){
    return 0;
  }
  DateTime presentDate = DateTime.now();
  DateTime scheduleDate = DateFormat('yyyy-MM-dd').parse(appointmentDate);
  Duration differences = presentDate.difference(scheduleDate);
  int differencesInDays = differences.inDays;
  return differencesInDays;
  }

 /* int calculateTimeDifference(String appointmentDate) {
    if (appointmentDate.isEmpty) {
      print('No date selected');
      return 0;
    }
    DateTime presentDate = DateTime.now();
    DateTime scheduleDate = DateFormat('yyyy-MM-dd').parse(appointmentDate);
    Duration difference = presentDate.difference(scheduleDate);
    int differenceInDays = difference.inDays;

    print('The calculated difference is $differenceInDays days');
    return differenceInDays;
  }
*/
  void _calculateActualFee() {
    int daysDifference = calculateTimeDifference(selectedDate);

    double regularFee = double.tryParse(feeController.text) ?? 0.0;
    double actualFee;

    if (daysDifference <= 6) {
      actualFee = 0.0;
    } else if (daysDifference >= 7 && daysDifference <= 30) {
      actualFee = regularFee * 0.5;
    } else {
      actualFee = regularFee;
    }

    actualFeeController.text = actualFee.toStringAsFixed(2);
  }

  @override
  void initState() {
    isSelected = [true, false];
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(!Hive.isBoxOpen('langBox')){
      Hive.openBox('langBox');
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:  Text(AppLocalizations.of(context)?.test??''),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 110,
              right: 0,
              left: 0,
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Flexible(
                    flex: 1,
                      fit: FlexFit.tight,

                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: 40,
                              child: ToggleButtons(
                                focusColor: Colors.green,
                                fillColor: baseColor,
                                color: Colors.redAccent,
                                highlightColor: Colors.blue,
                                hoverColor: Colors.red,
                                borderColor: Colors.green,
                                borderWidth: 2,
                                selectedBorderColor: Colors.yellow,
                                selectedColor: Colors.green,
                                borderRadius: BorderRadius.circular(50),
                                constraints: const BoxConstraints(
                                  minHeight: 40,
                                  maxHeight: 80,
                                  minWidth: 80,
                                ),
                                onPressed: (int index){
                                  Hive.box('langBox').put('langCode', index ==1? 'en': 'bn');
                                  MyApp.setLocale(
                                      context, Locale(index == 1 ? 'en' : 'bn'));
                                  setState(() {
                                    for (int i = 0; i < isSelected.length; i++) {
                                      isSelected[i] = i == index;
                                    }
                                  });
                                },
                                  children: const [

                                Padding(padding: const EdgeInsets.symmetric(
                                  horizontal: 2, vertical: 0,
                                  
                                ),
                                child: Text('Bengali'),),
                                Padding(padding: const EdgeInsets.symmetric(
                                  horizontal: 2, vertical: 0,

                                ),
                                  child: Text('English'),)
                              ], isSelected: isSelected),
                            )

                          ],
                        ),

                  ))
                ],
              )),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: feeController,
                    decoration: const InputDecoration(
                      labelText: 'Fee',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (isRevisit) {
                        _calculateActualFee();
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  CheckboxListTile(
                    title: const Text("Revisit/Follow-up"),
                    value: isRevisit,
                    onChanged: (bool? value) {
                      setState(() {
                        isRevisit = value ?? false;
                        if (isRevisit) {
                          _calculateActualFee();
                        } else {
                          actualFeeController.clear();
                        }
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: 20),
                  if (isRevisit)
                    TextFormField(
                      controller: actualFeeController,
                      decoration: const InputDecoration(
                        labelText: 'Actual Fee',
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                    ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text('Select the date'),
                      GestureDetector(
                        onTap: () => selectedDateTime(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.lightGreen),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(10)),
                          ),
                          child: Text(selectedDate.isEmpty
                              ? 'Choose Date'
                              : selectedDate),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: (){
                      _showActualFee();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: const Icon(Icons.check),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isRevisit ? _calculateActualFee : null,
        child: const Icon(Icons.calculate),
      ),
    );
  }

  Future<void> _showActualFee(){
    return showDialog(context: context, builder: (BuildContext context){
      return  AlertDialog(
        title: const Text('Actual Fee',style: alertTitleTextStyle,textAlign: TextAlign.center, ),
        content: Text('the actual fee is ${actualFeeController.text}', ),
        actions: [
          InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: baseColor
              ),
              child: const Icon(Icons.telegram),
            ),
          )
        ],

      );
    });
  }
}
