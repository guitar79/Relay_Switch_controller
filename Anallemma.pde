import processing.serial.*;  
import controlP5.*;
import javax.swing.*;
Serial port;

ControlP5 cp5;

Textfield P;
Textfield I;
Textfield D;
Textfield targetAngle;

String stringP = "";
String stringI = "";
String stringD = "";
String stringTargetAngle = "";

PFont f;

boolean useDropDownLists = true; // Set if you want to use the dropdownlist or not
byte defaultComPort = 0;
int defaultBaudrate = 115200;

int ROpen_hh = 23 ;
int ROpen_mm= 5 ;
int ROpen_ss = 00 ;
int RClose_hh = 4 ;
int RClose_mm= 00 ;
int RClose_ss = 00 ;

//Dialog
int messageBoxResult = -1;



//Dropdown lists
DropdownList COMports; // Define the variable ports as a Dropdownlist.
Serial serial; // Define the variable port as a Serial object.
int portNumber = -1; // The dropdown list will return a float value, which we will connvert into an int. We will use this int for that.

DropdownList baudrate;
int selectedBaudrate = -1; // Used to indicate which baudrate has been selected
String[] baudrates = {
  "1200", "2400", "4800", "9600", "19200", "38400", "57600", "115200" // these are the supported baudrates by a module
};

DropdownList ROpen_HH;
int selectedOH = -1; // Used to indicate which baudrate has been selected
String[] OH = {
  "00", "01", "02", "03", "04", "05" // Open Hour
};

boolean connectedSerial;
boolean aborted;
boolean isPressedCh1Button = false;
boolean isPressedCh2Button = false;
boolean isPressedCh3Button = false;
boolean isPressedCh4Button = false;
boolean isPressedCh5Button = false;
//boolean isPressedCh6Button = false;
//boolean isPressedCh7Button = false;
//boolean isPressedCh8Button = false;
boolean isPressedautoButton = false;

// schduling

int status_text_x = 300 ;
int status_text_y = 32 ;
int ch_button_x0 = 20 ;
int ch_button_y0 = 300 ;
int ch_button_w = 90 ;
int ch_button_h = 70 ;
// schduling

int start_hh = 23 ;
int start_mm= 5 ;
int start_ss = 00 ;

