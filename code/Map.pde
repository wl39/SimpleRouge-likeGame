final class Map {
  int boardWidth = 32;
  int boardHeight = 18;

  float boardSize = 40;

  int seed = 0;
  int[][] board;

  int widthSplitSize = 5;
  int heightSplitSize = 5;

  int milli = 0;
  BST tree = null;
  ArrayList<BST> rooms = new ArrayList<>();
  
  int count = 0;
  Map(int seed) {
    init();

    this.seed = seed;
    this.tree = new BST(0);
  }

  void init() {
    boardWidth = (int) (boardWidth * (level + 1.0f) / 2);
    boardSize = (float) windowWidth / (float) boardWidth;

    widthSplitSize = boardWidth / 6;
    heightSplitSize = boardWidth / 6;

    int gcdWindow = gcd(windowWidth, windowHeight);
    int widthRatio = windowWidth/gcdWindow;
    int heightRatio = windowHeight/gcdWindow;

    int common = boardWidth / widthRatio;

    boardHeight = heightRatio * common;

    board = new int[boardHeight][boardWidth];

    for (int row = 0; row < boardHeight; row++) {
      for (int column = 0; column < boardWidth; column++) {
        board[row][column] = 0;
      }
    }
  }

  void setSeed() {
    if (seed == -1) {
      if (milli == millis()) {
        milli++;
      } else {
        milli = millis();
      }
      randomSeed(milli);
    } else {
      seed++;
      randomSeed(seed * level);
    }
  }

  void generateMap() {
    splitMap(tree, 0, boardWidth, 0, boardHeight);
    linkPath(tree);
  }

  void splitMap(BST current, int currentWidthMin, int currentWidthMax, int currentHeightMin, int currentHeightMax) {
    setSeed();
    int currentWidth = currentWidthMax - currentWidthMin;
    int currentHeight = currentHeightMax - currentHeightMin;

    int splitWidthPoint = (int) random(currentWidthMin + currentWidth / 3, currentWidthMax - 1 - currentWidth / 3);
    int splitHeightPoint = (int) random(currentHeightMin + currentHeight / 3, currentHeightMax - 1 - currentHeight / 3);

    boolean isWidthLimit = splitWidthPoint - currentWidthMin <= widthSplitSize; // isHorizontal = true
    boolean isHeightLimit = splitHeightPoint - currentHeightMin <= heightSplitSize; // isHorizontal = false;

    if (isWidthLimit && isHeightLimit) {

      int roomHeight = (currentHeightMax - 1) - (currentHeightMin + 1);
      int roomWidth = (currentWidthMax - 1) - (currentWidthMin + 1);

      int heightVariation = Math.abs((roomHeight - heightSplitSize) / 2);
      int widthVariation = Math.abs((roomWidth - widthSplitSize) / 2);

      int heightRandom = 0;
      int widthRandom = 0;

      if (roomHeight > heightSplitSize) {
        heightRandom = round(random(-heightVariation, heightVariation));
        if (heightRandom > 0) {
          currentHeightMin += heightRandom;
        } else {
          currentHeightMax += heightRandom;
        }
      }

      

      if (roomWidth > widthSplitSize) {
        widthRandom =  round(random(-widthVariation, widthVariation));

        if (widthRandom > 0) {
          currentWidthMin += widthRandom;
        } else {
          currentWidthMax += widthRandom;
        }
      }


      for (int row = currentHeightMin + 1; row < currentHeightMax - 1; row++) {
        for (int column = currentWidthMin + 1; column < currentWidthMax - 1; column++) {
          board[row][column] = 1;
        }
      }
      
      current.xStart = currentWidthMin + 1;
      current.xEnd = currentWidthMax - 1;
      current.yStart = currentHeightMin + 1;
      current.yEnd = currentHeightMax - 1;
      
      rooms.add(current);
      
      return;
    }

    boolean isHorizontal = round(random(0, 1)) == 1 ? true : false;

    current.splitWidthPoint = splitWidthPoint;
    current.splitHeightPoint = splitHeightPoint;


    if (isWidthLimit) {
      isHorizontal = true;
    }

    if (isHeightLimit) {
      isHorizontal = false;
    }

    current.isHorizontal = isHorizontal;

    current.left = new BST(++count);
    current.left.parent = current;
    current.right = new BST(++count);
    current.right.parent = current;

    if (isHorizontal) { // split the board horizontally
      splitMap(current.left, currentWidthMin, currentWidthMax, currentHeightMin, splitHeightPoint); // left node
      splitMap(current.right, currentWidthMin, currentWidthMax, splitHeightPoint, currentHeightMax); // left node
    } else { // split the board vertically
      splitMap(current.left, currentWidthMin, splitWidthPoint, currentHeightMin, currentHeightMax); // left node
      splitMap(current.right, splitWidthPoint, currentWidthMax, currentHeightMin, currentHeightMax); // left node
    }
  }

  void linkPath(BST current) {
    if (current == null) {
      return;
    }

    if (current.splitHeightPoint != 0 && current.splitWidthPoint != 0) {
      if (current.isHorizontal) {
        board[current.splitHeightPoint][current.splitWidthPoint] = 2;
        
        for (int row = current.splitHeightPoint; row > 1; row--) {

          
          
          board[row][current.splitWidthPoint - 1] = 2;
          board[row][current.splitWidthPoint] = 2;
          
          //if (board[row - 1][current.splitWidthPoint] > 0) {
          //  break;
          //}
          if (board[row][current.splitWidthPoint - 2] == 1 && board[row + 1][current.splitWidthPoint - 2] == 1) {
            break;
          }
          
          if (board[row][current.splitWidthPoint + 1] == 1 && board[row + 1][current.splitWidthPoint + 1] == 1) {
            break;
          }
          
        }

        for (int row = current.splitHeightPoint; row < board.length - 1; row++) {

          
          
          board[row][current.splitWidthPoint - 1] = 2;
          board[row][current.splitWidthPoint] = 2;

          //if (board[row + 1][current.splitWidthPoint] > 0) {
          //  break;
          //}
          if (board[row][current.splitWidthPoint - 2] == 1 && board[row - 1][current.splitWidthPoint - 2] == 1) {
            break;
          }
          
          if (board[row][current.splitWidthPoint + 1] ==1  && board[row - 1][current.splitWidthPoint + 1] == 1) {
            break;
          }
          
          
        }
      } else { // path horizontally

        for (int column = current.splitWidthPoint; column > 1; column--) {

          
          
          board[current.splitHeightPoint - 1][column] = 3;
          board[current.splitHeightPoint][column] = 3;
          //board[current.splitHeightPoint + 1][column] = 3;

          //if (board[current.splitHeightPoint][column - 1] > 0) {
          //  break;
          //}
          
          if (board[current.splitHeightPoint - 2][column] == 1 && board[current.splitHeightPoint - 2][column + 1] == 1) {
            break;
          }
          
          if (board[current.splitHeightPoint + 1][column] == 1 && board[current.splitHeightPoint + 1][column + 1] == 1) {
            break;
          }
        }

        for (int column = current.splitWidthPoint; column < board[0].length - 1; column++) {

          
          
          board[current.splitHeightPoint - 1][column] = 3;
          board[current.splitHeightPoint][column] = 3;
          //board[current.splitHeightPoint + 1][column] = 3;

          //if (board[current.splitHeightPoint][column + 1] > 0) {
          //  break;
          //}
          
          if (board[current.splitHeightPoint - 2][column] == 1 && board[current.splitHeightPoint - 2][column - 1] == 1) {
            break;
          }
          
          if (board[current.splitHeightPoint + 1][column] == 1 && board[current.splitHeightPoint + 1][column - 1] == 1) {
            break;
          }
        }
      }
    }

    linkPath(current.left);
    linkPath(current.right);
  }

  int gcd(int n1, int n2) {
    if (n2 == 0) return n1;
    else return gcd(n2, n1 % n2);
  }
}
