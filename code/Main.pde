final int MAIN = 0;
final int INGAME = 1;
final int SETTING = 2;
final int TEXT_FIGHT = 3;
final int GAME_OVER = 4;
final int INFO = 5;
final int WIN = 6;

final int TEXT_ADV = 0;
final int SHOOTING = 1;

final int SELECT = 0;
final int SHOOT = 1;
final int SHOOT_ENEMY = 2;
final int DEFEND = 3;
final int RUNAWAY = 5;

int gameState = MAIN;
int gameType = SHOOTING;

int fightState = SELECT;

int windowWidth = 1280;
int windowHeight = 720;

int buttonWidth = 300;
int buttonHeight = 80;

int shotResult = 0;
int enemyShotResult = 0;
int evadeResult = 0;
int runawayResult = 0;

color startButtonColor = color(255);
color startOverButtonColor = color(220);
color settingButtonColor = color(255);
color settingOverButtonColor = color(220);

int startButtonX = windowWidth/2 - buttonWidth/2;
int startButtonY = buttonHeight * 2;

int settingButtonY = buttonHeight * 6;
int seedButtonY = buttonHeight * 5;
int gameTypeButtonY = buttonHeight * 4;


boolean startOver = false;
boolean settingOver = false;
boolean gameTypeOver = false;
boolean seedOver = false;
boolean seedUpOver = false;
boolean seedDownOver = false;

Map map;
int seed = -1;
int level = 1;
int score = 0;
float tempRandomNumber = 0.0f;

boolean up = false;
boolean down = false;
boolean left = false;
boolean right = false;

boolean colideLeft = false;
boolean colideRight = false;
boolean colideUp = false;
boolean colideDown = false;

boolean showInfo = false;

int heroVelocity = 3;
Hero hero;
PVector heroLinear = new PVector(0, 0);
PVector exit, keyObject = new PVector(0, 0);

PVector heroAni = new PVector(0, 0);
PVector enemyAni = new PVector(0, 0);
PVector bulletAni, enemyBulletAni = new PVector(0, 0);

ArrayList<Bullet> bullets = new ArrayList<>();
ArrayList<PowerUp> powerUp = new ArrayList<>();
int gunX, gunY;

Enemy fightAgainst = null;
EnemyGenerator enemyGenerator;
void settings() {
  size(windowWidth, windowHeight);
}

void setup() {
  surface.setResizable(true);
  frameRate(60);
  map = new Map(seed);
  gameState = MAIN;
  map.generateMap();
  hero = new Hero(100, 100, 0, 0, 0.005f) ;

  int xExit = round(random(map.rooms.get(map.rooms.size() - 1).xStart + 1, map.rooms.get(map.rooms.size() - 1).xEnd - 1 ));
  int yExit = round(random(map.rooms.get(map.rooms.size() - 1).yStart + 1, map.rooms.get(map.rooms.size() - 1).yEnd - 1 ));

  exit = new PVector((int) (xExit * map.boardSize), (int) (yExit * map.boardSize));

  int keyRoom = map.rooms.size() / 2 + 1;

  int xKey = round(random(map.rooms.get(keyRoom).xStart + 1, map.rooms.get(keyRoom).xEnd - 1 ));
  int yKey = round(random(map.rooms.get(keyRoom).yStart + 1, map.rooms.get(keyRoom).yEnd - 1 ));

  keyObject = new PVector((int) (xKey * map.boardSize), (int) (yKey * map.boardSize));
  bullets = new ArrayList<>();
  powerUp = new ArrayList<>();
  enemyGenerator = new EnemyGenerator(map.rooms);
  enemyGenerator.generates(level);
  heroVelocity = hero.heroStartVelocity;
}

