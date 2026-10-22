#!/usr/bin/env bash
# Source this file to configure the current terminal.
_miranda_load_env() {
    local launcher_dir config_root workspace_root
    launcher_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)" || return 1
    config_root="$(cd -- "$launcher_dir/../.." && pwd)" || return 1
    workspace_root="${ADVRF_ROS2_WS:-/home/hpousseur-iit.local/ws/ws_advrf_ros2}"
    if [[ ! -f "$workspace_root/install/setup.bash" ]]; then
        echo "ROS workspace not built: $workspace_root/install/setup.bash" >&2
        return 1
    fi
    if [[ ! -f "$config_root/ec_cfg.yaml" ]]; then
        echo "Missing robot configuration: $config_root/ec_cfg.yaml" >&2
        return 1
    fi
    source /opt/ros/jazzy/setup.bash || return 1
    source "$workspace_root/install/setup.bash" || return 1
    export EC_CFG="$config_root/ec_cfg.yaml"
    export ROS2_CFG="$config_root/ros2/config"
    export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
    export ROS_DOMAIN_ID="${ROS_DOMAIN_ID:-42}"
}
_miranda_load_env
_miranda_env_result=$?
unset -f _miranda_load_env
if [[ $_miranda_env_result -ne 0 ]]; then
    unset _miranda_env_result
    return 1 2>/dev/null || exit 1
fi
unset _miranda_env_result