void setup()
{
  try { 
    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
  } 
  catch (Exception e) { 
    e.printStackTrace();
  } 
  
  cp5 = new ControlP5(this);
  size(550, 650);

  f = loadFont("Arial-BoldMT-30.vlw");
  textFont(f, 30);
  
 //println(serial.list()); // Used for debugging
  if (useDropDownLists)
  {
    /* Drop down lists */
    COMports = cp5.addDropdownList("COMPort", 20, 70, 100, 200); // Make a dropdown list with all comports
    customize(COMports); // Setup the dropdownlist by using a function

    baudrate = cp5.addDropdownList("Baudrate", 120, 70, 55, 200); // Make a dropdown with all the available baudrates   
    customize(baudrate); // Setup the dropdownlist by using a function

    ROpen_HH = cp5.addDropdownList("OH", 385, 98, 25, 200); // Make a dropdown with all the available RoofOpen   
    customize(ROpen_HH); // Setup the dropdownlist by using a function

    cp5.addButton("Connect", 0, 185, 70, 52, 15);
    cp5.addButton("Disconnect", 0, 185, 88, 52, 15);
  }
  else // if useDropDownLists is false, it will connect automatically at startup
  {
    serial = new Serial(this, Serial.list()[defaultComPort], defaultBaudrate);
    serial.bufferUntil('\n');
    connectedSerial = true;
    serial.write("G;"); // Go
  }
  background(0);
  cp5.addButton("ch1_on")
     .setPosition(ch_button_x0+ch_button_w*0,ch_button_y0)
     .setSize(80,20)
     ;
  cp5.addButton("ch1_off")
     .setPosition(ch_button_x0+ch_button_w*1,ch_button_y0)
     .setSize(80,20)
     ;
  cp5.addToggle("on1/off1")
     .setPosition(ch_button_x0+ch_button_w*2,ch_button_y0)
     .setSize(50,20)
     ;
  cp5.addButton("Bulb_on")
     .setPosition(ch_button_x0+ch_button_w*0,ch_button_y0+ch_button_h*1)
     .setSize(80,20)
     ;
  cp5.addButton("Bulb_off")
     .setPosition(ch_button_x0+ch_button_w*1,ch_button_y0+ch_button_h*1)
     .setSize(80,20)
     ;
  cp5.addToggle("on2/off2")
     .setPosition(ch_button_x0+ch_button_w*2,ch_button_y0+ch_button_h*1)
     .setSize(50,20)
     ;
  cp5.addButton("One_shot")
  .setPosition(ch_button_x0+ch_button_w*0,ch_button_y0+ch_button_h*1+25)
  .setSize(80,20)
     ;
  /*
  cp5.addButton("ch3_on")
     .setPosition(ch_button_x0,ch_button_y0+ch_button_h*2)
     .setSize(80,20)
     ;
  cp5.addButton("ch3_off")
     .setPosition(ch_button_x0+ch_button_w*1,ch_button_y0+ch_button_h*2)
     .setSize(80,20)
     ;
  cp5.addToggle("on3/off3")
     .setPosition(ch_button_x0+ch_button_w*2,ch_button_y0+ch_button_h*2)
     .setSize(50,20)
     ;
  */
  cp5.addButton("ch4_on")
     .setPosition(ch_button_x0+ch_button_w*0,ch_button_y0+ch_button_h*3)
     .setSize(80,20)
     ;
  cp5.addButton("ch4_off")
    .setPosition(ch_button_x0+ch_button_w*1,ch_button_y0+ch_button_h*3)
     .setSize(80,20)
     ;
  cp5.addToggle("on4/off4")
     .setPosition(ch_button_x0+ch_button_w*2,ch_button_y0+ch_button_h*3)
     .setSize(50,20)
     ;    
  cp5.addButton("ch5_on")
     .setPosition(ch_button_x0+ch_button_w*0,ch_button_y0+ch_button_h*4)
     .setSize(80,20)
     ;
  cp5.addButton("ch5_off")
     .setPosition(ch_button_x0+ch_button_w*1,ch_button_y0+ch_button_h*4)
     .setSize(80,20)
     ;
  cp5.addToggle("on5/off5")
          .setPosition(ch_button_x0+ch_button_w*2,ch_button_y0+ch_button_h*4)
     .setSize(50,20)
     ;
  cp5.addButton("ch6_on")
  .setPosition(ch_button_x0+250+ch_button_w*0,ch_button_y0+ch_button_h*0+22)
     .setSize(80,20)
     ;
/* 
cp5.addButton("ch6_off")
.setPosition(ch_button_x0+ch_button_w*1,ch_button_y0+ch_button_h*4)
     .setSize(80,20)
     ;
  cp5.addToggle("on6/off6")
     .setPosition(ch_button_x0+ch_button_w*2,ch_button_y0+ch_button_h*4)
     .setSize(50,20)
     ;
*/
  cp5.addButton("ch7_on")
     .setPosition(ch_button_x0+250+ch_button_w*1,ch_button_y0+ch_button_h*0+22)
     .setSize(80,20)
     ;
/*
  cp5.addButton("ch7_off")
     .setPosition(ch_button_x0+260+ch_button_w*1,ch_button_y0+ch_button_h*1)
     .setSize(80,20)
     ;
  cp5.addToggle("on7/off7")
     .setPosition(ch_button_x0+260+ch_button_w*2,ch_button_y0+ch_button_h*1)
     .setSize(50,20)
     ;
*/
  cp5.addButton("ch8_on")
  .setPosition(ch_button_x0+250+ch_button_w*2,ch_button_y0+ch_button_h*0+22)
     .setSize(80,20)
     ;
/*
  cp5.addButton("ch8_off")
  .setPosition(ch_button_x0+260+ch_button_w*1,ch_button_y0+ch_button_h*2)
     .setSize(80,20)
     ;
  cp5.addToggle("on8/off8")
  .setPosition(ch_button_x0+260+ch_button_w*2,ch_button_y0+ch_button_h*2)
     .setSize(50,20)
     ;
*/
 cp5.addButton("auto_on")
     .setPosition(ch_button_x0+260+ch_button_w*0,ch_button_y0+ch_button_h*3)
     .setSize(80,20)
     ;
  cp5.addButton("auto_off")
     .setPosition(ch_button_x0+260+ch_button_w*1,ch_button_y0+ch_button_h*3)
     .setSize(80,20)
     ;
  cp5.addToggle("on_auto/off_auto")
     .setPosition(ch_button_x0+260+ch_button_w*2,ch_button_y0+ch_button_h*3)
     .setSize(50,20)
     ;  

    textSize(14);
    text("Anallemma Camera Power control", 20, ch_button_y0+ch_button_h*0-10);
    text("Anallemma Camera Shutter", 20, ch_button_y0+ch_button_h*1-10);
    text("Astronomical CCD Power control", 20, ch_button_y0+ch_button_h*3-10);
    text("Motor focuser Power control", 20, ch_button_y0+ch_button_h*4-10);
    text("Roof control", 272+ch_button_w*0, ch_button_y0+ch_button_h*0-10);
    text("Open", 290+ch_button_w*0, ch_button_y0+ch_button_h*0+15);
    text("Close", 290+ch_button_w*1, ch_button_y0+ch_button_h*0+15);
    text("Stop", 290+ch_button_w*2, ch_button_y0+ch_button_h*0+15);
    text("Anallemma Automation", 272+ch_button_w*0, ch_button_y0+ch_button_h*3-10);     

}


