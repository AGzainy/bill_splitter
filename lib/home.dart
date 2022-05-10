import 'package:flutter/material.dart';

import 'hexcolor.dart';

class BillSplitter extends StatefulWidget {
  const BillSplitter({Key? key}) : super(key: key);

  @override
  _BillSplitterState createState() => _BillSplitterState();
}

class _BillSplitterState extends State<BillSplitter> {
  //private variable
  int _tipPercentage = 0;
  int _personCounter = 1;
  double _billAmount = 0.0;

  Color _orange = HexColor("#fe6b00");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Every Man 4 Himself",
          style: TextStyle(
              color: Colors.black, fontStyle: FontStyle.italic, fontSize: 25),
        ),
        backgroundColor: _orange,
        centerTitle: (true),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.black.withOpacity(0.87),
        child: ListView(
          //to be able to scroll
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(20.5),
          children: [
            //children is an array of widget
            Container(
              //margin: EdgeInsets.only(top: 25),  //or to have a more  dynamic UI:
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.03),
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: _orange,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Total Per Person",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 17,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "\$ ${calculateTotalPerPerson(_billAmount, _personCounter, _tipPercentage)}",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: _orange, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  TextField(
                    keyboardType:
                    TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                    decoration: InputDecoration(
                      prefixText: "Bill Amount ",
                      prefixStyle: TextStyle(color: Colors.orange.shade800),
                      prefixIcon: Icon(
                        Icons.attach_money_outlined,
                        color: _orange,
                      ),
                    ),
                    onChanged: (String value) {
                      try {
                        _billAmount = double.parse(
                            value); //parse will change the string value to a double
                      } catch (exception) {
                        _billAmount = 0.0;
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Split",
                        style: TextStyle(color: _orange, fontSize: 17),
                      ),
                      Row(
                        children: [
                          InkWell(
                            //using inkwell cuz its not a complicated button
                            onTap: () {
                              setState(() {
                                if (_personCounter > 1) {
                                  _personCounter--;
                                } else {
                                  //do nothing
                                }
                              });
                            },
                            child: Container(
                              width: 40.0,
                              height: 40.0,
                              margin: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: _orange),
                              child: Center(
                                child: Text(
                                  "-",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "$_personCounter",
                            style: TextStyle(
                                color: _orange,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _personCounter++;
                              });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: _orange,
                                  borderRadius: BorderRadius.circular(7)),
                              child: Center(
                                child: Text(
                                  "+",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  //Tip
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tip",
                        style: TextStyle(color: _orange, fontSize: 17),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                          "\$ ${calculateTotalTip(_billAmount, _personCounter, _tipPercentage)}",
                          style: TextStyle(
                              color: _orange,
                              fontSize: 19,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  //Slider
                  Column(
                    children: [
                      Text(
                        "$_tipPercentage%",
                        style: TextStyle(
                            color: _orange,
                            fontSize: 19,
                            fontWeight: FontWeight.bold),
                      ),
                      Slider(
                          min: 0,
                          max: 100,
                          activeColor: _orange,
                          inactiveColor: Colors.black,
                          divisions: 20,
                          value: _tipPercentage.toDouble(),
                          //convert to double cuz value requires double
                          onChanged: (double newValue) {
                            //passing a method
                            setState(() {
                              _tipPercentage = newValue.round();
                            });
                          })
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  calculateTotalPerPerson(
      double billAmount, int numPersons, int tipPercentage) {
    var totalPerPerson =
        (calculateTotalTip(billAmount, numPersons, tipPercentage) +
            billAmount) /
            numPersons;
    return totalPerPerson
        .toStringAsFixed(2); // to only show 2 nums after the decimal point
  }

  calculateTotalTip(double billAmount, int numPersons, int tipPercentage) {
    double totalTip = 0;
    if (billAmount < 0 || billAmount.toString().isEmpty) {
      //null is usually taking care of in dart
      //do nothing
    } else {
      totalTip = (billAmount * tipPercentage) / 100;
    }
    return totalTip;
  }
}