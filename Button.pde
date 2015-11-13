class Button {
  boolean hasIcon, wasClicked; //does the button use an icon
  PVector position; //where is it on screen
  String descriptor; //what does the text on it say
  color rest, mouseOver, clicked, border, textColour; //colours that comprise the button
  PShape icon; //tick or a cross svg
  int buttonWidth, buttonHeight, cornerRoundness, normalPos, overPos, clickedPos; //width, height, width of border and roundness of corners
  float borderWidth, fontSize;
  PFont font; //pretty straight forward

  //contructor
  Button(String _descriptor, int _x, int _y, int _width, int _height, int _roundedAmt, float _borderWidth)
  {
    hasIcon = wasClicked = false;
    descriptor = _descriptor;
    position = new PVector(_x, _y);
    buttonWidth = _width;
    buttonHeight = _height;
    borderWidth = _borderWidth;
    fontSize = buttonHeight/3;
    font = createFont("bold.otf", fontSize);
    cornerRoundness = _roundedAmt;
    normalPos = _y;
    overPos = _y + 1;
    clickedPos = _y + 3;
  }
  
  Button(String _descriptor, int _x, int _y, int _width, int _height, int _roundedAmt, float _borderWidth, String _font)
  {
    hasIcon = wasClicked = false;
    descriptor = _descriptor;
    position = new PVector(_x, _y);
    buttonWidth = _width;
    buttonHeight = _height;
    borderWidth = _borderWidth;
    fontSize = 2*buttonHeight/3;
    font = createFont(_font, fontSize);
    cornerRoundness = _roundedAmt;
  }

  void setColours(color _rest, color _mouseOver, color _clicked, color _border, color _textColour)
  {
    rest = _rest;
    mouseOver = _mouseOver;
    clicked = _clicked;
    border = _border;
    textColour = _textColour;
  }

  void setIcon(String _name)
  {
    hasIcon = true;
    icon = loadShape(_name);
    icon.disableStyle(); //make malleable
  }


  void display()
  {
    rectMode(CENTER);   
    strokeWeight(borderWidth);
    stroke(border);
    fill(black);
    rect(position.x, normalPos + 5, buttonWidth, buttonHeight, cornerRoundness);
    //set colour depending on mouse events and location
    if (!mouseOver())
    {
      wasClicked = false;
      fill(rest);
      position.y = normalPos;
    } else if (mouseOver() && !mousePressed)
    {
      wasClicked = false;
      fill(mouseOver);
      position.y = overPos;
    } else if (mouseOver() && mousePressed)
    {
      wasClicked = true;
      fill(clicked);
      position.y = clickedPos;
      println(descriptor + " was clicked!");
    }
    
    rect(position.x, position.y, buttonWidth, buttonHeight, cornerRoundness);
    if (hasIcon)
    {
      strokeWeight(1);
      stroke(255, 60);
      shapeMode(CENTER);
      shape(icon, position.x + buttonWidth/4, position.y, 2*buttonHeight/3, 2*buttonHeight/3);
      fill(textColour);
      textAlign(RIGHT);
      textFont(font);
      text(descriptor, position.x, position.y+fontSize/3);
    } else {
      fill(textColour);
      textAlign(CENTER);
      textFont(font);
      text(descriptor, position.x, position.y+fontSize/3);
    }    
  }

  void spring(PVector _start, PVector _end, int _elasticity)
  {
  }

  boolean mouseOver()
  {
    if ((mouseX<position.x+buttonWidth/2)&&(mouseX>position.x-buttonWidth/2)&&(mouseY<position.y+buttonHeight/2)&&(mouseY>position.y-buttonHeight/2)) {
      return true;
    } else {
      return false;
    }
  }
  
  boolean wasClicked()
  {
    if (wasClicked) {
      return true;
    } else {
      return false;
    }
  }   
}
