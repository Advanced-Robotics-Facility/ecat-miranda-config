SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
export ADVRF_CONFIG_ROOT="$SCRIPT_DIR"

export EC_CFG="$ADVRF_CONFIG_ROOT/ec_cfg.yaml"
export ROBOT_MASTER_CONFIG="$ADVRF_CONFIG_ROOT/robot_ecat/ecat_config.yaml"

export MIDDLEWARE_CONFIG="$ADVRF_CONFIG_ROOT/middleware/config.yaml"

export ROBOT_DESCRIPTION="$ADVRF_CONFIG_ROOT/ros2/urdf/miranda.urdf.xacro"
export ROBOT_SRDF="$ADVRF_CONFIG_ROOT/ros2/srdf/miranda.srdf"
export ROS2_CONTROLLERS="$ADVRF_CONFIG_ROOT/ros2/config/ros2_controllers.yaml"
export MOVEIT_CONTROLLERS="$ADVRF_CONFIG_ROOT/ros2/config/moveit_controllers.yaml"

alias robot_master='repl -f "$ROBOT_MASTER_CONFIG"'
alias robot_master_gdb='gdb --args repl -f "$ROBOT_MASTER_CONFIG"'
