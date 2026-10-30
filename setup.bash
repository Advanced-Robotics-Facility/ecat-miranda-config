# Source this profile from bash; workspace environment is loaded automatically.
_advrf_profile_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$_advrf_profile_dir/../../setup.bash"
export ADVRF_CONFIG_ROOT="$_advrf_profile_dir"
unset _advrf_profile_dir
unset MIDDLEWARE_CONFIG ROBOT_DESCRIPTION ROBOT_SRDF ROS2_CONTROLLERS MOVEIT_CONTROLLERS ROBOT_MASTER_CONFIG_UDP
# Select the verified backend even when the terminal inherited a legacy RMW.
# Override deliberately with ADVRF_RMW_IMPLEMENTATION before sourcing.
export RMW_IMPLEMENTATION="${ADVRF_RMW_IMPLEMENTATION:-rmw_cyclonedds_cpp}"
export EC_CFG="$ADVRF_CONFIG_ROOT/ec_cfg.yaml"
export ROBOT_MASTER_CONFIG="$ADVRF_CONFIG_ROOT/robot_ecat/ecat_config.yaml"
export ROBOT_DESCRIPTION="$ADVRF_CONFIG_ROOT/ros2/urdf/miranda.urdf.xacro"
export ROBOT_SRDF="$ADVRF_CONFIG_ROOT/ros2/srdf/miranda.srdf"
export ROS2_CONTROLLERS="$ADVRF_CONFIG_ROOT/ros2/config/ros2_controllers.yaml"
export MOVEIT_CONTROLLERS="$ADVRF_CONFIG_ROOT/ros2/config/moveit_controllers.yaml"
# Prefer functions over aliases so profile switching updates the selected file.
unalias robot_master robot_master_gdb 2>/dev/null || true
robot_master() { repl -f "$ROBOT_MASTER_CONFIG" "$@"; }
robot_master_gdb() { gdb --args repl -f "$ROBOT_MASTER_CONFIG" "$@"; }
