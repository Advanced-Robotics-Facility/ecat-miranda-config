SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

export EC_CFG="$SCRIPT_DIR/ec_cfg.yaml"
export ROBOT_MASTER_CONFIG="$SCRIPT_DIR/robot_ecat/ecat_config.yaml"
export ROBOT_MASTER_CONFIG_UDP="$SCRIPT_DIR/robot_ecat/ecat_config_udp.yaml"
#export ROS_PACKAGE_PATH=$SCRIPT_DIR:$ROS_PACKAGE_PATH
#alias ecat_master="stdbuf --output=L --error=L repl -f $ECAT_MASTER_CONFIG 2>&1 | tee /tmp/ecat-output"
alias robot_master="repl -f $ROBOT_MASTER_CONFIG"
alias robot_master_gdb="gdb --args repl -f $ROBOT_MASTER_CONFIG"
