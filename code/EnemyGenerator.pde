final class EnemyGenerator {
  ArrayList<Enemy> enemies = new ArrayList<>();
  ArrayList<BST> rooms = null;

  int enemyMin = 0;
  int enemyMax = 0;

  int milli = 0;
  EnemyGenerator(ArrayList<BST> rooms) {
    this.rooms = rooms;
  }

  void generates(int level) {
    int maxEnemiesInRoom = round(level);
    for (int i = 1; i < rooms.size(); i++) {
      BST room = rooms.get(i);

      int enemyNum = round(random(1, maxEnemiesInRoom));
      
      for (int j = 0; j < enemyNum; j++) {
        int xStart = room.xStart;
        int xEnd = room.xEnd;
        int yStart = room.yStart;
        int yEnd = room.yEnd;
        int xPosition = round(random(xStart + 1, xEnd - 1));
        int yPosition = round(random(yStart + 1, yEnd - 1));

        int xPatrol = round(random(xStart + 1, xEnd - 1));
        int yPatrol = round(random(yStart + 1, yEnd - 1));

        int type = round(random(0, 2));

        enemies.add(new Enemy(room, (int) (xPosition * map.boardSize), (int) (yPosition * map.boardSize), (int) (xPatrol * map.boardSize), (int) (yPatrol * map.boardSize), 0, 0, 0.0005f, type));
      }
    }
  }

}
