/*
 * The Wander Steering Behaviour
 */
class Wander extends Steering {
  
  // Position/size of target
  PVector target;
  float radius;
  PVector c;
  
  // Initialisation
  Wander(Agent a, PVector t, float r) {
      super(a);
      target = t;
      radius = r;
      c = agent.position.get();
  }
  
  PVector randomJitterOffset() {
    // Creates the (alpha*x, alpha*y) offset
    float alphax = random(-1, 1) * agent.targetJitter;
    float alphay = random(-1, 1) * agent.targetJitter;
    return new PVector(alphax, alphay);
  }
  
  PVector calculateRawForce() {
    // Check that agent's centre is not over target
    if (PVector.dist(target, agent.position) > radius) {
      // Calculate Wander Force (using notation from Ludic Computing slides)
      
      // Choose a centre-to-point vector c
      PVector direction = new PVector(agent.velocity.x, agent.velocity.y);
      direction.normalize();
      direction.mult(agent.wanderRadius - agent.wanderDistance);
      c.add(direction);
      
      
      // Now randomise it
      c.add(randomJitterOffset());
      // Project back onto circle
      c.normalize();
      c.mult(agent.wanderRadius);
      
      // Find centre of wander circle
      PVector dWUnitV = agent.velocity.get();
      dWUnitV.normalize();
      dWUnitV.mult(agent.wanderDistance);
      PVector pW = PVector.add(agent.position, dWUnitV);
      
      // Create target
      target = PVector.add(pW, c);
      
      /*
      // Display wander circle
      pushStyle();
      color c1 = #AAAAFF;
      color c2 = #EEEEFF;
      stroke(c1);
      fill(c2);
      ellipse(pW.x, pW.y, agent.wanderRadius, agent.wanderRadius);
      popStyle();
      */
      
      // Seek to target
      PVector wander = PVector.sub(target, agent.position);
      wander.normalize();
      wander.mult(agent.maxSpeed);
      wander.sub(agent.velocity);
      return wander;
    } else  {
      // If agent's centre is over target stop arriving
      return new PVector(0,0); 
    }   
  }
  
  // Don't draw the target
  void draw() {
    // Wander doesn't have a user-specified target
  }
}