void Abort(int theValue)
{
  if (connectedSerial) 
  {
    serial.write("A;");
    aborted = true;
  }
  else
    println("Establish a serial connection first!");
}
void Continue(int theValue)
{
  if (connectedSerial) 
  {
    serial.write("C;");
    aborted = false;
    background(100);
  }
  else
    println("Establish a serial connection first!");
}
void Submit(int theValue) 
{
  if (connectedSerial)
  {    
      delay(10);    
  }
  else
    println("Establish a serial connection first!");
}

void serialEvent(Serial serial)
{
  
}
void keyPressed() 
{
  
}
void customize(DropdownList ddl) 
{
  ddl.setBackgroundColor(color(200));//Set the background color of the line between values
  ddl.setItemHeight(20);//Set the height of each item when the list is opened.
  ddl.setBarHeight(15);//Set the height of the bar itself.

  ddl.getCaptionLabel().getStyle().marginTop = 3;//Set the top margin of the lable.  
  ddl.getCaptionLabel().getStyle().marginLeft = 3;//Set the left margin of the lable.  
  ddl.getCaptionLabel().getStyle().marginTop = 3;//Set the top margin of the value selected.

  if (ddl.getName() == "Baudrate")
  {
    ddl.getCaptionLabel().set("Baudrate");
    for (int i=0; i<baudrates.length; i++)
      ddl.addItem(baudrates[i], i); // give each item a value
  }
  else if (ddl.getName() == "COMPort")
  {
    ddl.getCaptionLabel().set("Select COM port");//Set the lable of the bar when nothing is selected. 
    //Now well add the ports to the list, we use a for loop for that.
    for (int i=0; i<serial.list().length; i++)    
      ddl.addItem(serial.list()[i], i);//This is the line doing the actual adding of items, we use the current loop we are in to determin what place in the char array to access and what item number to add it as.
  }
  ddl.setColorBackground(color(60));
  ddl.setColorActive(color(255, 128));
}
void controlEvent(ControlEvent theEvent) {
  if (theEvent.isGroup()) {
    println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
  } 
  else if (theEvent.isController()) {
    if (theEvent.getName() == "COMPort")
          portNumber = int(theEvent.getController().getValue());
    else if(theEvent.getName() == "Baudrate")
          selectedBaudrate = int(theEvent.getController().getValue());
  }
}

void Connect(int theValue)
{
  println("port Num = " + Serial.list()[portNumber]);
  if (selectedBaudrate != -1 && portNumber != -1 && !connectedSerial)//Check if com port and baudrate is set and if there is not already a connection established
  {
    println("ConnectSerial");
    background(100);
    fill(255,255,255);
    textAlign(LEFT);
    text("Serial connected", 20, 60);
  
    serial = new Serial(this, Serial.list()[portNumber], Integer.parseInt(baudrates[selectedBaudrate]));
    connectedSerial = true;
    serial.bufferUntil('\n');
    serial.write("G;"); // Go
  }
  else if (portNumber == -1)
    println("Select COM Port first!");
  else if (selectedBaudrate == -1)
    println("Select baudrate first!");
  else if (connectedSerial)
    println("Already connected to a port!");
}

