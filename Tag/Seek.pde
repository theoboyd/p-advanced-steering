/*
 * The Seek Steering Behaviour
 */
class Seek extends Steering {
  
  // Position/size of target
  PVector target;
  float radius;
  
  // Initialisation
  Seek(Agent a, PVector t, float r) {
    super(a);
    target = t;
    radius = r;
  }
  
  PVector calculateRawForce() {
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
