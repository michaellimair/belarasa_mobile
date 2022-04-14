enum MassTargetAudience {
  ownParish,
  membersOfKAJ,
}

extension MassTargetAudienceParser on MassTargetAudience {
  static MassTargetAudience? parse(String targetAudienceString) {
    if (targetAudienceString == "Untuk Paroki Sendiri") {
      return MassTargetAudience.ownParish;
    }
    if (targetAudienceString == "Untuk Umat KAJ") {
      return MassTargetAudience.membersOfKAJ;
    }
    return null;
  }

  static String toKey(MassTargetAudience targetAudience) {
    if (targetAudience == MassTargetAudience.membersOfKAJ) {
      return "members_of_kaj";
    }
    if (targetAudience == MassTargetAudience.ownParish) {
      return "own_parish";
    }
    throw Exception("Invalid mass target audience key!");
  }
}

class MassModel {
  String eventName;
  String date;
  String time;
  String? massId;
  String? dioceseId;
  String? parishId;
  String parish; // Keuskupan
  String region;
  String territory; // Wilayah
  String neighborhood; // Lingkungan
  String churchName;
  int? remainingQuota;
  MassTargetAudience? targetAudience;

  MassModel({
    required this.eventName,
    required this.date,
    required this.time,
    required this.massId,
    required this.dioceseId,
    required this.parishId,
    required this.parish,
    required this.region,
    required this.territory,
    required this.neighborhood,
    required this.churchName,
    required this.remainingQuota,
    required this.targetAudience,
  });
}
