public class SudokuGrid {
  private int[][] grid = new int[9][9];
  
  private boolean[][] redMap = new boolean[9][9];
  private boolean[][] redBoxesMap = new boolean[9][9];
  private boolean[][] duplicatesMap = new boolean[9][9];
  
  public SudokuGrid(int[][] input){
      for(int r = 0; r < 9; r++) {
        if (r <= input.length) {
          for(int c = 0; c <9; c++) {
            if (c <= input[r].length) {
              grid[r][c] = input[r][c];
            } else {
              grid[r][c] = 0;
            }
          }
        } else {
          for(int c = 0; c <9; c++) {
            grid[r][c] = 0;
          }
        }
      }
      updateMaps();
  }
  
  public SudokuGrid() {

    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        grid[r][c] = 0; 
      }
    }
    updateMaps();
  }
  
  public int get(int r, int c) {
    return grid[r][c];
  }
  
  public boolean set(int r, int c, int val) {
    grid[r][c] = val;
    return true;
  }
  
  //returns array of row positions
  public int[] checkRows() {
    ArrayList<Integer> ans = new ArrayList<Integer>(); 
    for (int r = 0; r < grid.length; r++) {
      if (ArrayUtility.hasDuplicates(grid[r])) {
         ans.add(r);
      }
    }
    return ArrayUtility.toArray(ans);
  }
  
  public int[] checkColumns() {
    ArrayList<Integer> ans = new ArrayList<Integer>(); 
    for (int c = 0; c < grid.length; c++) {
      if (ArrayUtility.hasDuplicates(ArrayUtility.getColumn(grid, c))) {
         ans.add(c);
      }
    }
    return ArrayUtility.toArray(ans);
  }
  
  public int[] checkBoxes() {
    ArrayList<Integer> ans = new ArrayList<Integer>();
    for (int r = 0; r < 3; r++ ) {
      for (int c = 0; c < 3; c++) {
        if (ArrayUtility.hasDuplicates(ArrayUtility.getBox(grid, r * 3 + 1, c*3 + 1))){
          ans.add((r * 3) + c);
        }
      }  
    }
    return ArrayUtility.toArray(ans);
  }
  
  public void updateDuplicatesMap() {
    for (boolean[] r : duplicatesMap) {
      for (boolean c : r) {
        c = false;
      }
    }
    int[] check = checkRows();
    int[] duplicates; 
    for (int r : check) {
      duplicates = ArrayUtility.findDuplicates(grid[r]);
      println();
      for (int c : duplicates) {
        duplicatesMap[r][c] = true;
      }
    }
    
    check = checkColumns();
    for (int c : check) {
      duplicates = ArrayUtility.findDuplicates(ArrayUtility.getColumn(grid, c));
      for (int r : duplicates) {
        duplicatesMap[r][c] = true;
      }
    }
    
    
    check = checkBoxes();
    for (int i : check) {
      duplicates = ArrayUtility.findDuplicates(ArrayUtility.getBox(grid, i));
      for (int b : duplicates) {
        int r = ((i / 3) * 3) + (b /3);

        int c = ((i % 3) * 3) + (b % 3);
        duplicatesMap[r][c] = true;
      }
    }
    
  }
  
  public boolean[][] getDuplicatesMap() {
    return duplicatesMap;
  }
  
  public void updateRedMap() {
    int[] checkRows = checkRows();
    int[] checkCols = checkColumns();
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        redMap[r][c] = ArrayUtility.contains(checkRows, r) || ArrayUtility.contains(checkCols, c);
      }
    }
  }
  
  public boolean[][] getRedMap() {
    return redMap;
  }
  
  public void updateMaps() {
    updateRedMap();
    updateDuplicatesMap();
    updateRedBoxesMap();
  }
  
  public void updateRedBoxesMap(){
    int[] checkBoxes = checkBoxes();
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        redBoxesMap[r][c] = ArrayUtility.contains(checkBoxes, ((r/3) * 3) + (c/3) );
      }
    }
  }
  
  public boolean[][] getRedBoxesMap() {
    return redBoxesMap;
  }
  
  public boolean containsDuplicates() {
    return checkRows().length != 0 || checkColumns().length != 0 || checkBoxes().length != 0;
  }

}
