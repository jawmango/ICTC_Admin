import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ictc_admin/models/register.dart';

class EvalToggleSwitch extends StatefulWidget {
  final Register register;

  const EvalToggleSwitch({Key? key, required this.register}) : super(key: key);

  @override
  _EvalToggleSwitchState createState() => _EvalToggleSwitchState();
}

class _EvalToggleSwitchState extends State<EvalToggleSwitch> {
  late ValueNotifier<bool> evalNotifier;

  @override
  void initState() {
    super.initState();
    evalNotifier = ValueNotifier<bool>(widget.register.eval);
  }

  @override
  void dispose() {
    evalNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: evalNotifier,
      builder: (context, evalStatus, _) {
        return ToggleSwitch(
          minWidth: 90.0,
          cornerRadius: 20.0,
          activeBgColors: [
            [Color(0xff008744)!],
            [Color(0xffffa700)!]
          ],
          activeFgColor: Colors.white,
          inactiveBgColor: Colors.white,
          inactiveFgColor: Color(0xff153faa).withOpacity(0.5),
          initialLabelIndex: evalStatus ? 0 : 1,
          totalSwitches: 2,
          labels: ['', ''],
          icons: [Icons.check, Icons.close],
          radiusStyle: true,
          onToggle: (index) {
            final newEval = index == 0;
            evalNotifier.value = newEval;

            final updatedData = {'eval_status': newEval};

            Supabase.instance.client
                .from('registration')
                .update(updatedData)
                .eq('id', widget.register.id as Object)
                .then((_) {
              // Update succeeded
              print('Approval status updated successfully');
            }).catchError((error) {
              // Handle update error
              print('Error updating approval status: $error');
            });
          },
        );
      },
    );
  }
}
