import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'flutter_thermal-main/lib/thermal.dart';

class TemperatureWidget extends StatefulWidget {
  @override
  _TemperatureWidgetState createState() => _TemperatureWidgetState();
}

class _TemperatureWidgetState extends State<TemperatureWidget> {
  double currenttemp=0;
void settemparature(){
Thermal().onBatteryTemperatureChanged.listen((temparature) {
setState(() {
  currenttemp=temparature;
});

 });
}

  @override
  void initState() {
    super.initState();
settemparature();

  }







  @override
  Widget build(BuildContext context) {
    return SizedBox(
    
      child: Column(
        children: [
    Text(
                              'Battery temperature: ${currenttemp.toStringAsFixed(1)}°C',
                              style: TextStyle(fontSize: 16),
                            ),
          SizedBox(
            height: 135,
            
            child: SfRadialGauge(
                    // Gauge configuration
                    axes: <RadialAxis>[
                      RadialAxis(
                        minimum: 0,
                        maximum: 50,
                        ranges: <GaugeRange>[
                          GaugeRange( startValue: 0, endValue: 20, color: Colors.green.withOpacity(0.7)),
                          GaugeRange(startValue: 20, endValue: 30, color: Colors.yellow.withOpacity(0.7)),
                          GaugeRange(startValue: 30, endValue: 40, color: Colors.orange.withOpacity(0.7)),
                          GaugeRange(startValue: 40, endValue: 50, color: Colors.red.withOpacity(0.7)),
                        ],
                        pointers: <GaugePointer>[
                          NeedlePointer( tailStyle: TailStyle(width: 7,),value:currenttemp),
                         WidgetPointer(
                          
                      value: currenttemp,
                      child: 
                           
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                    child: Text('${currenttemp}°C',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 15)),
                                  ),
                              
                          )
                        ],
                      
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
