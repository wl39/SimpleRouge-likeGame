import java.util.*;
final float ORIENTATION_INCREMENT = PI/4 ;

final class Hero {
  public PVector position, velocity ;
  private PVector forceAccumulator ;
  public float invMass ;

  public float orientation = 0.0f;
  int currentHealth = HEALTH;
  HashSet<Integer> powerUp = new HashSet();
  int[] powerUpCount = new int[8];
  int ammo = 12;

  int accuracy = 60;

  int reloadTime = 1000;
  int reloadStartTime = -1;
  int heroStartVelocity = 3;
  int hasteVisual = 150;
  int hasteVisualMax = 150;
  int hasteTime = 1500;
  int hasteStartTime = -1;
  int hasteEndTime = -1;

  int attackDamge = 2;

  boolean reload = false;
  boolean haste = false;
  boolean hasteReload = false;
  boolean hasKey = false;


  Hero (int x, int y, float xVel, float yVel, float invM) {
    position = new PVector(x, y) ;
    velocity = new PVector(xVel, yVel) ;

    forceAccumulator = new PVector(0, 0) ;
    invMass = invM ;
  }

  void addForce(PVector force) {
    forceAccumulator.add(force) ;
  }

  void integrate() {
    if (reload) {
      if (millis() >= reloadStartTime + reloadTime) {
        reload = false;
        reloadStartTime = -1;
        ammo = 12;
      }
    }

    if (hasteVisual <= 0 && !hasteReload) {
      heroVelocity = heroStartVelocity;
      hasteVisual = 0;
      haste = false;
      hasteReload = true;
      hasteEndTime = millis();
    }

    if (hasteReload) {
      haste = false;

      hasteVisual += (millis() - hasteEndTime) / 100;

      if (hasteVisual >= hasteVisualMax) {
        hasteReload = false;
        hasteVisual = hasteVisualMax;
        hasteEndTime = 1;
      }
    }

    if (dist(position.x, position.y, keyObject.x, keyObject.y) < 24) {
      hasKey = true;
    }

    if (hasKey && position.x > exit.x && position.y > exit.y && position.x < exit.x + 40 && position.y < exit.y + 40) {
      hasKey = false;
      level++;
      score += 100;
      updateMap();
    }

    if (haste) {
      heroVelocity = heroStartVelocity + 3;
      hasteVisual -= (millis() - hasteStartTime) / 500;
    }


    if (ammo <= 0 && reloadStartTime < 0) {
      reloadStartTime = millis();
      reload = true;
    }
    // If infinite mass, we don't integrate
    if (invMass <= 0f) return ;

    // update position

    // NB If you have a constant acceleration (e.g. gravity) start with
    //    that then add the accumulated force / mass to that.
    PVector resultingAcceleration = forceAccumulator.get() ;
    resultingAcceleration.mult(invMass) ;

    // update velocity
    velocity.add(resultingAcceleration) ;
    // apply damping - disabled when Drag force present
    //velocity.mult(DAMPING) ;
    // Apply an impulse to bounce off the edge of the screen

    //if ((position.x < 0) || (position.x > width)) velocity.x = -velocity.x ;
    //if ((position.y < 0) || (position.y > height)) velocity.y = -velocity.y ;

    for (int i = 0; i < enemyGenerator.enemies.size(); i++) {
      if (dist(position.x, position.y, enemyGenerator.enemies.get(i).position.x, enemyGenerator.enemies.get(i).position.y) < 23) {
        return;
      }
    }


    int row = (int) (position.y / map.boardSize);
    int column = (int) (position.x / map.boardSize);
    int rowTop = (int) ((position.y - 10) / map.boardSize);
    int columnLeft = (int) ((position.x - 10) / map.boardSize);
    int rowBottm = (int) ((position.y + 10) / map.boardSize);
    int columnRight = (int) ((position.x + 10) / map.boardSize);
    //if (map.board[row][column

    if (map.board[row][columnLeft] == 0) {
      if (velocity.x < 0)
        velocity.x = 0 ;
      else if (velocity.x == 0)
        velocity.x = 0 ;
    }

    if (map.board[rowTop][column] == 0) {
      if (velocity.y < 0) {
        velocity.y = 0;
      } else if (velocity.y == 0)
        velocity.y = 0 ;
    }

    if (map.board[row][columnRight] == 0) {
      if (velocity.x > 0)
        velocity.x = 0 ;
      else if (velocity.x == 0)
        velocity.x = 0 ;
    }

    if (map.board[rowBottm][column] == 0) {
      if (velocity.y > 0) {
        velocity.y = 0;
      } else if (velocity.y == 0)
        velocity.y = 0 ;
    }


    if (velocity.x > 0) {
      if (!right) {
        if (velocity.y != 0) {
          velocity.x = 0;
        } else {
          return;
        }
      }
    }

    if (velocity.x < 0) {
      if (!left) {
        if (velocity.y != 0) {
          velocity.x = 0;
        } else {
          return;
        }
      }
    }

    if (velocity.y < 0) {
      if (!up) {
        if (velocity.x != 0) {
          velocity.y = 0;
        } else {
          return;
        }
      }
    }

    if (velocity.y > 0) {
      if (!down) {
        if (velocity.x != 0) {
          velocity.y = 0;
        } else {
          return;
        }
      }
    }

    if (position.x < 10) {
      if (velocity.x < 0)
        velocity.x = 0 ;
      else if (velocity.x == 0)
        velocity.x = 0 ;
    }
    if (position.x > width) {
      if (velocity.x > 0)
        velocity.x = 0 ;
      else if (velocity.x == 0)
        velocity.x = 0 ;
    }
    if (position.y < 10) {
      if (velocity.y < 0) {
        velocity.y = 0;
      } else if (velocity.y == 0)
        velocity.y = 0 ;
    }
    if (position.y > height) {
      if (velocity.y > 0)
        velocity.y = 0 ;
      else if (velocity.y == 0)
        velocity.y = 0 ;
    }

    // Clear accumulator
    forceAccumulator.x = 0 ;
    forceAccumulator.y = 0 ;


    position.add(velocity);
    if (velocity.mag() <= 0) {
      return;
    }

    float targetOrientation = atan2(velocity.y, velocity.x) ;
    // Will take a frame extra at the PI boundary
    if (abs(targetOrientation - orientation) <= ORIENTATION_INCREMENT) {
      orientation = targetOrientation ;
      return ;
    }

    // if it's less than me, then how much if up to PI less, decrease otherwise increase
    if (targetOrientation < orientation) {
      if (orientation - targetOrientation < PI)
        orientation -= ORIENTATION_INCREMENT ;
      else orientation += ORIENTATION_INCREMENT ;
    } else {
      if (targetOrientation - orientation < PI)
        orientation += ORIENTATION_INCREMENT ;
      else orientation -= ORIENTATION_INCREMENT ;
    }

    // Keep in bounds
    if (orientation > PI) orientation -= 2*PI ;
    else if (orientation < -PI) orientation += 2*PI ;
  }
}
