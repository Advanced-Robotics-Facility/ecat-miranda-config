# Miranda launchers

Run these commands from `ros2/launcher`. Start the EtherCAT master and middleware
separately. Motors are never started automatically.

## Complete stack

Robot state publisher + RViz + motor controllers/services + panel:

```bash
./start.sh
./start.sh control_mode:=impedance
```

## Individual launchers

Load the environment first in each terminal (`EC_CFG`, ROS workspace and DDS):

```bash
source ./env.sh
```

**Panel only** — connects to existing controllers:

```bash
ros2 launch advrf_ros2_motors_controller panel.launch.py namespace:=/advrf/miranda
```

**GoTo** — includes the trajectory controller:

```bash
ros2 launch advrf_ros2_motors_controller go_to.launch.py namespace:=/advrf/miranda
```

**Trajectory controller only** — for a trajectory client or MoveIt:

```bash
ros2 launch advrf_ros2_motors_controller trajectory.launch.py namespace:=/advrf/miranda
```

**Direct joint commands** — receives `joint_commands`:

```bash
ros2 launch advrf_ros2_motors_controller joint.launch.py namespace:=/advrf/miranda
```

Choose one standalone motion launcher above; do not add it to an already running
complete stack. Use `./start.sh` for panel-controlled GoTo/direct mode switching.

**Motor power services** — exposes START/STOP without activating motors:

```bash
ros2 launch advrf_ros2_motors_controller motors.launch.py namespace:=/advrf/miranda
```

**Robot state publisher + RViz only:**

```bash
./start.sh controllers:=false panel:=false
```

**Robot state publisher only:**

```bash
./start.sh controllers:=false panel:=false rviz:=false
```

## Complete-stack options

```bash
./start.sh panel:=false                         # No panel
./start.sh rviz:=false                          # No RViz
./start.sh controllers:=false                   # Attach to running controllers
./start.sh robot_state:=false panel:=false rviz:=false  # Controllers/services only
./start.sh --show-args                          # All arguments
```