void Disconnect(int theValue)
{
  if (connectedSerial)//Check if there is a connection established
  {
     serial.stop();
     serial = null;
     connectedSerial = false;
     background(0); // background color change by Kevin
    fill(255,255,255);
    text("Serial disconnected", 80, 60);
  
    println("Serial disconnected");
  }
  else
    println("Couldn't disconnect");
}

public void ch1_on() {
  if (isPressedCh1Button && connectedSerial) {
    serial.write('q'); println("type 'q'");
    fill(255); textSize(11); rect(status_text_x-50,15,100,25); fill(0); text("Ch1 on", status_text_x, status_text_y);
  } else if (!isPressedCh1Button && connectedSerial) {
    serial.write('q'); println("type 'q'");    
  fill(255); textSize(11); rect(status_text_x-50,15,100,25); fill(0); text("Ch1 on", status_text_x, status_text_y);
  }
  isPressedCh1Button = !isPressedCh1Button;
    ((Toggle)cp5.getController("on1/off1")).setState(true);
      messageBoxResult = -1;
}

public void ch1_off() {
  createModalDialog("Ch1 off");
  if (messageBoxResult >= 1)
    return;
  if (isPressedCh1Button && connectedSerial) {
    serial.write('a'); println("type 'a'");
    fill(255); textSize(11); rect(status_text_x-50,15,100,25); fill(0); text("Ch1 off", status_text_x, status_text_y);
  } else if (!isPressedCh1Button && connectedSerial) {
    serial.write('a'); println("type 'a'");
    fill(255); textSize(11); rect(status_text_x-50,15,100,25); fill(0); text("Ch1 off", status_text_x, status_text_y);
  }
  isPressedCh1Button = !isPressedCh1Button;
    ((Toggle)cp5.getController("on1/off1")).setState(false);
      messageBoxResult = -1;
}

/* 
public void ch2_on() { 
  if (isPressedCh2Button && connectedSerial) {
    serial.write('w'); println("type 'w'");
    fill(255); textSize(11); rect(status_text_x-50,15,100,25); fill(0); text("Ch2 on", status_text_x, status_text_y);
  } else if (!isPressedCh2Button && connectedSerial) {
    serial.write('w'); println("type 'w'");
    fill(255); textSize(11); rect(status_text_x-50,15,100,25); fill(0); text("Ch2 on", status_text_x, status_text_y);
  }
  isPressedCh2Button = !isPressedCh2Button;
  ((Toggle)cp5.getController("on2/off2")).setState(true);
     messageBoxResult = -1;
}


public void ch2_off() {
  createModalDialog("ch2 off");
  if (messageBoxResult >= 1)
    return;
  if (isPressedCh2Button && connectedSerial) {
    serial.write('s');
    fill(255); textSize(11); rect(status_text_x-50,15,100,25); fill(0); text("Ch2 off", status_text_x, status_text_y);
  } else if (!isPressedCh2Button && connectedSerial) {
    serial.write('s');
    fill(255); textSize(11); rect(status_text_x-50,15,100,25); fill(0); text("Ch2 off", status_text_x, status_text_y);
  }
  isPressedCh2Button = !isPressedCh2Button;
    ((Toggle)cp5.getController("on2/off2")).setState(false);
   
   messageBoxResult = -1;
}   
*/
public void One_shot() { //One shot
  if (isPressedCh2Button && connectedSerial) {
    serial.write('x'); println("type 'x'");
    fill(255); textSize(11); rect(status_text_x-50,15,100,25); fill(0); text("One shot", status_text_x, status_text_y);
  } else if (!isPressedCh2Button && connectedSerial) {
    serial.write('x'); println("type 'x'");
    fill(255); textSize(11); rect(status_text_x-50,15,100,25); fill(0); text("One shot", status_text_x, status_text_y);
  }
  isPressedCh2Button = !isPressedCh2Button;
    ((Toggle)cp5.getController("on2/off2")).setState(false);
       messageBoxResult = -1;
}
public void Bulb_on() { //Bulb shot start
  if (isPressedCh2Button && connectedSerial) {
    serial.write('w'); println("type 'w'");
    fill(255); textSize(11); rect(status_text_x-50,15,100,25); fill(0); text("Bulb shot on", status_text_x, status_text_y);
    } else if (!isPressedCh2Button && connectedSerial) {
        serial.write('w'); println("type 'w'");
    fill(255); textSize(11); rect(status_text_x-50,15,100,25); fill(0); text("Bulb shot on", status_text_x, status_text_y);
  }
  isPressedCh2Button = !isPressedCh2Button;
  ((Toggle)cp5.getController("on2/off2")).setState(true);
     messageBoxResult = -1;
}
public void Bulb_off() { //Bulb shot stop
  if (isPressedCh2Button && connectedSerial) {
    serial.write('s'); println("type 's'");
    fill(255); textSize(11); rect(status_text_x-50,15,100,25); fill(0); text("Bulb shot off", status_text_x, status_text_y);
    } else if (!isPressedCh2Button && connectedSerial) {
        serial.write('s'); println("type 's'");
    fill(255); textSize(11); rect(status_text_x-50,15,100,25); fill(0); text("Bulb shot off", status_text_x, status_text_y);
  }
  isPressedCh2Button = !isPressedCh2Button;
  ((Toggle)cp5.getController("on2/off2")).setState(true);
     messageBoxResult = -1;
}
public void ch3_on() {
  if (isPressedCh3Button && connectedSerial) {
    serial.write('e');
    textSize(11); text("Ch3 on", status_text_x, status_text_y);
  } else if (!isPressedCh3Button && connectedSerial) {
    serial.write('e');
  }
  isPressedCh3Button = !isPressedCh3Button;
  textSize(11); text("Ch3 on", status_text_x, status_text_y);
    ((Toggle)cp5.getController("on3/off3")).setState(true);
       messageBoxResult = -1;
}

