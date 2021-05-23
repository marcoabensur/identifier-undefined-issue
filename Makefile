# Verbosity
ifeq ($(VERBOSE),0)
AT := @
else
AT :=
endif

###############################################################################
## Code Optimization
###############################################################################

OPT := -O1

# Location of build files
BUILD_DIR := build

# Build target base name definition
BUILD_TARGET_BASE_NAME := test


# Remove command
RM := rm -rf

# Compiler variables
CC      := gcc
AS      := $(CC) -x assembler-with-cpp
OBJCOPY := objcopy
OBJDUMP := objdump
SIZE    := size
GDB     := gdb
HEX     := $(OBJCOPY) -O ihex
BIN     := $(OBJCOPY) -O binary 


# Source Files
C_SOURCES    := $(sort $(shell find ./src -name "*.c"))
C_HEADERS    := $(sort $(shell find ./src -name "*.h"))

# Object Files
OBJECTS      := $(addprefix $(BUILD_DIR)/obj/,$(notdir $(C_SOURCES:.c=.o)))

# Specify the search path directories for file names that match %.c
vpath %.c $(sort $(dir $(C_SOURCES)))

# Defines

DEVICE_DEF:= __SAMD21G18A__

C_DEFS  :=                                                              \
	-D$(DEVICE_DEF) 


# Include Paths
C_INCLUDES  := $(addprefix -I, $(sort $(dir $(C_HEADERS))))


CFLAGS :=                                   					        \
	$(MCUFLAGS) $(C_DEFS) $(C_INCLUDES) $(OPT)               	        \
    -fdata-sections -ffunction-sections -g3 -Wall -Wextra               \
	-std=gnu99 -Wno-expansion-to-defined  -c 



###############################################################################
## Build Targets
###############################################################################

# Make all using linker for flash section A
all: $(BUILD_DIR)/$(BUILD_TARGET_BASE_NAME).elf $(BUILD_DIR)/$(BUILD_TARGET_BASE_NAME).hex $(BUILD_DIR)/$(BUILD_TARGET_BASE_NAME).bin

# All .o file depend on respective .c file, all header files, the Makefile and build directory existence
$(BUILD_DIR)/obj/%.o: %.c $(C_HEADERS) Makefile | $(BUILD_DIR)
	@echo "\nCC $<"
	$(AT)$(CC) -x c $(CFLAGS) -MD -MP -MF "$(@:.o=.d)" -MT"$(@:.o=.d)" -MT"$(@:.o=.o)" -o $@ $<

# The .elf file depend on all object files and the Makefile
$(BUILD_DIR)/$(BUILD_TARGET_BASE_NAME).elf: $(OBJECTS) Makefile | $(BUILD_DIR)
	@echo "\nCC $@"
	$(AT)$(CC) -o $@  $(OBJECTS)
	@echo ""
	$(AT)$(SIZE) $@

# The .hex file depend on the .elf file and build directory existence
$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	@echo "\nCreating $@"
	$(AT)$(HEX) -R .eeprom -R .fuse -R .lock -R .signature $< $@

# The .bin file depend on the .elf file and build directory existence
$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	@echo "\nCreating $@"
	$(AT)$(BIN) $< $@

# Create the build_dir
$(BUILD_DIR):
	@echo "\nCreating build directory"
	$(AT)mkdir -p $@
	$(AT)mkdir -p $@/obj


clean:
	$(AT) $(RM) $(OBJECTS) $(OBJECTS:.o=.d) $(BUILD_DIR)/$(BUILD_TARGET_BASE_NAME).*


# Display help
help:
	@echo "----------------------- Help ------------------------------"
	@echo "Options:"
	@echo "	all:             Compile all files"
	@echo "	clean:           Clean compiled files"
