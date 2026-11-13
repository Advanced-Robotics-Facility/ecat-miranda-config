SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

export EC_CFG="$SCRIPT_DIR/ec_cfg.yaml"
export ROBOT_MASTER_CONFIG="$SCRIPT_DIR/robot_ecat/ecat_config.yaml"
export ROBOT_MASTER_CONFIG_DUMMY="$SCRIPT_DIR/robot_ecat/ecat_dummy_cfg.yaml"

alias robot_master="repl -f $ROBOT_MASTER_CONFIG"
alias robot_master_gdb="gdb --args repl -f $ROBOT_MASTER_CONFIG"
