import java.awt.*;
import java.awt.event.*;
import java.awt.event.KeyEvent;
import java.awt.CheckboxMenuItem;
import processing.awt.PSurfaceAWT;
import processing.sound.*;

int squareSize, squareX, squareY, squareXCorner, squareYCorner, cellSize;
int fileButtonWidth, fileButtonHeight, fileButtonX, fileButtonY;
int checkButtonWidth, checkButtonHeight, checkButtonX, checkButtonY;

SudokuGrid sudoku;

int previousWidth;
String path = "";

MenuBar menuBar;
Menu fileMenu, loadExampleMenu;
MenuItem newMenuItem,loadMenuItem, loadExampleMenuItem, saveMenuItem, saveAsMenuItem, goodSudokuMenuItem, badSudoku1MenuItem, badSudoku2MenuItem, badSudoku3MenuItem;

//I was going to make an editable version (which is why there is a hover function) but couldn't get it in time.
MenuItemListener menuItemListener;

void setup() {
  //fullScreen();
  size(displayWidth,displayHeight);
  
  menuItemListener = new MenuItemListener();
  
  menuBar = new MenuBar(); 
  fileMenu = new Menu("File");
  loadExampleMenu = new Menu("Open Example");
  
  newMenuItem = new MenuItem("New", new MenuShortcut(KeyEvent.VK_N));
  loadMenuItem = new MenuItem("Open", new MenuShortcut(KeyEvent.VK_O));
  saveMenuItem = new MenuItem("Save", new MenuShortcut(KeyEvent.VK_S));
  saveAsMenuItem = new MenuItem("Save As", new MenuShortcut(KeyEvent.VK_S, true));

  goodSudokuMenuItem = new MenuItem("Good Sudoku");
  badSudoku1MenuItem = new MenuItem("Bad Sudoku 1");
  badSudoku2MenuItem = new MenuItem("Bad Sudoku 2");
  badSudoku3MenuItem = new MenuItem("Bad Sudoku 3");
  
  newMenuItem.addActionListener(menuItemListener);
  loadMenuItem.addActionListener(menuItemListener);
  saveMenuItem.addActionListener(menuItemListener);
  saveAsMenuItem.addActionListener(menuItemListener);
  goodSudokuMenuItem.addActionListener(menuItemListener);
  badSudoku1MenuItem.addActionListener(menuItemListener);
  badSudoku2MenuItem.addActionListener(menuItemListener);
  badSudoku3MenuItem.addActionListener(menuItemListener);


  newMenuItem.setActionCommand("New");
  loadMenuItem.setActionCommand("Open");
  saveMenuItem.setActionCommand("Save");
  saveAsMenuItem.setActionCommand("Save As");
  goodSudokuMenuItem.setActionCommand("goodSudoku");
  badSudoku1MenuItem.setActionCommand("badSudoku1");
  badSudoku2MenuItem.setActionCommand("badSudoku2");
  badSudoku3MenuItem.setActionCommand("badSudoku3");
  
  menuBar.add(fileMenu);
  loadExampleMenu.add(goodSudokuMenuItem);
  loadExampleMenu.add(badSudoku1MenuItem);
  loadExampleMenu.add(badSudoku2MenuItem);
  loadExampleMenu.add(badSudoku3MenuItem);
  fileMenu.add(newMenuItem);
  fileMenu.add(loadMenuItem);
  fileMenu.add(loadExampleMenu);
  //fileMenu.add(saveMenuItem);
  //fileMenu.add(saveAsMenuItem); 
  
  PSurfaceAWT awtSurface = (PSurfaceAWT)surface;
  PSurfaceAWT.SmoothCanvas smoothCanvas = (PSurfaceAWT.SmoothCanvas)awtSurface.getNative();
  smoothCanvas.getFrame().setMenuBar(menuBar);
  
  sudoku = new SudokuGrid();
  loadFromTextFile("SampleSudokus/goodSudoku.txt");
  updateSizes();
  surface.setResizable(true);
}

