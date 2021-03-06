void mouseTimer(){
  if(hitDetect(mouseX,mouseY,5,5,pmouseX,pmouseY,5,5)){
    if(mouseTimerCounter<mouseTimerCounterMax){
      mouseTimerCounter++;
    }else{
      mouseTimerCounter=0;
      showGui=false;
    }
  }else{
    mouseTimerCounter=0;
    showGui=true;
  }
}

void mouseReleased(){
  vertexTargetOn = false;
  if (buttons[buttonLoadNum].clicked){
    doButtonLoad();
  }
  if (buttons[buttonReloadNum].clicked){
    doButtonReload();
  }
  if (buttons[buttonScreenNum].clicked){
    doButtonScreen();
  }
  if (buttons[buttonResetNum].clicked){
    doButtonReset();
  }
  if (buttons[buttonSaveNum].clicked){
    doButtonSave();
  }
}

void guiHandler(){
  mouseTimer();
  if(showGui){
    cursor();
    if(fs.isFullScreen()){
      try{ sprite.debug = true; }catch(Exception e){ }
    }else{
      try{ sprite.debug = false; }catch(Exception e){ }
    }
  }else{
    noCursor();
    try{ sprite.debug = false; }catch(Exception e){ }
  }
}

void moveVertices(){
      if(mousePressed && fs.isFullScreen()){
    PVector m = new PVector(mouseX,mouseY);
    for(int i=0;i<sprite.vertices_proj.length;i++){
      if(hitDetect(m.x,m.y,grabVerticesRange,grabVerticesRange,sprite.vertices_proj[i].x,sprite.vertices_proj[i].y,grabVerticesRange,grabVerticesRange)){
        vertexTargetOn=true;
        vertexTarget = i;
      }
    }
    if(vertexTargetOn){
      sprite.vertices[vertexTarget] = sprite.projToVert(m,sprite.p);
    }
  }
  }

void buttonSetup(){
  buttons[buttonLoadNum] = new Button(buttonOffset, buttonOffset, buttonSize, color(240, 10, 10), buttonFontSize, "load", "ellipse");
  buttons[buttonReloadNum] = new Button(buttonOffset * 2.25, buttonOffset, buttonSize, color(240, 240, 10), buttonFontSize, "refresh", "ellipse");
  buttons[buttonScreenNum] = new Button(buttonOffset * 3.5, buttonOffset, buttonSize, color(10, 240, 10), buttonFontSize, "screen", "rect");
  buttons[buttonResetNum] = new Button(buttonOffset * 4.75, buttonOffset, buttonSize, color(10, 240, 240), buttonFontSize, "reset", "ellipse");
  buttons[buttonSaveNum] = new Button(buttonOffset * 6, buttonOffset, buttonSize, color(10, 80, 240), buttonFontSize, "save", "ellipse");
}

void buttonHandler() {
  for (int i=0;i<buttons.length;i++) {
    buttons[i].checkButton();
    buttons[i].drawButton();
    if(buttons[i].hovered&&showTextHints){
      if(buttons[buttonLoadNum].hovered) sayText="Load a folder of images.";
      if(buttons[buttonReloadNum].hovered) sayText="Refresh the current folder.";
      if(buttons[buttonScreenNum].hovered) sayText="Toggle fullscreen mode.";
      if(buttons[buttonResetNum].hovered) sayText="Reset vertices.";
      if(buttons[buttonSaveNum].hovered) sayText="Save vertices.";
      noStroke();
      fill(255);
      textAlign(CORNER);
      text(sayText,buttonOffset/1.75, buttonSize*2);
    }
  }
}

void buttonsRefresh() {
  for (int i=0;i<buttons.length;i++) {
    buttons[i].clicked = false;
  }
}

void doButtonLoad(){
  firstRun=true;
  doInitSprite = true;
  if(!buttons[buttonLoadNum].grayed){
  doButtonStop();
    try{
    chooseFolderDialog();
    delay(saveDelayInterval);
    modeImg = true;
    //bvhBegin();
  }catch(Exception e){
    doButtonStop();
  }
}
}

void doButtonReload(){
  try{
    countFrames(folderPath);
  }catch(Exception e){ 
    println("error reloading images");
  }
}

void doButtonSave(){
  try{
    settings.writeSettings("settings.txt");
  }catch(Exception e){ 
    println("error saving vertex info");
  }
}

void doButtonReset(){
  try{
    initSprite();
  }catch(Exception e){ 
    println("error resetting vertices");
  }
}

void doButtonScreen(){
  doButtonStop();
  try{
    if(fs.isFullScreen()){
      fs.leave();
      buttons[buttonLoadNum].grayed = false;
    }else if(!fs.isFullScreen()){
      fs.enter();
      buttons[buttonLoadNum].grayed = true;
    }
  }catch(Exception e){
    doButtonStop();
  }
}

void doButtonStop(){
  //
}

void chooseFolderDialog(){
    folderPath = selectFolder();  // Opens file chooser
    if (folderPath == null) {
      // If a folder was not selected
      println("No folder was selected...");
    } else {
      println(folderPath);
      countFrames(folderPath);
    }
}

void countFrames(String usePath) {
    imgNames = new ArrayList();
    //loads a sequence of frames from a folder
    dataFolder = new File(usePath); 
    String[] allFiles = dataFolder.list();
    for (int j=0;j<allFiles.length;j++) {
      if (
        allFiles[j].toLowerCase().endsWith("png") ||
        allFiles[j].toLowerCase().endsWith("jpg") ||
        allFiles[j].toLowerCase().endsWith("jpeg") ||
        allFiles[j].toLowerCase().endsWith("gif") ||
        allFiles[j].toLowerCase().endsWith("tga")){
          imgNames.add(usePath+"/"+allFiles[j]);
        }
    }
    imgLoader();
    if(doInitSprite) initSprite();
    doInitSprite = false;
}

void keyPressed(){
  if(key==' ' || keyCode==34){
    try{
    if(imgCounter<imgNames.size()-1){
      imgCounter++;
    }else{
      imgCounter=0;
    } 
    imgLoader();
    }catch(Exception e){ }
  }

  if(keyCode==33){
    try{
    if(imgCounter>0){
      imgCounter--;
    }else{
      imgCounter=imgNames.size()-1;
    } 
    imgLoader();
    }catch(Exception e){ }
  }
  
  if(keyCode==9){
    if(showGui){
      mouseTimerCounter=0;
      showGui = false;
    }else{
      mouseTimerCounter=0;
      showGui = true;
    }
  }
}

void imgLoader(){
  try{
    img[0] = loadImage((String) imgNames.get(imgCounter));
  }catch(Exception e){ }
}

void console(){
  if(debug){
      //try{ println(sprite.vertices[0] + " " + sprite.vertices_proj[0]); }catch(Exception e){ }
  }
}

