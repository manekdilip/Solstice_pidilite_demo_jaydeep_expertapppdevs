import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../utils/helper.dart';
import '../../data_layer/model/terms_model.dart';
import '../../data_layer/model/terms_state.dart';
import '../../data_layer/repository/terms_repository.dart';

final termsController = StateNotifierProvider<TermsNotifier, TermsConditionState>(
  (ref) => TermsNotifier(
    (InitialState()),
  ),
);

class TermsNotifier extends StateNotifier<TermsConditionState> {

  TermsNotifier(state) : super(state);
  var repository = TermsConditionRepository();
  var termList = <TermsCondition>[];


  // to translate the text from english
 void hindiTranslate(TermsCondition term) async {
    try {
      term.hindiText = await translator.translateText(term.value);
      final index = termList.indexOf(term);
      if (index != -1) {
        termList[index] = term;
        state = LoadedState(List.from(termList));
      }
    } catch (e) {
      state = FailedState();
    }
  }

  // to fetch the terms and condition
  void fetchTerms() async{
    state = LoadingState();
    try {
      termList = await repository.fetchTermsCondition();
      state = LoadedState(termList);
    } catch (e) {
      state = FailedState();
    }
  }

  // to add terms and condition
  void addTerm(TermsCondition termsCondition) {
    termList.add(termsCondition);
    state = LoadedState(List.from(termList));
  }

  //to update the terms and condition
  void updateTerm(TermsCondition termsCondition) {
    final index = termList.indexWhere((newTerm) => termsCondition.id == newTerm.id);
    if (index != -1) {
      termList[index] = termsCondition;
      state = LoadedState(List.from(termList));
    }
  }
}
