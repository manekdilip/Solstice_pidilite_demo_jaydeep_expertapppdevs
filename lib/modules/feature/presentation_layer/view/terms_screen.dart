import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lazy_loading_list/lazy_loading_list.dart';
import 'package:solstice_assigment/modules/feature/data_layer/model/terms_model.dart';
import 'package:solstice_assigment/modules/feature/presentation_layer/widget/terms_card.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

import '../../../../utils/helper.dart';
import '../../../../utils/strings.dart';
import '../../data_layer/model/terms_state.dart';
import '../../domain_layer/controller/terms_controller.dart';
import '../widget/add_more_bottomsheet.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  final modelManager = OnDeviceTranslatorModelManager();

  @override
  void initState() {
    ref.read(termsController);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(termsController.notifier).fetchTerms();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TermsConditionState data = ref.watch(termsController);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          termsConditions,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Builder(
        builder: (context) {
          if (data is LoadingState) {
            return const CircularProgressIndicator();
          } else if (data is LoadedState) {
            return ListView.builder(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                itemCount: data.terms.length + 1,
                itemBuilder: (context, index) {
                  if (index < data.terms.length) {
                    var item = data.terms[index];
                    return LazyLoadingList(
                      loadMore: () {},
                      index: index,
                      hasMore: true,
                      initialSizeOfItems: 8,
                      child: buildTermsCard(item, context),
                    );
                  }
                  return addMoreButton();
                });
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  //To render terms and condition card
  Widget buildTermsCard(TermsCondition item, BuildContext context) {
    return TermsCard(
      item: item,
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return AddMoreBottomSheet(
              item: item,
              isEdit: true,
              onAddOrUpdate: (englishText, translatedText, termsModel) {
                if (termsModel != null) {
                  updateTerms(englishText, translatedText, termsModel);
                }
                if (termsModel == null) {
                  addTerms(englishText, translatedText, termsModel);
                }
              },
            );
          },
        );
      },
      onTranslate: () async {
        final bool isModelExists = await modelManager
            .isModelDownloaded(TranslateLanguage.hindi.bcpCode);
        await manageModel(isModelExists, context, item);
      },
    );
  }

  //to download and translate the language
  Future<void> manageModel(
      bool isModelExists, BuildContext context, TermsCondition item) async {
    if (!isModelExists) {
      downloadingDialog(context);
      await modelManager
          .downloadModel(TranslateLanguage.hindi.bcpCode, isWifiRequired: false)
          .then((value) {
        Navigator.pop(context);
        if (value) {
          showSnackBar(context, successDownload);
          ref.read(termsController.notifier).hindiTranslate(item);
        } else {
          showSnackBar(context, failedDownload);
        }
      });
    } else {
      ref.read(termsController.notifier).hindiTranslate(item);
    }
  }

  // it render add more button
  Widget addMoreButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return AddMoreBottomSheet(
                  item: null,
                  isEdit: false,
                  onAddOrUpdate: (englishText, translatedText, termsModel) {
                    if (termsModel != null) {
                      updateTerms(englishText, translatedText, termsModel);
                    }
                    if (termsModel == null) {
                      addTerms(englishText, translatedText, termsModel);
                    }
                  });
            },
          );
        },
        style: ElevatedButton.styleFrom(
          elevation: 5,
          backgroundColor: const Color(0xffB58392),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: const Text(
          addMore,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // to update the terms
  updateTerms(
      String englishText, String hindiText, TermsCondition termsCondition) {
    final termCondition = TermsCondition(
      id: termsCondition.id,
      value: englishText,
      createdAt: termsCondition.createdAt,
      updatedAt: DateTime.now().millisecondsSinceEpoch.toString(),
      hindiText: hindiText,
    );
    ref.watch(termsController.notifier).updateTerm(termCondition);
  }

  // to add new the terms
  addTerms(
      String englishText, String hindiText, TermsCondition? termsCondition) {
    final termCondition = TermsCondition(
      id: UniqueKey().hashCode,
      value: englishText,
      createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
      updatedAt: DateTime.now().millisecondsSinceEpoch.toString(),
      hindiText: hindiText,
    );
    ref.watch(termsController.notifier).addTerm(termCondition);
  }
}
