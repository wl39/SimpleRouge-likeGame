final float MAX_SPEED = 6f ;
final float MAX_ACCEL = 0.1f ;
final float MAX_ROTATION = PI/4 ;

final int PATROL = 0;
final int CHASE = 1;
final int FIGHT = 2;

final int HEALTH = 5;

final class Enemy {
  int accuracy = 50;
  BST room = null;
  public PVector position, velocity, patrolStart, patrolEnd;
  private static final float DAMPING = .995f ;
  private PVector forceAccumulator ;
  public float orientation, rotation ;
  int type = 0;
  int state = PATROL;
  int maxHealth = HEALTH;
  int currentHealth = HEALTH;

  public float invMass ;

  Enemy (BST room, int x, int y, int xPatrol, int yPatrol, float xVel, float yVel, float invM, int type) {
    position = new PVector(x, y) ;
    velocity = new PVector(xVel, yVel) ;
    patrolStart = new PVector(x, y);
    patrolEnd = new PVector(xPatrol, yPatrol);

    forceAccumulator = new PVector(0, 0) ;
    invMass = invM ;
    this.type = type;
    this.room = room;

    this.maxHealth = (int) (HEALTH * (level * 1.2));
    this.currentHealth = (int) (HEALTH * (level * 1.2));
    
    if (type == 2) {
      this.maxHealth = (int) (8 * (level * 1.2));
      this.currentHealth = (int) (8 * (level * 1.2));
    }
  }

