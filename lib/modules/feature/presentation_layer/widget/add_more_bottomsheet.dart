import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:solstice_assigment/modules/feature/data_layer/model/terms_model.dart';
import 'package:solstice_assigment/modules/feature/presentation_layer/widget/textfiled.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../utils/helper.dart';
import '../../../../utils/strings.dart';

class AddMoreBottomSheet extends StatefulWidget {
  TermsCondition? item;
  final bool isEdit;
  final Function(String, String, TermsCondition?) onAddOrUpdate;

  AddMoreBottomSheet(
      {Key? key, this.item, required this.isEdit, required this.onAddOrUpdate})
      : super(key: key);

  @override
  State<AddMoreBottomSheet> createState() => _AddMoreBottomSheetState();
}

class _AddMoreBottomSheetState extends State<AddMoreBottomSheet> {
  var controller = TextEditingController();

  final SpeechToText speechToText = SpeechToText();

  final ValueNotifier<bool> listeningNotifier = ValueNotifier<bool>(false);

  final ValueNotifier<bool> submitButtonNotifier = ValueNotifier<bool>(false);

  final ValueNotifier<String> spokenTextNotifier = ValueNotifier<String>('');

  final modelManager = OnDeviceTranslatorModelManager();

  String _hindiTranslation = '';

  //it render TextField
  Widget buildTextField() {
    return TextFieldWidget(
        controller: controller,
        onChanged: (value) {
          if (value.isNotEmpty) {
            submitButtonNotifier.value = true;
          } else {
            submitButtonNotifier.value = false;
          }
          setState(() {});
        });
  }

  @override
  void initState() {
    _hindiTranslation = widget.item != null ? widget.item!.hindiText : '';
    controller.text = widget.item != null ? widget.item!.value : '';
    super.initState();
  }

  //it render mic button
  Widget buildMicButton() {
    return IconButton(
      icon: ValueListenableBuilder<bool>(
        valueListenable: listeningNotifier,
        builder: (context, isListening, child) {
          return Icon(
            isListening ? Icons.mic : Icons.mic_none,
          );
        },
      ),
      onPressed: () async {
        final status = await Permission.microphone.request();
        if (status.isGranted) {
          if (!listeningNotifier.value) {
            spokenTextNotifier.value = '';
            controller.text = '';
            openMicDialog();
          } else {
            speechToText.stop();
          }
        } else {
          showSettingsDialog(context);
        }
      },
    );
  }

