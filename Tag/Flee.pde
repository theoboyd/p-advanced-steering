/*
 * The Flee Steering Behaviour
 */
class Flee extends Steering {
  
  // Position/size of target
  Agent target;
  float radius;
  
  // Initialisation
  Flee(Agent a, Agent t, float r) {
    super(a);
    target = t;
    radius = r;
  }
  
  PVector calculateRawForce() {
    // Check that agent's centre is not over target
    if (PVector.dist(target.position, agent.position) > radius) {
      // Calculate Flee Force
      PVector flee = PVector.sub(agent.position, target.position);
      flee.normalize();
      flee.mult(agent.maxSpeed);
      flee.sub(agent.velocity);
      return flee;
    } else  {
      // If agent's centre is over target stop seeking
      return new PVector(0, 0);
    }   
  }
  
  // No need to draw the target
  void draw() {
  }
}
