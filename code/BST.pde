final class BST {
  BST parent = null;
  BST left = null;
  BST right = null;
  int variable;
  int splitWidthPoint = 0;
  int splitHeightPoint = 0;
  
  int xStart = 0;
  int xEnd = 0;
  int yStart = 0;
  int yEnd = 0;
  
  boolean isHorizontal = false;
  BST(int variable) {
    this.variable = variable;
  }

  BST(int variable, BST left, BST right) {
    this.variable = variable;
    this.left = left;
    this.right = right;
  }

  BST dfs(BST current, int variable) {
    if (current.variable == variable) {
      return current;
    }
    BST result = null;
    result = dfs(current.left, variable);

    if (result.variable == variable) {
      return result;
    }

    result = dfs(current.right, variable);

    if (result.variable == variable) {
      return result;
    }

    return null;
  }
  
  String toString() {
    return "" + this.variable;
  }
}
