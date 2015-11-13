
Routine routine; 
Maxim maxim;
AudioPlayer meditation, alarm;

int alpha;

boolean paused, debug;

PImage background;

color green = #3E92A3;
color neutral = #DFE0D4;
color red = #FF5335;
color black = #353940;

void setup()
{ 
  size(600, 700);
  debug = false;
  alpha = 140;

  //background
  int number = round(random(1, 27));
  background = loadImage(number+".jpeg");
  if (background.width > background.height) {
    background.resize(0, height);
  } else if (background.width < background.height) {
    background.resize(width, 0);
  } else {
    background.resize(0, height);
  }
  imageMode(CENTER);

  //backbone of app
  routine = new Routine();

  //sound
  maxim = new Maxim(this);

  meditation = maxim.loadFile("bell.wav");
  meditation.setLooping(false);
  meditation.volume(0.8);

  alarm = maxim.loadFile("calm.wav");
  alarm.setLooping(true);
  alarm.volume(1.4);

  alarm.cue(0);
  alarm.play();
  
  paused = false;
  
  frameRate(8);
}

void draw()
{
  
  background(neutral);
  tint(255, 180);
  image(background, width/2, height/2);
  noStroke();
  noTint();
  fill(black, alpha);
  rect(width/2, 0, width, 200);
  routine.run();
  routine.display();
  
  
}

void mouseReleased()
{
  
  
  switch (routine.subroutines[routine.currentIndex].returnRoutineType()) {
  case 0:
    if (routine.doneButton.mouseOver()) {
      routine.doneButtonPressed();
    }
    break;

  case 1:
    if (routine.rest) {
      if (routine.ready.mouseOver())
      {
        routine.rest = false;
      }
    } else { 
      if (routine.hard.mouseOver())
      {
        routine.restLength = (debug) ? 0 : 45;
        routine.updateExercise(0);
        routine.doneButtonPressed();   
        //
      } else if (routine.okay.mouseOver()) 
      {
        routine.restLength = (debug) ? 0 : 30;
        routine.doneButtonPressed();
        //
      } else if (routine.easy.mouseOver())
      {
        routine.restLength = (debug) ? 0 : 15;
        routine.updateExercise(1);
        routine.doneButtonPressed(); 
        //
      }
    }
    break;

  case 2:
    if (routine.loadLink.mouseOver()) 
    {
      link(routine.subroutines[routine.currentIndex].returnHyperlink());
      //
    } else if (routine.completed.mouseOver()) 
    {
      routine.subroutines[routine.currentIndex].updateCurrentModule(); //saves and uploads to the table
      routine.subroutines[routine.currentIndex].moduleNo++; //
      String currentSyllabus = routine.subroutines[routine.currentIndex].descriptor + ".csv";
      routine.subroutines[routine.currentIndex+1].loadCurrentModule(currentSyllabus);
      //
    } else if (routine.notCompleted.mouseOver())
    {
      routine.doneButtonPressed(); 
      //
    }
    break;
  }
}

