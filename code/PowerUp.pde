final int DOUBLE_SHOT = 0;
final int TRIPLE_SHOT = 1;
final int BOUNCING_SHOT = 2;
final int ATTACK = 3;

final int SPEED = 4;
final int HASTE = 5;
final int HEALTH_PACK = 6;
final int ACCURACY = 7;


final class PowerUp {
  PVector position;
  int type;

  PowerUp(int type, int x, int y) {
    this.type = type;
    this.position = new PVector(x, y);
  }

  boolean check() {
    if (dist(position.x, position.y, hero.position.x, hero.position.y) < 25) {
      if (type == SPEED) {
        hero.heroStartVelocity++;
      }

      if (type == HASTE) {
        hero.hasteVisual += 30;
        hero.hasteVisualMax += 30;
      }

      if (type == ATTACK) {
        hero.attackDamge++;
      }

      if (type == HEALTH_PACK) {
        hero.currentHealth++;
      }

      if (type == ACCURACY) {
        if (hero.accuracy >= 95) {
        } else if (hero.accuracy >= 90) {
          hero.accuracy += 0.5;
        } else if (hero.accuracy >= 80) {
          hero.accuracy += 1;
        } else {
          hero.accuracy += 5;
        }
      }



      hero.powerUp.add(type);
      hero.powerUpCount[type]++;
      return true;
    }

    return false;
  }
}
