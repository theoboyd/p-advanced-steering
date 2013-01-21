/*
 * The WallAvoid Steering Behaviour
 */
class WallAvoid extends Steering {
  
  // Position/size of target
  PVector target;
  float radius;
  
  // Initialisation
  WallAvoid(Agent a, PVector t, float r) {
    super(a);
    target = t;
    radius = r;
  }
  
  PVector calculateRawForce() {
    pushStyle();
    color c1 = #AAAAFF;
    color c2 = #EEEEFF;
    stroke(c1);
    fill(c2);
    ellipse(agent.position.x, agent.positon.y, agent.position.x + );
    popStyle();
    
    // Check that agent's centre is not over target
    if (PVector.dist(target, agent.position) > radius) {
      // Calculate Seek Force
      PVector seek = PVector.sub(target, agent.position);
      seek.normalize();
      seek.mult(agent.maxSpeed);
      seek.sub(agent.velocity);
      return seek;
    } else  {
      // If agent's centre is over target stop seeking
      return new PVector(0, 0);
    } 
  }
  
  // No need to draw the target
  void draw() {
  }
}
