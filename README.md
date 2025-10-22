# **Warp God**
_By a psyker, for the psykers_

---

## **Features**
- **Prevent Peril of the Warp Explosion option**
  - Prevents perils-of-the-warp explosions by disabling additional peril generating inputs when exceeding a user determined peril-threshold.
 
## **Bugs**
- **Exiting Warp Unbound risk of explosion**
  - In version older than 3.0, we always had a strict debounce during the transition between having the 10s of Warp Unbound buff, and not having it.
  - Without this debounce there is a small window where you can input peril generating attacks, causing an explosion.
  - Version 3.0+ doesnt have this debounce, so there is a small risk of exploding.
  - Advantage of not having the debounce is that if you are way below your peril-threshold, you can hold down keys (smiting, charging attacks) without the debounce interrupting your input.
  - Drawback is the risk of exploding.
  - I have not found a elegant fix to this issue yet.


## **Versions older than 3.0 had the following features**
- **Warp Unbound Talent Bug Hotfix option (Bug now fixed)**
  - Fixes a bug affecting the Electrokinetic Staff, Purgatus Staff, and Smite; where you can still explode during a small time-interval even if Warp Unbound is activated.
  - Prevents unexpected explosions by disabling additional inputs which would generate peril for a small time window when the bug usually occurs.
- **Auto Quelling option**
- **Auto Warp Unbound activation option**
- **Auto Venting Shriek activation option**
