import 'package:flutter/material.dart';
import 'package:solstice_assigment/modules/feature/data_layer/model/terms_model.dart';

import '../../../../utils/strings.dart';

class TermsCard extends StatelessWidget {
  final TermsCondition item;
  final Function onTap;
  final Function onTranslate;
  const TermsCard({Key? key,required this.item,required this.onTap,required this.onTranslate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTap();
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.value),
              const SizedBox(height: 5),
              item.hindiText.isEmpty ? const SizedBox() :Text(item.hindiText),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {
                      onTranslate();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(
                          const Color(0xffB58392)),
                      foregroundColor:
                      MaterialStateProperty.all<Color>(
                          Colors.white),
                    ),
                    child: const Text(readInHindi)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