public void ch3_off() {
  createModalDialog("Ch3 off");
   if (messageBoxResult >= 1)
    return;
  if (isPressedCh3Button && connectedSerial) {
    serial.write('d'); println("type 'd'");
    textSize(11); text("Ch3 off", status_text_x, status_text_y);
  } else if (!isPressedCh3Button && connectedSerial) {
    serial.write('d'); println("type 'd'");
    textSize(11); text("Ch3 off", status_text_x, status_text_y);
  }
  isPressedCh3Button = !isPressedCh3Button;
    ((Toggle)cp5.getController("on3/off3")).setState(false);
       messageBoxResult = -1;
}

public void ch4_on() {
  if (isPressedCh4Button && connectedSerial) {
    serial.write('r'); println("type 'r'");
    fill(255); textSize(11); rect(status_text_x-50,15,100,25); fill(0); text("Ch4 on", status_text_x, status_text_y);
  } else if (!isPressedCh4Button && connectedSerial) {
    serial.write('r'); println("type 'r'");
    fill(255); textSize(11); rect(status_text_x-50,15,100,25); fill(0); text("Ch4 on", status_text_x, status_text_y);
  }
  isPressedCh4Button = !isPressedCh4Button;
    ((Toggle)cp5.getController("on4/off4")).setState(true);
       messageBoxResult = -1;
}

public void ch4_off() {
  createModalDialog("Ch4 off");
   if (messageBoxResult >= 1)
    return;
  if (isPressedCh4Button && connectedSerial) {
    serial.write('f'); println("type 'f'");
    fill(255); textSize(11); rect(status_text_x-50,15,100,25); fill(0); text("Ch4 off", status_text_x, status_text_y);
  } else if (!isPressedCh4Button && connectedSerial) {
    serial.write('f'); println("type 'f'");
    fill(255); textSize(11); rect(status_text_x-50,15,100,25); fill(0); text("Ch4 off", status_text_x, status_text_y);
  }
  isPressedCh4Button = !isPressedCh4Button;
    ((Toggle)cp5.getController("on4/off4")).setState(false);
       messageBoxResult = -1;
}

public void ch5_on() {
  if (isPressedCh5Button && connectedSerial) {
    serial.write('t'); println("type 't'");
    fill(255); textSize(11); rect(status_text_x-50,15,100,25); fill(0); text("Ch5 on", status_text_x, status_text_y);
  } else if (!isPressedCh5Button && connectedSerial) {
    serial.write('t'); println("type 't'");
    fill(255); textSize(11); rect(status_text_x-50,15,100,25); fill(0); text("Ch5 on", status_text_x, status_text_y);
  }
  isPressedCh5Button = !isPressedCh5Button;
    ((Toggle)cp5.getController("on5/off5")).setState(true);
       messageBoxResult = -1;
}

