import 'dart:io';
import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tarot_blood_type/common/common.dart';
import 'package:tarot_blood_type/models/entities/tarot_result.dart';
import 'package:tarot_blood_type/models/states/output_info_state.dart';

final outputInfoProvider =
    StateNotifierProvider<OutputInfoController, OutputInfoState>(
        (ref) => OutputInfoController());

class OutputInfoController extends StateNotifier<OutputInfoState> {
  OutputInfoController()
      : super(OutputInfoState(
          firstBloodType: bloodTypeList[0],
          secondBloodType: bloodTypeList[1],
          thirdBloodType: bloodTypeList[2],
          fourthBloodType: bloodTypeList[3],
        ));

  String get typeAResult => state.tarotResults?[BloodType.typeA]?.result ?? '';

  String get typeAAdvice => state.tarotResults?[BloodType.typeA]?.advice ?? '';

  String get typeBResult => state.tarotResults?[BloodType.typeB]?.result ?? '';

  String get typeBAdvice => state.tarotResults?[BloodType.typeB]?.advice ?? '';

  String get typeOResult => state.tarotResults?[BloodType.typeO]?.result ?? '';

  String get typeOAdvice => state.tarotResults?[BloodType.typeO]?.advice ?? '';

  String get typeABResult =>
      state.tarotResults?[BloodType.typeAB]?.result ?? '';

  String get typeABAdvice =>
      state.tarotResults?[BloodType.typeAB]?.advice ?? '';

  /// 占いをする。
  /// 占った結果は状態として保持する。
  void executeFortuneTelling() {
    final tarotResults = <BloodType, TarotResult>{};

    for (final element in BloodType.values) {
      final result = _chooseTarot();
      var advice = _chooseTarot();
      while (result == advice) {
        advice = _chooseTarot();
      }
      final tarotResult =
          TarotResult(bloodType: element, result: result, advice: advice);
      tarotResults[element] = tarotResult;
    }

    state = state.copyWith(tarotResults: tarotResults);
  }

  String _chooseTarot() {
    final rand = Random().nextInt(78);
    final tarot = tarotList[rand];
    final fb = Random().nextInt(2);
    var res = tarot.name;
    if (fb == 0) {
      res = '$resの正位置';
    } else {
      res = '$resの逆位置';
    }
    return res;
  }

  void changeFirstBloodType(String selected) {
    if (!bloodTypeList.contains(selected)) {
      return;
    }
    state = state.copyWith(firstBloodType: selected);
  }

  void changeSecondBloodType(String selected) {
    if (!bloodTypeList.contains(selected)) {
      return;
    }
    state = state.copyWith(secondBloodType: selected);
  }

  void changeThirdBloodType(String selected) {
    if (!bloodTypeList.contains(selected)) {
      return;
    }
    state = state.copyWith(thirdBloodType: selected);
  }

  void changeFourthBloodType(String selected) {
    if (!bloodTypeList.contains(selected)) {
      return;
    }
    state = state.copyWith(fourthBloodType: selected);
  }

  void saveTargetDate(String val) {
    state = state.copyWith(targetDate: val);
  }

  void saveFirstDescription(String val) {
    state = state.copyWith(firstDescription: val);
  }

  void saveSecondDescription(String val) {
    state = state.copyWith(secondDescription: val);
  }

  void saveThirdDescription(String val) {
    state = state.copyWith(thirdDescription: val);
  }

  void saveFourthDescription(String val) {
    state = state.copyWith(fourthDescription: val);
  }

  Future<void> outputFortuneTelling() async {
    var fileName = state.targetDate??'';
    fileName = fileName.replaceAll('/', '').replaceAll('(', '').replaceAll(')', '');
    final logPath = '/Users/kazuki/blog/uranai/$fileName.txt';
    final file = File(logPath);
    final write = state.firstDescription??'';

    await file.writeAsString(write);
  }





}
