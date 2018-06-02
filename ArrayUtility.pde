public static class ArrayUtility{
  
  public static int[] getColumn(int[][] arr, int c) {
    int[] ans = new int[arr.length];
    for (int r = 0; r < arr.length; r++) {
      ans[r] = arr[r][c];
    }
    return ans;
  }
  
  public static int[] getDiagonal(int[][]arr, int startRow, int startCol, int slope) {
    int[] ans = new int[Math.min(Math.abs(arr.length-startRow), Math.abs(arr[startRow].length-startCol))];
    int i = 0;
    int r = startRow; 
    int c = startCol;
    while (r < arr.length && c < arr[r].length){
      ans[i] = arr[r][c];
      i++;
      r+= slope;
      c++;
    }
    return ans;
  }
  
  public static int[] getBox(int[][] arr, int x, int y) {
    ArrayList<Integer> ans = new ArrayList<Integer>();
    for (int r = x - 1; r < x + 2; r++) {
       for (int c = y - 1 ; c < y + 2; c++) {
         if (r >= 0 && c >= 0 && r < arr.length && c < arr[r].length) {
           ans.add(arr[r][c]);
         }
       }
    }

    return toArray(ans);
  }
  
  public static int[] getBox(int[][] arr, int n) {
    int[] input = getBox(arr, (n - 1)/3 * 3 + 1, (n-1)%3 * 3+ 1);
      
    return getBox(arr, (n )/3 * 3 + 1, (n)%3 * 3+ 1);  
  }
 
  
  public static int[] findDuplicates(int[] input) {
    ArrayList<Integer> duplicates = new ArrayList<Integer>(); 
    for (int i = 0; i < input.length; i++) {
      for (int j = 0; j < input.length; j++) { //not an efficient way of doing this but whatevs 
        if (input[i] == input[j] && i != j && !duplicates.contains(i)) {
          duplicates.add(i);
        }
      }
    }
    return toArray(duplicates);
  }
  
  public static boolean hasDuplicates(int[] input) {
    for (int i = 0; i < input.length - 1; i++) {
        for (int j = i + 1; j < input.length; j++) { 
          if (input[i] == input[j]) {
            return true;
          }
        }
      }
    return false;
  }

  public static int[] toArray(ArrayList<Integer> input) {
    int[] ret = new int[input.size()];
    for (int i = 0; i < input.size(); i++){
      ret[i] = input.get(i);
    }
    return ret;
  }
  
  public static boolean contains(int[] arr, int c) {
    for (int x : arr) {
      if (c == x) {
        return true;
      }
    }
    return false;
  }
  
}
