import 'package:rxdart/rxdart.dart';

class CounterBloc {
  int initialCount; // Parameter without default value
  late BehaviorSubject<int> _subjectCounter; // Mark as late

  // Constructor with required initialCount
  CounterBloc({required this.initialCount}) {
    _subjectCounter = BehaviorSubject<int>.seeded(this.initialCount); // Initialize here
  }

  // Stream to access the counter value
  Stream<int> get counterObservable => _subjectCounter.stream; 

  // Update the counter value and emit to stream
  void setCount(int count) {
    initialCount = count;
    _subjectCounter.sink.add(initialCount);
  }

  // Dispose method to close the subject when no longer needed
  void dispose() {
    _subjectCounter.close();
  }
}
