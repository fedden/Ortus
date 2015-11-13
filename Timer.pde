class Timer
{
  //when timer started
  int savedMillis;
  //how much time is left! (this goes downwards)
  int showMinute;
  int showSecond;
  //is the timer on?
  boolean on, playSound;

  //set timer length in constructor
  Timer(int _min, int _sec)
  {
    changeLength(_min, _sec);
    on = false;
    println("timer created!");
  }

  void changeLength(int _min, int _sec)
  {
    showMinute = _min;
    showSecond = _sec;
  }

  //starting the timer
  void start()
  {
    //when the timer starts it stores the current time
    savedMillis = millis();
    playSound = on = true;
  }

  void update()
  {
    //if time does not equal 0min, 0secs, iterate through time
    if ((showSecond > 0) || (showMinute > 0)) 
    {
      if ((millis() - savedMillis >= 1000) && (on))
      {
        showSecond--;
        savedMillis = millis();
        if (showSecond < 0)
        {
          showSecond = 59;
          showMinute--;
        }
      } 
    } else {
      //set time as 0 mins and secs for display
      if (playSound == true) {
        meditation.cue(0);
        meditation.play();
        playSound = false;
      }
      showSecond = 0;
      showMinute = 0;
      
    }
  }

  boolean isFinished()
  { 
    if ((showMinute == 0) && (showSecond == 0))
    {
      return true;
    } else {
      return false;
    }
  }

  String timeLeft()
  {
    String min = (showMinute < 10) ? "0" + str(showMinute) : str(showMinute);
    String sec = (showSecond < 10) ? "0" + str(showSecond) : str(showSecond);
    return min + ":" + sec;
  }
}

