float ballX, ballY;      
float ballSpeedX, ballSpeedY; 
float ballRadius;         
float gravity = 0.16;   
float damping = 1.6;    
float airResistance = 0.01; 

int trailLength = 50;     
float[][] trailPositions;

void setup() {
  size(800, 800);
  resetBall();
}

void draw() {
  
  fill(255, 10); 
  rect(0, 0, width, height);

  
  for (int i = trailLength - 1; i > 0; i--) {
    trailPositions[i][0] = trailPositions[i - 1][0];
    trailPositions[i][1] = trailPositions[i - 1][1];
  }
  trailPositions[0][0] = ballX;
  trailPositions[0][1] = ballY;

 
  ballSpeedY += gravity;


  ballSpeedX *= (1 - airResistance);
  ballSpeedY *= (1 - airResistance);

  ballX += ballSpeedX;
  ballY += ballSpeedY;

  
  float distanceToCenter = dist(ballX, ballY, width / 2, height / 2);
  if (distanceToCenter > width / 2 - ballRadius) {
    float angle = atan2(ballY - height / 2, ballX - width / 2);
    ballX = width / 2 + (width / 2 - ballRadius) * cos(angle);
    ballY = height / 2 + (width / 2 - ballRadius) * sin(angle);

    PVector normal = new PVector(ballX - width / 2, ballY - height / 2);
    normal.normalize();

    PVector incident = new PVector(ballSpeedX, ballSpeedY);
    float dot = incident.dot(normal) * 2.0;

    PVector reflection = new PVector(incident.x - dot * normal.x, incident.y - dot * normal.y);

    ballSpeedX = reflection.x * damping;
    ballSpeedY = reflection.y * damping;

    ballRadius += 1;
  }

  fill(200);
  ellipse(width / 2, height / 2, width, height);

  noStroke();
  for (int i = 0; i < trailLength; i++) {
    float alpha = map(i, 0, trailLength - 1, 255, 0);
    fill(0, 0, 255, alpha);
    ellipse(trailPositions[i][0], trailPositions[i][1], ballRadius * 2, ballRadius * 2);
  }

  fill(0, 0, 255);
  ellipse(ballX, ballY, ballRadius * 2, ballRadius * 2);
}

void resetBall() {
  ballX = width / 2 + 30;
  ballY = height / 2;
  ballRadius = 20;

  trailPositions = new float[trailLength][2];
}