void draw() {
  if (gameState == MAIN) {
    update();
    background(255);
    stroke(0);

    if (startOver) {
      fill(startOverButtonColor);
    } else {
      fill(startButtonColor);
    }

    rect(startButtonX, startButtonY, buttonWidth, buttonHeight);

    if (settingOver) {
      fill(settingOverButtonColor);
    } else {
      fill(settingButtonColor);
    }

    rect(startButtonX, settingButtonY, buttonWidth, buttonHeight);


    textSize(24);
    fill(0, 0, 0);
    textAlign(CENTER, CENTER);
    text("Start the game", startButtonX + buttonWidth / 2, startButtonY + buttonHeight / 2 - 5);

    fill(0, 0, 0);
    textAlign(CENTER, CENTER);
    text("Setting", startButtonX + buttonWidth / 2, settingButtonY + buttonHeight / 2 - 5);
  } else if (gameState == SETTING) {
    update();

    background(255);

    if (startOver) {
      fill(startOverButtonColor);
    } else {
      fill(startButtonColor);
    }

    rect(startButtonX, startButtonY, buttonWidth, buttonHeight);

    if (gameTypeOver) {
      fill(settingOverButtonColor);
    } else {
      fill(settingButtonColor);
    }

    rect(startButtonX, gameTypeButtonY, buttonWidth, buttonHeight);

    if (seedOver) {
      fill(settingOverButtonColor);
    } else {
      fill(settingButtonColor);
    }

    rect(startButtonX, seedButtonY, buttonWidth - 50, buttonHeight);

    if (seedUpOver) {
      fill(settingOverButtonColor);
    } else {
      fill(settingButtonColor);
    }

    rect(startButtonX + buttonWidth - 50, seedButtonY, 50, buttonHeight / 2);

    if (seedDownOver) {
      fill(settingOverButtonColor);
    } else {
      fill(settingButtonColor);
    }

    rect(startButtonX + buttonWidth - 50, seedButtonY + buttonHeight / 2, 50, buttonHeight / 2);

    if (settingOver) {
      fill(settingOverButtonColor);
    } else {
      fill(settingButtonColor);
    }

    rect(startButtonX, settingButtonY, buttonWidth, buttonHeight);



    textSize(24);
    fill(0, 0, 0);
    textAlign(CENTER, CENTER);
    text(windowWidth + " * " + windowHeight, startButtonX + buttonWidth / 2, startButtonY + buttonHeight / 2 - 5);

    fill(0, 0, 0);
    textAlign(CENTER, CENTER);
    String text = gameType == 0 ? "Text Adventure" : "Shooting";

    text("Game type: " + text, startButtonX + buttonWidth / 2, gameTypeButtonY + buttonHeight / 2 - 5);


    String seedText = seed < 0 ? "Random" : seed + "";
    fill(0, 0, 0);
    textAlign(CENTER, CENTER);
    text("Seed: " + seedText, startButtonX + buttonWidth / 2, seedButtonY + buttonHeight / 2 - 5);

    fill(0, 0, 0);
    textAlign(CENTER, CENTER);
    text("+", startButtonX + buttonWidth - 25, seedButtonY + buttonHeight / 4 - 5);

    fill(0, 0, 0);
    textAlign(CENTER, CENTER);
    text("-", startButtonX + buttonWidth - 25, seedButtonY + 3 * (buttonHeight / 4) - 5 );

    fill(0, 0, 0);
    textAlign(CENTER, CENTER);
    text("Back to main menu", startButtonX + buttonWidth / 2, settingButtonY + buttonHeight / 2 - 5);
  } else if (gameState == TEXT_FIGHT) {
    background(0);
    textInFight();
    fill(0);
  } else if (gameState == INFO) {

    background(255);


    textAlign(CENTER, CENTER);
    fill(0);
    text("PRESS 'E' to go to main menu", width / 2, height / 2 - 200);
    int infoWidthSize = width / 2;
    int infoHeightSize = height / 2;

    int leftPosition = width / 2 - (infoWidthSize / 2);
    int topPosition = height / 2 - (infoHeightSize / 2);

    fill(80);
    rect(leftPosition, topPosition, infoWidthSize, infoHeightSize);
    fill(255, 0, 0);
    for (int i = 0; i < hero.currentHealth; i++) {
      noStroke();
      beginShape();
      vertex(leftPosition + 30 + (50 * i), topPosition + 15);
      bezierVertex(leftPosition + 30 + (50 * i), topPosition + -5, leftPosition + 70 + (50 * i), topPosition + 5, leftPosition + 30 + (50 * i), topPosition + 40);
      vertex(leftPosition + 30 + (50 * i), topPosition + 15);
      bezierVertex(leftPosition + 30 + (50 * i), topPosition + -5, leftPosition - 10 + (50 * i), topPosition + 5, leftPosition + 30 + (50 * i), topPosition + 40);
      endShape();
    }

    int powerIndex = 0;
    fill(255);
    text("Power up", leftPosition + infoWidthSize / 2 - 70, topPosition + 45);
    text("Status", leftPosition +infoWidthSize / 2 - 70, topPosition + 65);
    for (Integer power : hero.powerUp) {
      for (int counts = 0; counts < hero.powerUpCount[power]; counts++) {
        fill(247, 151, 7);
        stroke(0, 0, 0, 100);
        ellipse(leftPosition + infoWidthSize / 2 + (10 * counts), topPosition + 60 + (40 * powerIndex), 30, 30);
        String powerText = "";
        fill(255);
        switch (power) {
        case DOUBLE_SHOT:
          powerText = "D";
          break;
        case TRIPLE_SHOT:
          powerText = "T";
          break;
        case BOUNCING_SHOT:
          powerText = "B";
          break;
        case ATTACK:
          powerText = "A";
          break;
        case SPEED:
          powerText = "S";
          break;
        case HASTE:
          powerText = "H";
          break;
        case HEALTH_PACK:
          powerText = "E";
          break;
        case ACCURACY:
          powerText = "+";
          break;
        }
        textSize(20);
        text(powerText, leftPosition + infoWidthSize / 2 + (10 * counts), topPosition + 60 + (40 * powerIndex) - 5);
      }
      powerIndex++;
    }

    if (hero.hasKey) {
      fill(round(random(0, 255)), round(random(0, 255)), round(random(0, 255)));
      textSize(20);
      ellipse(leftPosition + infoWidthSize - 50, topPosition + 25, 30, 30);
      fill(255);
      textSize(18);
      text("KEY", leftPosition + infoWidthSize - 50, topPosition + 22);
    }

    textAlign(LEFT);
    fill(255);
    textSize(20);
    text("Hero Stats", leftPosition + 10, topPosition + 65);
    text("Speed " + hero.heroStartVelocity, leftPosition + 10, topPosition + 95);
    int evade = hero.hasteVisual / 2 >= 90 ? 90 : hero.hasteVisual / 2;
    text("Haste " + evade, leftPosition + 10, topPosition + 115);
    text("Accuarcy " + hero.accuracy, leftPosition + 10, topPosition + 135);
    if (gameType == SHOOTING) {
      text("Damge " + hero.attackDamge, leftPosition + 10, topPosition + 155);
    }
    textAlign(CENTER, CENTER);
  } else if (gameState == GAME_OVER) {
    background(0);
    textSize(128);
    textAlign(CENTER);
    fill(255, 0, 0);
    text("YOU DIED", width / 2, height / 2);
    textSize(40);
    text("Press space key to go to main menu", width / 2, height / 2 + 50);
    textSize(20);
    text("Level: " + level, width / 2, height / 2 + 80);
    text("Score: " + score, width / 2, height / 2 + 100);
  } else if (gameState == WIN) {
    background(255);
    textSize(128);
    textAlign(CENTER);
    fill(0, 255, 0);
    stroke(20);
    text("YOU WON", width / 2, height / 2);
    textSize(40);
    text("Press space key to go to main menu", width / 2, height / 2 + 50);
    textSize(20);
    text("Level: " + level, width / 2, height / 2 + 80);
    text("Score: " + score, width / 2, height / 2 + 100);
    noStroke();
  } else if (gameState == INGAME) {

    if (enemyGenerator.enemies.size() == 0) {
      level++;
      hero.hasKey = false;
      updateMap();
    }

    for (PowerUp power : powerUp) {
      if (power.check()) {
        powerUp.remove(power);
        break;
      }
    }

    if (hero.currentHealth  <= 0) {
      gameState = GAME_OVER;
      return;
    }

    background(255);
    hero.integrate();

    for (Enemy enemy : enemyGenerator.enemies) {
      if (enemy.currentHealth < 0) {
        if (enemy.type == 2) {
          powerUp.add(new PowerUp(round(random(0, 5)), (int) enemy.position.x, (int) enemy.position.y));
          score += 10;
        }
        enemyGenerator.enemies.remove(enemy);
        score += 5;
        break;
      }
      enemy.integrate(new PVector(hero.position.x - enemy.position.x, hero.position.y - enemy.position.y), 0);
    }

    for (int i = 0; i < bullets.size(); i++) {
      if (!bullets.get(i).integrate()) {
        bullets.remove(i);
        break;
      }
    }




    for (int row = 0; row < map.boardHeight; row++) {
      for (int column = 0; column < map.boardWidth; column++) {
        noStroke();
        //stroke(0);
        if (map.board[row][column] == 0) {
          fill(0);
        } else if (map.board[row][column] >= 1) {
          fill(255);
        } else if (map.board[row][column] == 2) { // vertical
          fill(255, 0, 255); // purple
        } else if (map.board[row][column] == 3) { // horizontal
          fill(0, 255, 255); //cyan
        }
        // x = column
        // y = row
        rect(column * map.boardSize, row * map.boardSize, map.boardSize, map.boardSize);
      }
    }

    for (Enemy enemy : enemyGenerator.enemies) {
      if (enemy.type == 2) {
        fill(95, 0, 163);
        ellipse(enemy.position.x, enemy.position.y, 30, 30);
      } else {
        fill(255, 0, 0);
        ellipse(enemy.position.x, enemy.position.y, 20, 20);
      }
    }

    for (PowerUp powerUp : powerUp) {
      fill(247, 151, 7);
      ellipse(powerUp.position.x, powerUp.position.y, 30, 30);

      textAlign(CENTER, CENTER);
      textSize(20);
      stroke(0);
      fill(255, 255, 255);

      switch (powerUp.type) {
      case DOUBLE_SHOT:
        text("D", powerUp.position.x, powerUp.position.y - 3);
        break;
      case TRIPLE_SHOT:
        text("T", powerUp.position.x, powerUp.position.y - 3);
        break;
      case BOUNCING_SHOT:
        text("B", powerUp.position.x, powerUp.position.y - 3);
        break;
      case SPEED:
        text("S", powerUp.position.x, powerUp.position.y - 3);
        break;
      case HASTE:
        text("H", powerUp.position.x, powerUp.position.y - 3);
        break;
      case ATTACK:
        text("A", powerUp.position.x, powerUp.position.y - 3);
        break;
      case HEALTH_PACK:
        text("E", powerUp.position.x, powerUp.position.y - 3);
        break;
      case ACCURACY:
        text("+", powerUp.position.x, powerUp.position.y - 3);
        break;
      }
    }

    for (int bullet = 0; bullet < hero.ammo; bullet++) {
      fill(239, 245, 66, 180);
      stroke(0);
      rect(windowWidth - 40, windowHeight - (34 + 20 * bullet), 30, 14);
    }

    fill(255, 0, 0, 180);
    rect(windowWidth - 80, windowHeight - (20 + hero.hasteVisual), 20, hero.hasteVisual);

    noStroke();

    for (int i = 0; i < bullets.size(); i++) {
      fill(255, 0, 255);
      ellipse(bullets.get(i).position.x, bullets.get(i).position.y, 10, 10);
    }

    switch (hero.currentHealth) {
    case 5:
      fill(0, 0, 255);
      break;
    case 4:
      fill(20, 63, 255);
      break;
    case 3:
      fill(0, 127, 255);
      break;
    case 2:
      fill(0, 191, 255);
      break;
    case 1:
      fill(0, 255, 255);
      break;
    default:
      fill(255, 0, 255);
      break;
    }

    float x = hero.position.x, y = hero.position.y;
    gunX = (int)(x + 10 * cos(hero.orientation));
    gunY = (int)(y + 10 * sin(hero.orientation));


    ellipse(x, y, 30, 30) ;

    fill(239, 245, 66);
    ellipse(gunX, gunY, 10, 10);

    fill(200, 20, 66, 50);
    rect(exit.x, exit.y, 40, 40);
    fill(255);

    textAlign(CENTER, CENTER);
    textSize(20);
    text("EXIT", exit.x + 40 / 2, exit.y + 40 / 2 - 4);

    if (!hero.hasKey) {
      fill(round(random(0, 255)), round(random(0, 255)), round(random(0, 255)));
      ellipse(keyObject.x, keyObject.y, 18, 18);


      fill(255);
      textAlign(CENTER, CENTER);
      textSize(10);
      text("KEY", keyObject.x, keyObject.y - 1);
    }
    fill(255);
    textSize(20);
    text("LEVEL: " + level, 40, 7);
  }
}