void draw() {
  background(200);
  updateSizes();
      
  rectMode(CENTER);
  fill(255);
  noStroke();
  rect(squareX, squareY, squareSize, squareSize);

  rectMode(CORNER);
  stroke(0);
  
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(squareSize/50);
  text(path, squareX, (height+squareY+squareSize/2)/2);

  textSize(squareSize/20);
  if(sudoku.containsDuplicates()) {
    fill(255, 0, 0);
    text("FAIL", squareX, (height - squareSize)/4);
  } else {
    fill(0, 255, 0);
    text("SUCCESS", squareX, (height - squareSize)/4);
  }


  
  textSize(squareSize/16);
  noFill();
  strokeWeight(height/900);
  for (int r = 0; r < 9; r++) {
    for (int c = 0; c < 9; c++) {
      boolean isHovered = mouseRow() == r && mouseColumn() == c;
      boolean isRed = sudoku.getRedMap()[r][c];
      boolean isRedBoxes = sudoku.getRedBoxesMap()[r][c]; 
      boolean isRedText = sudoku.getDuplicatesMap()[r][c];
      
      if (isRed && isHovered) {
        fill(255, 150, 150);
      } else if (isRed) {
        fill(255, 180, 180);
      } else if (isRedBoxes && isHovered) {
        fill(255, 160, 160);
      } else if (isRedBoxes) {
        fill(255, 210, 210);
      } else if (isHovered) {
        fill(200);
      }  else {
        fill(255);
      }
      rect(squareXCorner + c*squareSize/9, squareYCorner + r*squareSize/9, squareSize/9, squareSize/9);
      
      if (isRedText) {
          fill(255, 0, 0);
        } else {
          fill(0);
        }
      if (sudoku.get(r, c) != 0) {
        text(sudoku.get(r, c), squareXCorner + c*squareSize/9  + squareSize/18, squareYCorner + r*squareSize/9 + squareSize/18);
      }
    }
  }
  
  //bigsquares
  strokeWeight(height/150);
  noFill();
  for (int r = 0; r < 3; r++) {
    for (int c = 0; c < 3; c++) {
      rect(squareXCorner + c*squareSize/3, squareYCorner + r*squareSize/3, squareSize/3, squareSize/3);
    }
  }
}

void updateSizes() {
  
  squareX = width/2;
  squareY = height/2;
  squareSize =  (int) Math.min(width * 0.8, height * 0.8);

  squareXCorner = squareX - (squareSize/2);
  squareYCorner = squareY - (squareSize/2);
  
}


void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    loadFromTextFile(selection.getAbsolutePath());
  }
}

void loadFromTextFile(String path) {
  String[] input = loadStrings(path);
    
    int[][] arr = new int[9][9];
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        try {
          arr[r][c] = Integer.parseInt(input[r].substring(0, 1));          

        } catch (Exception e) {
          println(e);
          arr[r][c] = 0;
        }
        input[r] = input[r].substring(Math.min(2, input[r].length()-1), input[r].length());
      }  
    }
    
    sudoku = new SudokuGrid(arr);
    playSound();
}

public void playSound() {
  String folderName = "GoodSounds";
  if (sudoku.containsDuplicates()){
    folderName = "BadSounds";
  }

  ArrayList<String> soundsList = filesToArrayList(sketchPath("data/"+folderName));
  int rand = (int)(Math.random() * soundsList.size());
  println(soundsList.get(rand));
  SoundFile sound = new SoundFile(this, folderName+ "/"+soundsList.get(rand));
  sound.play();
}


boolean overRect(int x, int y, int width, int height) {
  int hWidth = width/2;
  int hHeight = height/2;
  return mouseX >= x - hWidth && mouseX <= x+hWidth && 
      mouseY >= y - hHeight && mouseY <= y+hHeight;
}

public int mouseColumn() {
  if (mouseX >= squareXCorner && mouseX <= squareXCorner + squareSize){
    return (mouseX - squareXCorner)/(squareSize/9); 
  }
  return -1;
}

public int mouseRow() {
  if (mouseY >= squareYCorner && mouseY <= squareYCorner + squareSize){
    return (mouseY - squareYCorner)/(squareSize/9); 
  } 
  return -1;
}

class MenuItemListener implements ActionListener {
      public void actionPerformed(ActionEvent e) {
        String action = e.getActionCommand() ;
        println(action 
            + " MenuItem clicked.");
        
        if (action.equals("Open")) {
          selectInput("Select a .txt file to read a sudoku grid from:", "fileSelected");
        } else if (action.equals("New")) {
          sudoku = new SudokuGrid();
        } else if (action.equals("goodSudoku") || action.contains("badSudoku")) {
          loadFromTextFile("SampleSudokus/" + action + ".txt");
        }

      }    
   }
   
ArrayList filesToArrayList(String path) {
  ArrayList<String> filesList = new ArrayList<String>();
  if (path != null) {
    File directory = new File(path);
    File[] files = directory.listFiles();
    for (File f : files) {
      filesList.add(f.getName());
    }
  }
  return(filesList);
}