  void integrate(PVector linear, float angular) {
    switch (state) {
    case PATROL:

      if (abs(position.x - patrolEnd.x) < 5 && abs(position.y - patrolEnd.y) < 5) {
        PVector temp = patrolStart;
        patrolStart = patrolEnd;
        patrolEnd = temp;
      }

      for (Enemy enemy : enemyGenerator.enemies) {
        if (enemy.equals(this)) {
          break;
        }

        if (dist(position.x, position.y, enemy.position.x, enemy.position.y) < 12) {
          int xPatrol = round(random(this.room.xStart + 1, this.room.xEnd - 1));
          int yPatrol = round(random(this.room.yStart + 1, this.room.yEnd - 1));
          this.patrolEnd = new PVector((int) (xPatrol * map.boardSize), (int) (yPatrol * map.boardSize));
        }
      }
      if (hero.position.x > room.xStart * map.boardSize &&
        hero.position.x < room.xEnd * map.boardSize &&
        hero.position.y > room.yStart * map.boardSize &&
        hero.position.y < room.yEnd * map.boardSize)
        state = CHASE;

      if (this.currentHealth < this.maxHealth) {
        state = CHASE;
      }

      position.add(velocity) ;
      // Apply an impulse to bounce off the edge of the screen
      if ((position.x < 0) || (position.x > width)) velocity.x = -velocity.x ;
      if ((position.y < 0) || (position.y > height)) velocity.y = -velocity.y ;

      // calculate and apply accel
      linear.x = patrolEnd.x - position.x;
      linear.y = patrolEnd.y - position.y ;

      linear.normalize() ;
      //linear.mult(MAX_ACCEL) ;
      velocity.add(linear) ;
      if (velocity.mag() > 3f) {
        velocity.normalize() ;
        velocity.mult(3f) ;
      }

      //move a bit towards velocity:
      // turn vel into orientation
      float targetOrientation = atan2(velocity.y, velocity.x) ;

      // Will take a frame extra at the PI boundary
      if (abs(targetOrientation - orientation) <= ORIENTATION_INCREMENT) {
        orientation = targetOrientation ;
        return ;
      }

      // if it's less than me, then how much if up to PI less, decrease otherwise increase
      if (targetOrientation < orientation) {
        if (orientation - targetOrientation < PI) orientation -= ORIENTATION_INCREMENT ;
        else orientation += ORIENTATION_INCREMENT ;
      } else {
        if (targetOrientation - orientation < PI) orientation += ORIENTATION_INCREMENT ;
        else orientation -= ORIENTATION_INCREMENT ;
      }

      // Keep in bounds
      if (orientation > PI) orientation -= 2*PI ;
      else if (orientation < -PI) orientation += 2*PI ;

      break;
    case CHASE:
      position.add(velocity) ;

      // Apply an impulse to bounce off the edge of the screen
      int row = (int) (position.y / map.boardSize);
      int column = (int) (position.x / map.boardSize);
      int rowTop = (int) ((position.y - 10) / map.boardSize);
      int columnLeft = (int) ((position.x - 10) / map.boardSize);
      int rowBottm = (int) ((position.y + 10) / map.boardSize);
      int columnRight = (int) ((position.x + 10) / map.boardSize);

      if (gameType == SHOOTING) {
        if (type == 2) {
          if (dist(position.x, position.y, hero.position.x, hero.position.y) < 25) {
            hero.currentHealth -= 2;

            velocity.x = velocity.x < 0 ? -(velocity.x - 1) : -(velocity.x + 1);
            velocity.y = velocity.y < 0 ? -(velocity.y - 1) : -(velocity.y + 1);
            return;
          }
        } else {
          if (dist(position.x, position.y, hero.position.x, hero.position.y) < 20) {
            hero.currentHealth--;

            velocity.x = velocity.x < 0 ? -(velocity.x - 1) : -(velocity.x + 1);
            velocity.y = velocity.y < 0 ? -(velocity.y - 1) : -(velocity.y + 1);
            return;
          }
        }
      } else {
        if (type == 2) {
          if (dist(position.x, position.y, hero.position.x, hero.position.y) < 25) {
            gameState = TEXT_FIGHT;
            fightAgainst = this;
            return;
          }
        } else {
          if (dist(position.x, position.y, hero.position.x, hero.position.y) < 20) {
            gameState = TEXT_FIGHT;
            fightAgainst = this;
            return;
          }
        }
      }


      if (map.board[row][columnLeft] == 0) {
        if (velocity.x < 0)
          velocity.x = -(velocity.x - 0.5) ;
        else if (velocity.x == 0)
          velocity.x = -(velocity.x - 0.5) ;
      }

      if (map.board[rowTop][column] == 0) {
        if (velocity.y < 0) {
          velocity.y = -(velocity.y - 0.5);
        } else if (velocity.y == 0)
          velocity.y = -(velocity.y - 0.5);
      }

      if (map.board[row][columnRight] == 0) {
        if (velocity.x > 0)
          velocity.x = -(velocity.x + 0.5) ;
        else if (velocity.x == 0)
          velocity.x = -(velocity.x + 0.5) ;
      }

      if (map.board[rowBottm][column] == 0) {
        if (velocity.y > 0) {
          velocity.y = -(velocity.y + 0.5);
        } else if (velocity.y == 0)
          velocity.y = -(velocity.y + 0.5);
      }

      if ((position.x < 0) || (position.x > width)) velocity.x = -velocity.x ;
      if ((position.y < 0) || (position.y > height)) velocity.y = -velocity.y ;

      orientation += rotation ;
      if (orientation > PI) orientation -= 2*PI ;
      else if (orientation < -PI) orientation += 2*PI ;

      linear.normalize() ;
      linear.mult(MAX_ACCEL) ;
      velocity.add(linear) ;

      if (type == 2) {
        if (currentHealth > maxHealth / 2 ) {
          if (velocity.mag() > 5) {
            velocity.normalize() ;
            velocity.mult(3) ;
          }
        } else {
          if (velocity.mag() > 12) {
            velocity.normalize() ;
            velocity.mult(MAX_SPEED) ;
          }
        }
      } else {
        if (currentHealth > maxHealth / 2 ) {
          if (velocity.mag() > 3) {
            velocity.normalize() ;
            velocity.mult(3) ;
          }
        } else {
          if (velocity.mag() > MAX_SPEED) {
            velocity.normalize() ;
            velocity.mult(MAX_SPEED) ;
          }
        }
      }

      rotation += angular ;
      if (rotation > MAX_ROTATION) rotation = MAX_ROTATION ;
      else if (rotation  < -MAX_ROTATION) rotation = -MAX_ROTATION ;
      break;
    }
  }
}