void update() {
  if ( overButton(startButtonX, startButtonY, buttonWidth, buttonHeight) ) {
    startOver = true;
    gameTypeOver = false;
    settingOver = false;
    seedOver = false;
    seedUpOver = false;
    seedDownOver = false;
  } else if (overButton(startButtonX, gameTypeButtonY, buttonWidth, buttonHeight)) {
    startOver = false;
    gameTypeOver = true;
    settingOver = false;
    seedOver = false;
    seedUpOver = false;
    seedDownOver = false;
  } else if (overButton(startButtonX, settingButtonY, buttonWidth, buttonHeight)) {
    startOver = false;
    gameTypeOver = false;
    settingOver = true;
    seedOver = false;
    seedUpOver = false;
    seedDownOver = false;
  } else if (overButton(startButtonX, seedButtonY, buttonWidth - 50, buttonHeight)) {
    startOver = false;
    gameTypeOver = false;
    settingOver = false;
    seedOver = true;
    seedUpOver = false;
    seedDownOver = false;
  } else if (overButton(startButtonX + buttonWidth - 50, seedButtonY, 50, buttonHeight / 2)) {
    startOver = false;
    gameTypeOver = false;
    settingOver = false;
    seedOver = false;
    seedUpOver = true;
    seedDownOver = false;
  } else if (overButton(startButtonX, seedButtonY, buttonWidth, buttonHeight)) {
    startOver = false;
    gameTypeOver = false;
    settingOver = false;
    seedOver = false;
    seedUpOver = false;
    seedDownOver = true;
  } else {
    startOver = settingOver = gameTypeOver = seedOver = seedUpOver = seedDownOver = false;
  }
}

