
import 'package:solstice_assigment/modules/feature/data_layer/model/terms_model.dart';

abstract class TermsConditionState {}

class InitialState extends TermsConditionState {}

class LoadingState extends TermsConditionState {}

class LoadedState extends TermsConditionState {
  final List<TermsCondition> terms;

  LoadedState(this.terms);
}

class TranslateToHindiState extends TermsConditionState {
  final String hindiTranslatedText;

  TranslateToHindiState({required this.hindiTranslatedText});
}

class FailedState extends TermsConditionState {}
