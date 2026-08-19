import 'package:flutter/material.dart';

class QuestionnaireViewModel extends ChangeNotifier {
  // --- Q1 to Q4 ---
  TimeOfDay? bedtime; // Q1
  int? sleepLatencyMinutes; // Q2
  TimeOfDay? wakeUpTime; // Q3
  double? hoursSlept; // Q4

  void updateBedtime(TimeOfDay time) {
    bedtime = time;
    notifyListeners();
  }

  void updateSleepLatency(int minutes) {
    sleepLatencyMinutes = minutes;
    notifyListeners();
  }

  void updateWakeUpTime(TimeOfDay time) {
    wakeUpTime = time;
    notifyListeners();
  }

  void updateHoursSlept(double hours) {
    hoursSlept = hours;
    notifyListeners();
  }

  // --- Q5 (a to j) ---
  // Options: 0 (None), 1 (<1/week), 2 (1-2/week), 3 (>=3/week)
  Map<String, int?> q5 = {
    'a': null, 'b': null, 'c': null, 'd': null, 'e': null, 'f': null, 'g': null, 'h': null, 'i': null, 'j': null,
  };
  String q5jOtherReason = '';

  void updateQ5(String key, int value) {
    q5[key] = value;
    notifyListeners();
  }
  
  void updateQ5jReason(String reason) {
    q5jOtherReason = reason;
    notifyListeners();
  }

  // --- Q6 ---
  // Options: 0 (Rất tốt), 1 (Khá tốt), 2 (Khá tệ), 3 (Rất tệ)
  int? q6;
  void updateQ6(int value) {
    q6 = value;
    notifyListeners();
  }

  // --- Q7, Q8 ---
  // Options: 0 (None), 1 (<1/week), 2 (1-2/week), 3 (>=3/week)
  int? q7;
  int? q8;

  void updateQ7(int value) {
    q7 = value;
    notifyListeners();
  }

  void updateQ8(int value) {
    q8 = value;
    notifyListeners();
  }

  // --- Q9 ---
  // Options: 0 (Không vấn đề), 1 (Hơi vấn đề), 2 (Khá vấn đề), 3 (Rất vấn đề)
  int? q9;
  void updateQ9(int value) {
    q9 = value;
    notifyListeners();
  }

  // --- Q10 (a to e) ---
  Map<String, int?> q10 = {
    'a': null, 'b': null, 'c': null, 'd': null, 'e': null,
  };
  String q10eOtherReason = '';

  void updateQ10(String key, int value) {
    q10[key] = value;
    notifyListeners();
  }
  
  void updateQ10eReason(String reason) {
    q10eOtherReason = reason;
    notifyListeners();
  }

  // --- PSQI Calculation ---
  int? finalPsqiScore;

  bool validateQ5() {
    return q5.entries
        .where((e) => e.key != 'j' || q5jOtherReason.trim().isNotEmpty)
        .every((e) => e.value != null);
  }

  bool validateQ6To10() {
    return q6 != null && 
           q7 != null && 
           q8 != null && 
           q9 != null && 
           q10.entries
              .where((e) => e.key != 'e' || q10eOtherReason.trim().isNotEmpty)
              .every((e) => e.value != null);
  }

  bool calculatePSQI() {
    if (bedtime == null || sleepLatencyMinutes == null || wakeUpTime == null || hoursSlept == null) return false;
    if (!validateQ5() || !validateQ6To10()) return false;

    // Component 1: Subjective sleep quality
    int comp1 = q6!;

    // Component 2: Sleep latency
    int q2Score = 0;
    if (sleepLatencyMinutes! <= 15) q2Score = 0;
    else if (sleepLatencyMinutes! <= 30) q2Score = 1;
    else if (sleepLatencyMinutes! <= 60) q2Score = 2;
    else q2Score = 3;

    int q5aScore = q5['a']!;
    int comp2Sum = q2Score + q5aScore;
    int comp2 = 0;
    if (comp2Sum == 0) comp2 = 0;
    else if (comp2Sum <= 2) comp2 = 1;
    else if (comp2Sum <= 4) comp2 = 2;
    else comp2 = 3;

    // Component 3: Sleep duration
    int comp3 = 0;
    if (hoursSlept! > 7) comp3 = 0;
    else if (hoursSlept! >= 6) comp3 = 1;
    else if (hoursSlept! >= 5) comp3 = 2;
    else comp3 = 3;

    // Component 4: Habitual sleep efficiency
    double bedTimeDecimal = bedtime!.hour + bedtime!.minute / 60.0;
    double wakeTimeDecimal = wakeUpTime!.hour + wakeUpTime!.minute / 60.0;
    double hoursInBed = wakeTimeDecimal - bedTimeDecimal;
    if (hoursInBed < 0) hoursInBed += 24; // Crossed midnight
    
    double efficiency = 0;
    if (hoursInBed > 0) {
      efficiency = (hoursSlept! / hoursInBed) * 100;
    }
    
    int comp4 = 0;
    if (efficiency >= 85) comp4 = 0;
    else if (efficiency >= 75) comp4 = 1;
    else if (efficiency >= 65) comp4 = 2;
    else comp4 = 3;

    // Component 5: Sleep disturbances
    int q5jScore = q5jOtherReason.trim().isNotEmpty ? (q5['j'] ?? 0) : 0;
    int comp5Sum = q5['b']! + q5['c']! + q5['d']! + q5['e']! + q5['f']! + q5['g']! + q5['h']! + q5['i']! + q5jScore;
    int comp5 = 0;
    if (comp5Sum == 0) comp5 = 0;
    else if (comp5Sum <= 9) comp5 = 1;
    else if (comp5Sum <= 18) comp5 = 2;
    else comp5 = 3;

    // Component 6: Use of sleeping medication
    int comp6 = q7!;

    // Component 7: Daytime dysfunction
    int comp7Sum = q8! + q9!;
    int comp7 = 0;
    if (comp7Sum == 0) comp7 = 0;
    else if (comp7Sum <= 2) comp7 = 1;
    else if (comp7Sum <= 4) comp7 = 2;
    else comp7 = 3;

    finalPsqiScore = comp1 + comp2 + comp3 + comp4 + comp5 + comp6 + comp7;
    notifyListeners();
    return true;
  }
}
