//#pragma: declaration
class HydroRangeSlider extends StatefulWidget {
  const HydroRangeSlider({super.key});

  @override
  State<HydroRangeSlider> createState() => _HydroRangeSliderState();
}

class _HydroRangeSliderState extends State<HydroRangeSlider> {
  RangeValues values = const RangeValues([[min]], [[max]]);

  @override
  Widget build(BuildContext context) {
    return 
    SliderTheme(
      data: SliderTheme.of(context).copyWith(
        showValueIndicator: ShowValueIndicator.always,
      ),
      child:
    RangeSlider(
      values: values,
      min: [[min]],
      max: [[max]],
      labels: RangeLabels(
        values.start.round().toString(),
        values.end.round().toString(),
      ),
      onChanged: (RangeValues newValues) {
        setState(() {
          values = newValues;
        });
        var event = {
          'fromDate': values.start.round().toString(),
          'toDate': values.end.round().toString(),
        };
        ##TRIGGERS##
      },
    ),);
  }
}

//#pragma: execution
SizedBox(width: 500, height: 50, child: HydroRangeSlider()),