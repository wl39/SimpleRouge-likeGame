

final class Bullet {
  public PVector position, velocity ;
  private PVector linear ;
  int type;
  int bounceLimit = 5;

  Bullet(int x, int y, float xVel, float yVel, PVector targetPos, int type) {
    position = new PVector(x, y);
    velocity = new PVector(xVel, yVel);
    linear = new PVector(0, 0);
    linear.x = targetPos.x - position.x;
    linear.y = targetPos.y - position.y;
    this.type = type;
  }

  boolean integrate() {
    if (bounceLimit < 0) {
      return false;
    }

    position.add(velocity) ;

    if (bounceLimit == 5) {
      linear.normalize();
      linear.mult(0.5F);

      velocity.add(linear);
    }



    int row = (int) (position.y / map.boardSize);
    int column = (int) (position.x / map.boardSize);
    int rowTop = (int) ((position.y - 5) / map.boardSize);
    int columnLeft = (int) ((position.x - 5) / map.boardSize);
    int rowBottm = (int) ((position.y + 5) / map.boardSize);
    int columnRight = (int) ((position.x + 5) / map.boardSize);

    if (row >= map.board.length) {
      return false;
    }
    
    if (rowTop >= map.board.length) {
      return false;
    }
    
    if (rowBottm >= map.board.length) {
      return false;
    }
    
    if (row < 0) {
      return false;
    }
    
    if (rowTop < 0) {
      return false;
    }
    
    if (rowBottm < 0) {
      return false;
    }
    
    if (column >= map.board[0].length) {
      return false;
    }
    
    if (columnLeft >= map.board[0].length) {
      return false;
    }
    
    if (columnRight >= map.board[0].length) {
      return false;
    }
    
    if (column < 0) {
      return false;
    }
    
    if (columnLeft < 0) {
      return false;
    }
    
    if (columnRight < 0) {
      return false;
    }
    
    for (int i = 0; i < enemyGenerator.enemies.size(); i++) {
      if (enemyGenerator.enemies.get(i).type == 2) {
        if (dist(position.x, position.y, enemyGenerator.enemies.get(i).position.x, enemyGenerator.enemies.get(i).position.y) < 20) {
          enemyGenerator.enemies.get(i).currentHealth -= hero.attackDamge;
          return false;
        }
      } else {
        if (dist(position.x, position.y, enemyGenerator.enemies.get(i).position.x, enemyGenerator.enemies.get(i).position.y) < 15) {
          enemyGenerator.enemies.get(i).currentHealth -= hero.attackDamge;
          return false;
        }
      }
    }

    if (map.board[row][columnLeft] == 0) {
      if (velocity.x < 0) {
        if (type == BOUNCING_SHOT) {
          velocity.x = -(velocity.x);
          bounceLimit--;
        } else {
          return false;
        }
      } else if (velocity.x == 0) {
        if (type == BOUNCING_SHOT) {
          velocity.x = -(velocity.x) ;
          bounceLimit--;
        } else {
          return false;
        }
      }
    }

    if (map.board[rowTop][column] == 0) {
      if (velocity.y < 0) {
        if (type == BOUNCING_SHOT) {
          velocity.y = -(velocity.y) ;
          bounceLimit--;
        } else {
          return false;
        }
      } else if (velocity.y == 0) {
        if (type == BOUNCING_SHOT) {
          velocity.y = -(velocity.y) ;
          bounceLimit--;
        } else {
          return false;
        }
      }
    }

    if (map.board[row][columnRight] == 0) {
      if (velocity.x > 0) {
        if (type == BOUNCING_SHOT) {
          velocity.x = -(velocity.x) ;
          bounceLimit--;
        } else {
          return false;
        }
      } else if (velocity.x == 0) {
        if (type == BOUNCING_SHOT) {
          velocity.x = -(velocity.x) ;
          bounceLimit--;
        } else {
          return false;
        }
      }
    }

    if (map.board[rowBottm][column] == 0) {
      if (velocity.y > 0) {
        if (type == BOUNCING_SHOT) {
          velocity.y = -(velocity.y) ;
          bounceLimit--;
        } else {
          return false;
        }
      } else if (velocity.y == 0) {
        if (type == BOUNCING_SHOT) {
          velocity.y = -(velocity.y) ;
          bounceLimit--;
        } else {
          return false;
        }
      }
    }

    return true;
  }
}
