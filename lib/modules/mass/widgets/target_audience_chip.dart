import 'package:belarasa_mobile/data/models/mass_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TargetAudienceChip extends GetWidget {
  final MassTargetAudience targetAudience;

  const TargetAudienceChip({required this.targetAudience});

  Color? getColor() {
    if (targetAudience == MassTargetAudience.membersOfKAJ) {
      return Colors.green;
    }
    if (targetAudience == MassTargetAudience.ownParish) {
      return Colors.red;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(MassTargetAudienceParser.toKey(targetAudience).tr),
      backgroundColor: getColor(),
      labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    );
  }
}