public void ch5_off() {
  createModalDialog("Ch5 off");
   if (messageBoxResult >= 1)
    return;
  if (isPressedCh5Button && connectedSerial) {
    serial.write('g'); println("type 'g'");
    fill(255); textSize(11); rect(status_text_x-50,15,100,25); fill(0); text("Ch5 off", status_text_x, status_text_y);
  } else if (!isPressedCh5Button && connectedSerial) {
    serial.write('g'); println("type 'g'");
    fill(255); textSize(11); rect(status_text_x-50,15,100,25); fill(0); text("Ch5 off", status_text_x, status_text_y);
  }
  isPressedCh5Button = !isPressedCh5Button;
    ((Toggle)cp5.getController("on5/off5")).setState(false);
       messageBoxResult = -1;
}
public void ch6_on() {
  if (connectedSerial) {
    serial.write('y'); println("type 'y'");
    fill(255); textSize(11); rect(status_text_x-50,15,100,25); fill(0); text("Roof open", status_text_x, status_text_y);
  }
}
public void ch7_on() {
  if (connectedSerial) {
    serial.write('u'); println("type 'u'");
    fill(255); textSize(11); rect(status_text_x-50,15,100,25); fill(0); text("Roof close", status_text_x, status_text_y);
  }
}

public void ch8_on() {
  if (connectedSerial) {
          serial.write('i'); println("type 'i'");
    fill(255); textSize(11); rect(status_text_x-50,15,100,25); fill(0); text("Roof stop", status_text_x, status_text_y);

}
}

void createModalDialog(String message) {
    messageBoxResult = JOptionPane.showConfirmDialog(frame, message);

}
/*
public void auto_on() {
int hh = hour();
int mm= minute();
int ss = second();

int mms=millis();
  if (isPressedautoButton && connectedSerial && start_hh==hh && start_mm==mm && start_ss==ss )  
        {
        ch6_on();
        }
    if(isPressedautoButton && connectedSerial && start_hh==hh-3 && start_mm == mm && start_ss == ss )  
       {
        ch7_on();
      }
    if (isPressedautoButton && connectedSerial && (ss%15==0))
    {
      One_shot();
  } else if (!isPressedautoButton && connectedSerial) {
  
  }
  isPressedautoButton = !isPressedautoButton;
    ((Toggle)cp5.getController("auto")).setState(true);
       messageBoxResult = -1;
}

public void auto_off() {
  createModalDialog("auto off");
   if (messageBoxResult >= 1)
    return;
  if (isPressedautoButton && connectedSerial) {
  } else if (!isPressedautoButton && connectedSerial) {
  }
  isPressedautoButton = !isPressedautoButton;
    ((Toggle)cp5.getController("task")).setState(false);
       messageBoxResult = -1;
}
*/

void draw(){
  int y= year();
  int m = month();
  int d = day();
  int hh = hour();
  int mm= minute();
  int ss = second();
  beattime(hh, mm, ss);
}


void beattime(int hh, int mm, int ss){
  fill(255);
  rect(275,70,180,20);
  fill(0);
  textFont(f,20);
  textAlign(LEFT);
  textSize(13);
  text("Com Clock        "+ hh +" : "+ mm +" : "+ss, 285, 85);
  fill(255);
  rect(275,95,180,20);
  rect(275,120,180,20);
  fill(0);
  textFont(f,20);
  textAlign(LEFT);
  textSize(13);
  text("Roof Open time    "+ ROpen_hh +" : "+ ROpen_mm +" : "+ ROpen_ss, 285, 110);
  text("Roof Close time   "+ RClose_hh +" : "+ RClose_mm +" : "+ RClose_ss, 285, 135);

  int mms=millis();
//  if (isPressedautoButton && connectedSerial && start_hh==hh && start_mm==mm && start_ss==ss )
  if (connectedSerial && ROpen_hh==hh && ROpen_mm==mm && ROpen_ss==ss ) {
    ch6_on(); //open
  }
  if(connectedSerial && RClose_hh==hh-3 && RClose_mm == mm && RClose_ss == ss ) {
    ch7_on();  //close
  }
  if (connectedSerial && (ss==0) || (ss==15) || (ss==30) || (ss==45)) {
    One_shot();
    println(ss);
  } else if (!isPressedautoButton && connectedSerial) {
  
  }

}