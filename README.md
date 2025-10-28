# **Warp God**
_By a psyker, for the psykers_

---

## **Features**
- **Prevent Peril of the Warp Explosion option**
  - Prevents perils-of-the-warp explosions by disabling additional peril generating inputs when exceeding a user determined peril-threshold.
- **Controlled explosions for Crystalline Will talent**
  - Option to allow the player to bypass the peril threshold, and thus allow the user to explode, if there are killable elites within the explosion radius, and if Crystalline will is equipped. (For suicide bomber builds)

## **Requirements**
- **Only DMF**
 
## **Bugs**
- **Exiting Warp Unbound risk of explosion**
  - When exiting Warp Unbound, there is a small delay before the peril threshold will properly block peril-generating inputs again, risking the user of exploding.
  - While not perfect, we have added an option to enable a debounce during this duration, blocking peril-generating inputs.
- **Duelling Sword parry can cause explosion**
  - Duelling sword's parry may still cause explosions from the generated peril. Currently we are not considering Duelling Sword's parry as a peril generating attack as it might be smarter to be able to parry even if it means exploding.
  - In future version I might add an option to toggle if duelling sword's parry is considering a perilous attack. 

## **Versions older than 3.0 had the following features**
- **Warp Unbound Talent Bug Hotfix option (Bug now fixed)**
  - Fixes a bug affecting the Electrokinetic Staff, Purgatus Staff, and Smite; where you can still explode during a small time-interval even if Warp Unbound is activated.
  - Prevents unexpected explosions by disabling additional inputs which would generate peril for a small time window when the bug usually occurs.
- **Auto Quelling option**
- **Auto Warp Unbound activation option**
- **Auto Venting Shriek activation option**
