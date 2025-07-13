# Target Platform
export PLATFORM = sky130hd

# Design Name
export DESIGN_NAME = cache_top

# Verilog Source Files
export VERILOG_FILES = $(sort $(wildcard ./designs/src/$(DESIGN_NAME)/*.v))

# Constraint File (Timing Constraints)
export SDC_FILE = ./designs/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

# Synthesis Optimization
export SYNTH_STRATEGY = AREA_0

# Placement and Routing Optimizations
export CORE_UTILIZATION = 35  # Slightly increased for better spacing
export PLACE_DENSITY = 0.40   # Lower density to prevent congestion

# Congestion-Aware Placement
export PL_TARGET_DENSITY = 0.45
export PL_CONGESTION_EFFORT = 3

# Routing Optimization
export BOTTOM_ROUTING_LAYER = met1
export TOP_ROUTING_LAYER = met6  # Allow routing up to met6 for more flexibility

# Timing Optimization
export TNS_END_PERCENT = 90  # Reduce negative slack by 90%

# Clock Constraints (Modify according to your design's clock)
export CLOCK_PORT = clk
export CLOCK_PERIOD = 10.0  # Default 10ns (100MHz clock)

# Power Settings (Enable Power Optimization)
export POWER_OPTIMIZATION = 1

# Specify Macro Placement File (if needed)
export MACRO_PLACEMENT_CFG = ./designs/$(PLATFORM)/$(DESIGN_NAME)/macro.cfg

# Output Directories
export RESULTS_DIR = ./results/$(PLATFORM)/$(DESIGN_NAME)
export LOG_DIR = ./logs/$(PLATFORM)/$(DESIGN_NAME)
export REPORTS_DIR = ./reports/$(PLATFORM)/$(DESIGN_NAME)

# Enable Debugging
export ENABLE_DEBUG = 0