  // it render submit button
  Widget buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ValueListenableBuilder<bool>(
        valueListenable: submitButtonNotifier,
        builder: (context, isSubmitting, child) {
          return ElevatedButton(
            onPressed: isSubmitting ? addTermCondition : addTermCondition,
            style: ElevatedButton.styleFrom(
              backgroundColor: controller.text.isEmpty
                  ? Colors.grey
                  : const Color(0xFFB58392),
            ),
            child: Text(
              widget.isEdit ? update : confirm,
              style: TextStyle(
                  color: controller.text.isEmpty ? Colors.black : Colors.white),
            ),
          );
        },
      ),
    );
  }

  // it renders view in hindi button
  Widget viewInHindiButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffB58392),
        ),
        onPressed: () async {
          if (controller.text.isNotEmpty) {
            final bool isModelExists = await modelManager
                .isModelDownloaded(TranslateLanguage.hindi.bcpCode);
            await manageModel(isModelExists);
          }
        },
        child: const Text(
          viewInHindi,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  // To download model
  Future<void> manageModel(bool isModelExists) async {
    if (isModelExists) {
      final String response = await translator.translateText(controller.text);
      setState(() {
        _hindiTranslation = response;
      });
    } else {
      downloadingDialog(context);
      await modelManager
          .downloadModel(TranslateLanguage.hindi.bcpCode, isWifiRequired: false)
          .then((value) async {
        Navigator.pop(context);
        if (value) {
          showSnackBar(context, successDownload);
          final String response = await translator.translateText(controller.text);
          setState(() {
            _hindiTranslation = response;
          });
        } else {
          showSnackBar(context, failedDownload);
        }
      });
    }
  }

  // it adds/updates terms and condition
  Future<void> addTermCondition() async {
    if (formKey.currentState!.validate()) {
      if (controller.text.isNotEmpty) {
        final englishText = controller.text;
        if(_hindiTranslation.isNotEmpty){
          final String response = await translator.translateText(controller.text);
          widget.onAddOrUpdate(englishText, response, widget.item);
        }else{
          widget.onAddOrUpdate(englishText, _hindiTranslation, widget.item);
        }
        Navigator.of(context).pop();
      }
    }
  }

  // it render mic dialog
  void openMicDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, state) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  dialogTitleView(),
                  const SizedBox(height: 10),
                  buildMicButtonsView(state),
                  buildSpokenTextView(),
                  const SizedBox(height: 10),
                  buildActionButtonsView(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // it render Mic button UI
  Widget buildMicButtonsView(StateSetter setState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: ValueListenableBuilder<bool>(
            valueListenable: listeningNotifier,
            builder: (context, listening, child) {
              return Icon(
                listening ? Icons.mic_sharp : Icons.mic_none,
              );
            },
          ),
          onPressed: () {
            spokenTextNotifier.value = '';
            startListening(setState);
          },
        ),
        ValueListenableBuilder<bool>(
          valueListenable: listeningNotifier,
          builder: (context, isListening, child) {
            return Text(isListening ? 'Listening...' : '');
          },
        )
      ],
    );
  }

  void startListening(StateSetter state) async {
    if (!listeningNotifier.value) {
      final bool isInitialize =
          await speechToText.initialize(onStatus: (status) {
        state(() {
          listeningNotifier.value = status == SpeechToText.listeningStatus;
        });
      });
      if (isInitialize) {
        state(() {
          listeningNotifier.value = true;
        });
        speechToText.listen(
          partialResults: true,
          cancelOnError: true,
          listenMode: ListenMode.confirmation,
          onResult: (result) {
            state(() {
              spokenTextNotifier.value = result.recognizedWords;
              listeningNotifier.value = false;
            });
          },
        );
      }
    } else {
      speechToText.stop();
    }
  }

  // it renders hindi text
  Widget buildHindiText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Text(
        _hindiTranslation,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  void dispose() {
    listeningNotifier.dispose();
    submitButtonNotifier.dispose();
    spokenTextNotifier.dispose();
    controller.dispose();
    super.dispose();
  }

  // To render spokenText UI
  Widget buildSpokenTextView() {
    return Text(spokenTextNotifier.value);
  }

  // it render buttons for voice input dialog
  Widget buildActionButtonsView() {
    return Row(
      children: [
        dialogCancelButton(() {
          speechToText.stop();
          listeningNotifier.value = false;
          submitButtonNotifier.value = true;
          Navigator.of(context).pop();
        }),
        const SizedBox(
          width: 10,
        ),
        dialogSubmitButton(),
      ],
    );
  }

  // it render submit buttons for voice input dialog
  Expanded dialogSubmitButton() {
    return Expanded(
      child: ValueListenableBuilder<String>(
        valueListenable: spokenTextNotifier,
        builder: (context, spokenText, child) {
          return ElevatedButton(
            onPressed: listeningNotifier.value
                ? null
                : () {
                    if (spokenText.isEmpty) {
                      //snackBarMessenger(context);
                    } else {
                      speechToText.stop();
                      submitButtonNotifier.value = true;
                      controller.text = spokenTextNotifier.value;
                      setState(() {});
                      Navigator.of(context).pop();
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  spokenText.isEmpty ? Colors.grey : const Color(0xffB58392),
            ),
            child: Text(
              submit,
              style: TextStyle(
                  color: spokenText.isEmpty ? Colors.black : Colors.white),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 10,
      ),
      child: Builder(
        builder: (builderContext) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 30),
              Row(
                children: [
                  const SizedBox(width: 10),
                  buildTextField(),
                  buildMicButton(),
                ],
              ),
              const SizedBox(height: 12),
              if (controller.text.isNotEmpty) buildHindiText(),
              const SizedBox(height: 12),
              Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(child: viewInHindiButton()),
                  const SizedBox(width: 10),
                  Expanded(child: buildSubmitButton()),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 12),
            ],
          );
        },
      ),
    );
  }
}
