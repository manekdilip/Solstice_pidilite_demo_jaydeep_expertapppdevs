import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:solstice_assigment/modules/feature/data_layer/model/terms_model.dart';

// to get list of terms from json
class TermsConditionRepository {
  Future<List<TermsCondition>> fetchTermsCondition() async {
    final String terms = await rootBundle.loadString('assets/terms_condition.json');
    final List<dynamic> termsList = json.decode(terms);

    return termsList.map((json) => TermsCondition.fromJson(json)).toList();
  }
}