boolean overButton(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width &&
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

void updateMap() {
  if (level >= 11) {
    gameState = WIN;
  }

  map = new Map(seed);
  map.generateMap();
  hero.position.x = 100;
  hero.position.y = 100;

  int xExit = round(random(map.rooms.get(map.rooms.size() - 1).xStart + 1, map.rooms.get(map.rooms.size() - 1).xEnd - 1 ));
  int yExit = round(random(map.rooms.get(map.rooms.size() - 1).yStart + 1, map.rooms.get(map.rooms.size() - 1).yEnd - 1 ));

  exit = new PVector((int) (xExit * map.boardSize), (int) (yExit * map.boardSize));

  int keyRoom = map.rooms.size() / 2 + 1;

  int xKey = round(random(map.rooms.get(keyRoom).xStart + 1, map.rooms.get(keyRoom).xEnd - 1 ));
  int yKey = round(random(map.rooms.get(keyRoom).yStart + 1, map.rooms.get(keyRoom).yEnd - 1 ));

  keyObject = new PVector((int) (xKey * map.boardSize), (int) (yKey * map.boardSize));
  bullets = new ArrayList<>();
  powerUp = new ArrayList<>();
  enemyGenerator = new EnemyGenerator(map.rooms);
  enemyGenerator.generates(level);

  bullets.removeAll(bullets);
}

void textInFight() {
  smooth();
  noStroke();
  fill(255, 0, 0);

  for (int i = 0; i < hero.currentHealth; i++) {
    beginShape();
    vertex(50 + (50 * i), 15);
    bezierVertex(50 + (50 * i), -5, 90 + (50 * i), 5, 50 + (50 * i), 40);
    vertex(50 + (50 * i), 15);
    bezierVertex(50 + (50 * i), -5, 10 + (50 * i), 5, 50 + (50 * i), 40);
    endShape();
  }
  switch (fightState) {
  case SELECT:
    if (hero.currentHealth == 0) {
      gameState = INGAME;
    }
    int evade = hero.hasteVisual / 2 >= 90 ? 90 : hero.hasteVisual / 2;
    int runaway = hero.hasteVisual / 10 >= 90 ? 90 : hero.hasteVisual / 10;
    fill(255);
    textSize(30);
    text("(1): Shoot a gun (" + hero.accuracy + "%)", width / 2, height / 4);
    fill(255);
    textSize(30);
    text("(2): Defence (" + evade +"%) to evade the attack", width / 2, height / 4 + 60);
    fill(255);
    textSize(30);
    text("(3): Run away (" + runaway + "%)", width / 2, height / 4 + 120);
    break;
  case SHOOT:
    shootGun();
    break;
  case DEFEND:
    defend();
    break;
  case RUNAWAY:
    runAway();
    break;
  }
}

void shootGun() {
  if (shotResult <= hero.accuracy) {
    fill(255);
    rect(width / 2 - 150, (height / 2) - 150, 300, 300);

    fill(0, 0, 255);
    ellipse(heroAni.x, heroAni.y, 30, 30);

    if (fightAgainst.type != 2) {
      fill(255, 0, 0);
      ellipse(enemyAni.x, enemyAni.y, 30, 30);
    } else {
      fill(95, 0, 163);
      ellipse(enemyAni.x, enemyAni.y, 40, 40);
    }

    fill(255, 255, 0);

    bulletAni.x += 3;
    bulletAni.y -= 3;

    ellipse(bulletAni.x++, bulletAni.y--, 10, 10);

    if (dist(bulletAni.x, bulletAni.y, enemyAni.x, enemyAni.y) < 20) {
      enemyGenerator.enemies.remove(fightAgainst);


      if (fightAgainst.type == 2) {
        powerUp.add(new PowerUp(round(random(3.5, 7.49)), (int) fightAgainst.position.x + 20, (int) fightAgainst.position.y + 20));
        score += 10;
      }
      score += 5;
      fightState = SELECT;
      gameState = INGAME;
    }
  } else {
    fill(255);
    rect(width / 2 - 150, (height / 2) - 150, 300, 300);
    fill(0, 0, 255);
    ellipse(heroAni.x, heroAni.y, 30, 30);
    if (fightAgainst.type != 2) {
      fill(255, 0, 0);
      ellipse(enemyAni.x, enemyAni.y, 30, 30);
    } else {
      fill(95, 0, 163);
      ellipse(enemyAni.x, enemyAni.y, 40, 40);
    }
    fill(255, 255, 0);
    bulletAni.x += 2.5;
    bulletAni.y -= 3;
    ellipse(bulletAni.x, bulletAni.y--, 10, 10);

    if (bulletAni.y <= height / 2 - 150) {
      enemyShoot();
    }
  }
}

void enemyShoot() {
  if (enemyShotResult <= fightAgainst.accuracy) {
    fill(255, 255, 0);
    enemyBulletAni.x -= 6;
    enemyBulletAni.y += 6;
    ellipse(enemyBulletAni.x++, enemyBulletAni.y--, 10, 10);
    if (dist(enemyBulletAni.x, enemyBulletAni.y, heroAni.x, heroAni.y) < 20) {
      if (!(evadeResult <= hero.hasteVisual/2 && fightState == DEFEND)) {
        hero.currentHealth--;

        fightState = SELECT;
      }
    }
    if (enemyBulletAni.y >= height / 2 + 150) {
      fightState = SELECT;
    }
  } else {
    fill(255, 255, 0);
    enemyBulletAni.x -= 5;
    enemyBulletAni.y += 6;
    ellipse(enemyBulletAni.x, enemyBulletAni.y, 10, 10);

    if (enemyBulletAni.y >= height / 2 + 150) {
      fightState = SELECT;
    }
  }
}

void defend() {
  int evade = hero.hasteVisual / 2 >= 90 ? 90 : hero.hasteVisual / 2;

  if (evadeResult <= evade) {
    fill(255);
    rect(width / 2 - 150, (height / 2) - 150, 300, 300);

    fill(0, 0, 255, 50);
    ellipse(heroAni.x, heroAni.y, 30, 30);

    if (fightAgainst.type != 2) {
      fill(255, 0, 0);
      ellipse(enemyAni.x, enemyAni.y, 30, 30);
    } else {
      fill(95, 0, 163);
      ellipse(enemyAni.x, enemyAni.y, 40, 40);
    }
    enemyShoot();
  } else {
    fill(255);
    rect(width / 2 - 150, (height / 2) - 150, 300, 300);
    fill(0, 0, 255);
    ellipse(heroAni.x, heroAni.y, 30, 30);
    if (fightAgainst.type != 2) {
      fill(255, 0, 0);
      ellipse(enemyAni.x, enemyAni.y, 30, 30);
    } else {
      fill(95, 0, 163);
      ellipse(enemyAni.x, enemyAni.y, 40, 40);
    }

    enemyShoot();
  }
}

void runAway() {
  int runaway = hero.hasteVisual / 10 >= 90 ? 90 : hero.hasteVisual / 10;

  if (runawayResult <= runaway) {
    fill(255);
    rect(width / 2 - 150, (height / 2) - 150, 300, 300);

    fill(0, 0, 255);
    ellipse(heroAni.x -= 3, heroAni.y, 30, 30);


    if (fightAgainst.type != 2) {
      fill(255, 0, 0);
      ellipse(enemyAni.x, enemyAni.y, 30, 30);
    } else {
      fill(95, 0, 163);
      ellipse(enemyAni.x, enemyAni.y, 40, 40);
    }

    if (heroAni.x < width / 2 - 200) {
      fightState = SELECT;
      gameState = INGAME;

      enemyGenerator.enemies.remove(fightAgainst);
    }
  } else {
    fill(255);
    rect(width / 2 - 150, (height / 2) - 150, 300, 300);
    fill(0, 0, 255);
    ellipse(heroAni.x, heroAni.y, 30, 30);
    if (fightAgainst.type != 2) {
      fill(255, 0, 0);
      ellipse(enemyAni.x, enemyAni.y, 30, 30);
    } else {
      fill(95, 0, 163);
      ellipse(enemyAni.x, enemyAni.y, 40, 40);
    }

    enemyShoot();
  }
}

void keyPressed() {
  switch (gameState) {
  case INGAME:
    PVector newVel;
    switch (key) {
    case CODED:
      if (keyCode == SHIFT) {
        if (!hero.haste) {
          if (!hero.hasteReload) {
            heroVelocity = hero.heroStartVelocity + 3;
            hero.haste = true;
            hero.hasteStartTime = millis();
          }
        }
      }
      break;
    case 'W':
    case 'w':
      newVel = new PVector(0, -heroVelocity) ;

      if (down) {
        newVel.add(new PVector(0, heroVelocity));
      }

      if (left) {
        newVel.add(new PVector(-heroVelocity, 0));
      }

      if (right) {
        newVel.add(new PVector(heroVelocity, 0));
      }

      hero.velocity = newVel ;
      up = true;
      break;
    case 'A':
    case 'a':
      newVel = new PVector(-heroVelocity, 0) ;

      if (down) {
        newVel.add(new PVector(0, heroVelocity));
      }

      if (up) {
        newVel.add(new PVector(0, -heroVelocity));
      }

      if (right) {
        newVel.add(new PVector(heroVelocity, 0));
      }

      hero.velocity = newVel ;
      left = true;
      break;
    case 'S':
    case 's':
      newVel = new PVector(0, heroVelocity) ;

      if (left) {
        newVel.add(new PVector(-heroVelocity, 0));
      }

      if (up) {
        newVel.add(new PVector(0, -heroVelocity));
      }

      if (right) {
        newVel.add(new PVector(heroVelocity, 0));
      }

      hero.velocity = newVel ;
      down = true;
      break;
    case 'D':
    case 'd':
      newVel = new PVector(heroVelocity, 0) ;

      if (down) {
        newVel.add(new PVector(0, heroVelocity));
      }

      if (up) {
        newVel.add(new PVector(0, -heroVelocity));
      }

      if (left) {
        newVel.add(new PVector(-heroVelocity, 0));
      }

      hero.velocity = newVel ;
      right = true;
      break;
    }
    break;
  }
}

void keyReleased() {
  switch (gameState) {
  case WIN:
  case GAME_OVER:
    right = false;
    up = false;
    left = false;
    down = false;
    switch (key) {
    case ' ':
      gameState = MAIN;
      level = 1;
      setup();
      break;
    case 'R':
    case 'r':

      level = 1;
      setup();
      gameState = INGAME;
      break;
    default:

      break;
    }
    break;

  case TEXT_FIGHT:
    right = false;
    up = false;
    left = false;
    down = false;
    hero.haste = false;
    switch (key) {


    case '1':
      if (fightState == SELECT) {
        shotResult = round(random(0, 100));


        fightState = SHOOT;


        heroAni = new PVector(width / 2 - 120, height / 2 + 120);
        enemyAni = fightAgainst.type == 2 ?  new PVector(width / 2 + 120, height / 2 - 120):  new PVector(width / 2 + 110, height / 2 - 110);
        bulletAni = new PVector(width / 2 - 105, height / 2 + 105);

        if (shotResult > hero.accuracy) {
          enemyShotResult = round(random(0, 100));

          enemyBulletAni = new PVector(width / 2 + 110, height / 2 - 110);
        }
      }
      break;
    case '2':
      if (fightState == SELECT) {
        fightState = DEFEND;

        evadeResult = round(random(0, 100));

        heroAni = new PVector(width / 2 - 120, height / 2 + 120);
        enemyAni = fightAgainst.type == 2 ?  new PVector(width / 2 + 120, height / 2 - 120):  new PVector(width / 2 + 110, height / 2 - 110);
        bulletAni = new PVector(width / 2 - 105, height / 2 + 105);

        enemyShotResult = round(random(0, 100));

        enemyBulletAni = new PVector(width / 2 + 110, height / 2 - 110);
      }
      break;

    case '3':
      if (fightState == SELECT) {
        fightState = RUNAWAY;

        runawayResult = round(random(0, 100));

        heroAni = new PVector(width / 2 - 120, height / 2 + 120);
        enemyAni = fightAgainst.type == 2 ?  new PVector(width / 2 + 120, height / 2 - 120):  new PVector(width / 2 + 110, height / 2 - 110);
        bulletAni = new PVector(width / 2 - 105, height / 2 + 105);

        enemyShotResult = round(random(0, 100));

        enemyBulletAni = new PVector(width / 2 + 110, height / 2 - 110);
      }
      break;
    }
    break;
  case INFO:
    switch (key) {
    case TAB:
      gameState = INGAME;
      break;

    case 'E':
    case 'e':
      gameState = MAIN;
      break;
    }
    break;

  case INGAME:
    PVector newVel;
    switch (key) {
    case CODED:
      if (keyCode == SHIFT) {
        heroVelocity = hero.heroStartVelocity;
        hero.hasteEndTime = millis();
        hero.hasteReload = true;
        hero.haste = false;
      }
      break;
    case TAB:
      gameState = INFO;
      break;

    case 'W':
    case 'w':
      newVel = new PVector(0, heroVelocity) ;

      //if (hero.velocity.y < 0) {
      hero.velocity.add(newVel);
      //}
      up = false;
      break;
    case 'A':
    case 'a':
      newVel = new PVector(heroVelocity, 0) ;

      //if (hero.velocity.x < 0) {
      hero.velocity.add(newVel);
      //}
      left = false;
      break;
    case 'S':
    case 's':
      newVel = new PVector(0, -heroVelocity) ;
      //if (hero.velocity.y > 0) {
      hero.velocity.add(newVel);
      //}
      down = false;
      break;
    case 'D':
    case 'd':
      newVel = new PVector(-heroVelocity, 0) ;

      //if (hero.velocity.x > 0) {
      hero.velocity.add(newVel);
      //}
      right = false;

      break;

    case ' ':
      boolean isPowerdUp = false;
      if (!hero.reload) {

        for (int power : hero.powerUp) {
          switch(power) {
          case DOUBLE_SHOT:
            bullets.add(new Bullet((int) hero.position.x, (int) hero.position.y, 0, 0, new PVector(gunX + 25, gunY + 25), 0));
            bullets.add(new Bullet((int) hero.position.x, (int) hero.position.y, 0, 0, new PVector(gunX - 25, gunY - 25), 0));
            hero.ammo -= 2;
            isPowerdUp = true;
            break;
          case TRIPLE_SHOT:
            bullets.add(new Bullet((int) hero.position.x, (int) hero.position.y, 0, 0, new PVector(gunX, gunY + 50), 0));
            bullets.add(new Bullet((int) hero.position.x, (int) hero.position.y, 0, 0, new PVector(gunX, gunY), 0));
            bullets.add(new Bullet((int) hero.position.x, (int) hero.position.y, 0, 0, new PVector(gunX, gunY - 50), 0));
            hero.ammo -= 3;
            isPowerdUp = true;
            break;
          case BOUNCING_SHOT:
            bullets.add(new Bullet((int) hero.position.x, (int) hero.position.y, 0, 0, new PVector(gunX, gunY), BOUNCING_SHOT));

            isPowerdUp = true;

            break;
          default:
            isPowerdUp = true;
            bullets.add(new Bullet((int) hero.position.x, (int) hero.position.y, 0, 0, new PVector(gunX, gunY), 0));
            hero.ammo -= 1;
            break;
          }
        }

        if (!isPowerdUp) {
          bullets.add(new Bullet((int) hero.position.x, (int) hero.position.y, 0, 0, new PVector(gunX, gunY), 0));

          hero.ammo -= 1;
        }
      }
      break;
    }
    break;
  }
}

void mousePressed() {
  switch (gameState) {
  case INGAME:
    if (gameType == SHOOTING) {
      boolean isPowerdUp = false;
      if (mouseButton == LEFT) {
        if (!hero.reload) {
          int zeoringParameter = 10 - (hero.accuracy / 10);
          int xZeroing = round(random(-zeoringParameter, zeoringParameter));
          int yZeroing = round(random(-zeoringParameter, zeoringParameter));
          xZeroing *= 10;
          yZeroing *= 10;
          for (int power : hero.powerUp) {
            switch(power) {
            case DOUBLE_SHOT:
              bullets.add(new Bullet((int) hero.position.x, (int) hero.position.y, 0, 0, new PVector(mouseX + 25 + xZeroing, mouseY + 25 + yZeroing), 0));
              bullets.add(new Bullet((int) hero.position.x, (int) hero.position.y, 0, 0, new PVector(mouseX - 25 - xZeroing, mouseY - 25 - yZeroing), 0));
              hero.ammo -= 2;
              isPowerdUp = true;
              break;
            case TRIPLE_SHOT:
              bullets.add(new Bullet((int) hero.position.x, (int) hero.position.y, 0, 0, new PVector(mouseX + xZeroing, mouseY + 50 + yZeroing), 0));
              bullets.add(new Bullet((int) hero.position.x, (int) hero.position.y, 0, 0, new PVector(mouseX + xZeroing, mouseY), 0));
              bullets.add(new Bullet((int) hero.position.x, (int) hero.position.y, 0, 0, new PVector(mouseX + xZeroing, mouseY - 50 - yZeroing), 0));
              hero.ammo -= 3;
              isPowerdUp = true;
              break;
            case BOUNCING_SHOT:
              bullets.add(new Bullet((int) hero.position.x, (int) hero.position.y, 0, 0, new PVector(mouseX + xZeroing, mouseY + yZeroing), BOUNCING_SHOT));

              isPowerdUp = true;

              break;
            default:
              isPowerdUp = true;
              bullets.add(new Bullet((int) hero.position.x, (int) hero.position.y, 0, 0, new PVector(mouseX + xZeroing, mouseY + yZeroing), 0));
              hero.ammo -= 1;
              break;
            }
          }

          if (!isPowerdUp) {
            bullets.add(new Bullet((int) hero.position.x, (int) hero.position.y, 0, 0, new PVector(mouseX + xZeroing, mouseY + yZeroing), 0));

            hero.ammo -= 1;
          }
        }

        break;
      } else if (mouseButton == RIGHT) {
        if (!hero.haste) {
          if (!hero.hasteReload) {
            heroVelocity = hero.heroStartVelocity + 3;
            hero.haste = true;
            hero.hasteStartTime = millis();
          }
        }
      }
    }
  }
}

void mouseReleased() {
  switch (gameState) {
  case MAIN:
    if (startOver) {
      level = 1;
      setup();
      gameState = INGAME;
    }
    if (settingOver) {
      gameState = SETTING;
    }

    break;
  case INGAME:
    if (gameType == SHOOTING) {
      if (mouseButton == RIGHT) {
        heroVelocity = hero.heroStartVelocity;
        hero.hasteEndTime = millis();
        hero.hasteReload = true;
        hero.haste = false;
      }
    }
    break;
  case SETTING:
    if (startOver) {
      if (windowWidth == 1600 && windowHeight == 900) {
        windowWidth = 1280;
        windowHeight = 720;
        //break;
      } else if (windowWidth == 1280 && windowHeight == 720) {
        windowWidth = 800;
        windowHeight = 600;
        //break;
      } else {
        windowWidth = 1600;
        windowHeight = 900;
        //break;
      }

      startButtonX = windowWidth/2 - buttonWidth/2;
      startButtonY = buttonHeight * 2;


      settingButtonY = buttonHeight * 6;



      surface.setSize(windowWidth, windowHeight);
      //1600, 1200
      //1080, 720
      //600, 800
    }

    if (gameTypeOver) {
      switch (gameType) {
      case TEXT_ADV:
        gameType = SHOOTING;
        break;
      case SHOOTING:
        gameType = TEXT_ADV;
        break;
      default:
        break;
      }
    }

    if (seedUpOver) {
      seed++;
    }

    if (seedDownOver) {
      seed--;
      if (seed < 0) {
        seed = -1;
      }
    }

    if (settingOver) {
      gameState = MAIN;
    }
    break;
  }
}
