/*
 * The Pursue Steering Behaviour
 */
class Pursue extends Steering {
  
  // Position/size of target
  Agent target;
  float radius;
  float timeToTargetK;
  
  // Initialisation
  Pursue(Agent a, Agent t, float r, float k) {
    super(a);
    target = t;
    radius = r;
    timeToTargetK = k;
  }
  
  PVector calculateRawForce() {
    // Check that agent's centre is not over target
    if (PVector.dist(target.position, agent.position) > radius) {
      // Calculate Pursue Force
      PVector qPred = target.position.get();
      PVector vQT = target.velocity.get(); // This will represent vQ * min(times)
      float tLim = 10 * timeToTargetK; // Limit
      
       // Time to target formula (from slides)
      
      float qpMag = PVector.sub(target.position, agent.position).mag();
      float vMag = agent.velocity.mag();
      float tPred = (timeToTargetK * qpMag) / vMag;
      
      float minTimes = min(tPred, tLim);
      vQT.mult(minTimes);
      qPred.add(vQT);
      PVector pursue = PVector.sub(qPred, agent.position);
      pursue.normalize();
      pursue.mult(agent.maxSpeed);
      pursue.sub(agent.velocity);
      return pursue;
    } else  {
      // If agent's centre is over target stop seeking
      return new PVector(0, 0);
    }   
  }
  
  // No need to draw the target
  void draw() {
  }
}
