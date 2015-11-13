class QuickJob extends RoutineBase
{
  //constructor
  QuickJob(String _d, int _r, int _tHour, int _tMinute, int _aHour, int _aMinutes)
  {
    super(_d, _r, _tHour, _tMinute, _aHour, _aMinutes);
  }
  
  String returnCurrent()
  {
    return descriptor;
  }
  
  int returnRoutineType()
  {
    return 0;
  }
}
