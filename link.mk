# Файл осуществляет непосредственную линковку объектных файлов в бинарник.

# Необходимые переменные для совершения линковки:
# LD         - Линковщик (бинарник).
# OBJDUMP    - Бинарник используется для генерации асемблерного файла (man objdump).
# PRINT_SIZE - Юниксовая команда для вывода текущего размера.
# CFLAGS     - Сишные флаги линковки.
# LDFLAGS    - Общие флаги линковки.

# Linker
LD := g++

# Command to disassembly binary file
OBJDUMP := objdump

# Command to print size
SIZE := size

# Пути расположения конечных файлов.
BINARY_FILE := $(BIN_PATH)/$(NAME).elf
MAP_FILE := $(BIN_PATH)/$(NAME).map
ASM_FILE := $(BIN_PATH)/$(NAME).asm

# Linker C flags
CFLAGS := -Wl,--no-as-needed -pthread
CFLAGS += -Wall -g3 -Wextra -Werror

# Common flags
LDFLAGS += -Xlinker --gc-sections
LDFLAGS += -o $@ -Wl,-Map="$(MAP_FILE)" $(MEMORY_PRINT)
LDFLAGS	+= -lm

# Dependencies from all makefiles
COMMON_OBJ_DEPS := $(MAKEFILE_LIST)

# If ASM==on -> function ASM_GEN generating asm files
ifeq ($(ASM),on)
ASM_GEN = $(ASM_FILE)
else
# else remove old asm files
ASM_GEN = $(shell rm -rf $(ASM_FILE))
endif

ifeq ($(SILENCE), false)
ifneq ($(BUILD),clean)
$(info Info from link.mk file: )
$(info Linker = $(LD))
$(info Linker C flags = $(CFLAGS))
$(info Linker flags = $(LDFLAGS))
$(info )
endif
endif

# Set defaul size output format
ifndef SIZE_OUTPUT
SIZE_OUTPUT := berkeley
endif

# Target for asm file generation
$(ASM_FILE): $(BINARY_FILE)
	@echo 'Assembler file generating'
	@$(OBJDUMP) --source -D $(BINARY_FILE) > $(ASM_FILE)

# Main target to create binary file
$(BINARY_FILE): $(OBJS) $(COMMON_OBJ_DEPS)
	@mkdir -p $(BIN_PATH)
	@echo
	@echo [LD] $@
	@echo
	@$(LD) $(CFLAGS) $(OBJS) $(LDFLAGS)
	@echo 'Size summary:'
	@$(SIZE) --format=$(SIZE_OUTPUT) $(BINARY_FILE)

all: $(BINARY_FILE) $(ASM_GEN)
