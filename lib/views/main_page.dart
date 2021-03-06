import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tarot_blood_type/common/constants.dart';
import 'package:tarot_blood_type/view_models/controller/output_info_controller.dart';
import 'package:tarot_blood_type/views/parts/table_row_text_part.dart';

class MainPage extends HookWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useProvider(outputInfoProvider);
    final notifier = useProvider(outputInfoProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('神'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              OutlinedButton.icon(
                onPressed: notifier.executeFortuneTelling,
                label: const Text('占う'),
                icon: const Icon(Icons.terrain),
              ),
              const SizedBox(
                height: 20,
              ),
              // 占い結果
              Table(
                columnWidths: const {
                  0: FractionColumnWidth(0.1),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.top,
                border: TableBorder.all(
                  color: Colors.white,
                ),
                children: [
                  const TableRow(
                      decoration: BoxDecoration(color: Colors.indigo),
                      children: [
                        TableRowTextPart(text: '血液型'),
                        TableRowTextPart(text: '結果'),
                        TableRowTextPart(text: 'アドバイス'),
                      ]),
                  TableRow(children: [
                    const TableRowTextPart(text: 'A型'),
                    TableRowTextPart(text: notifier.typeAResult),
                    TableRowTextPart(text: notifier.typeAAdvice),
                  ]),
                  TableRow(
                    children: [
                      const TableRowTextPart(text: 'B型'),
                      TableRowTextPart(text: notifier.typeBResult),
                      TableRowTextPart(text: notifier.typeBAdvice),
                    ],
                  ),
                  TableRow(children: [
                    const TableRowTextPart(text: 'O型'),
                    TableRowTextPart(text: notifier.typeOResult),
                    TableRowTextPart(text: notifier.typeOAdvice),
                  ]),
                  TableRow(children: [
                    const TableRowTextPart(text: 'AB型'),
                    TableRowTextPart(text: notifier.typeABResult),
                    TableRowTextPart(text: notifier.typeABAdvice),
                  ]),
                ],
              ),
              const SizedBox(
                height: 20,
              ),

              // 出力情報入力
              Row(
                children: [
                  Text(notifier.targetDate),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final dateTime =
                          await _selectDate(context, state.targetDate);
                      notifier.saveTargetDate(dateTime);
                    },
                    label: const Text('datepicker'),
                    icon: const Icon(Icons.create_outlined),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('1位'),
                  const SizedBox(
                    width: 10,
                  ),
                  DropdownButton(
                    items: bloodTypeList
                        .map(
                          (String e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    value: state.firstBloodType,
                    onChanged: (value) {
                      notifier.changeFirstBloodType(value.toString());
                    },
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  const Text('2位'),
                  const SizedBox(
                    width: 10,
                  ),
                  DropdownButton(
                    items: bloodTypeList
                        .map(
                          (String e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    value: state.secondBloodType,
                    onChanged: (value) {
                      notifier.changeSecondBloodType(value.toString());
                    },
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  const Text('3位'),
                  const SizedBox(
                    width: 10,
                  ),
                  DropdownButton(
                    items: bloodTypeList
                        .map(
                          (String e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    value: state.thirdBloodType,
                    onChanged: (value) {
                      notifier.changeThirdBloodType(value.toString());
                    },
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  const Text('4位'),
                  const SizedBox(
                    width: 10,
                  ),
                  DropdownButton(
                    items: bloodTypeList
                        .map(
                          (String e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    value: state.fourthBloodType,
                    onChanged: (value) {
                      notifier.changeFourthBloodType(value.toString());
                    },
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                ],
              ),
              TextFormField(
                maxLines: null,
                maxLength: 200,
                decoration: const InputDecoration(hintText: 'A型'),
                keyboardType: TextInputType.multiline,
                onChanged: notifier.saveTypeADescription,
              ),
              TextFormField(
                maxLines: null,
                maxLength: 200,
                decoration: const InputDecoration(hintText: 'B型'),
                keyboardType: TextInputType.multiline,
                onChanged: notifier.saveTypeBDescription,
              ),
              TextFormField(
                maxLines: null,
                maxLength: 200,
                decoration: const InputDecoration(hintText: 'O型'),
                keyboardType: TextInputType.multiline,
                onChanged: notifier.saveTypeODescription,
              ),
              TextFormField(
                maxLines: null,
                maxLength: 200,
                decoration: const InputDecoration(hintText: 'AB型'),
                keyboardType: TextInputType.multiline,
                onChanged: notifier.saveTypeABDescription,
              ),
              const SizedBox(
                height: 20,
              ),
              OutlinedButton.icon(
                onPressed: notifier.outputFortuneTelling,
                label: const Text('出力'),
                icon: const Icon(Icons.create_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<DateTime> _selectDate(
      BuildContext context, DateTime? targetDate) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: targetDate ?? DateTime.now().add(const Duration(days: 1)),
        firstDate: DateTime(2016),
        lastDate: DateTime.now().add(const Duration(days: 360)));
    if (picked != null) {
      return picked;
    } else {
      return targetDate ?? DateTime.now().add(const Duration(days: 1));
    }
  }
}
