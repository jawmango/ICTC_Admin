import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ictc_admin/models/register.dart';

class PaymentToggleSwitch extends StatefulWidget {
  final Register register;

  const PaymentToggleSwitch({Key? key, required this.register}) : super(key: key);

  @override
  _PaymentToggleSwitchState createState() => _PaymentToggleSwitchState();
}

class _PaymentToggleSwitchState extends State<PaymentToggleSwitch> {
  late ValueNotifier<bool> isApprovedNotifier;

  @override
  void initState() {
    super.initState();
    isApprovedNotifier = ValueNotifier<bool>(widget.register.status);
  }

  @override
  void dispose() {
    isApprovedNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isApprovedNotifier,
      builder: (context, isApproved, _) {
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
          initialLabelIndex: isApproved ? 0 : 1,
          totalSwitches: 2,
          labels: ['', ''],
          icons: [Icons.check, Icons.close],
          radiusStyle: true,
          onToggle: (index) {
            final newStatus = index == 0;
            isApprovedNotifier.value = newStatus;

            final updatedData = {'is_approved': newStatus};

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
