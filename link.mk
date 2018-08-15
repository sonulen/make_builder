# Флаги линковки
LD := g++
CFLAGS = -Wall -g3 -Wextra -Werror -pthread
LDFLAGS := --gc-sections
LDFLAGS += -o bin/$(TARGET).elf -Map bin/$(TARGET).map
LDOPTS:= $(addprefix -Xlinker ,$(LDFLAGS)) -lm

OBJDUMP := objdump
SIZE := size

bin/$(TARGET).elf:	$(OBJS)
# Linker
	@mkdir -p bin
	@echo [LD] bin/$(TARGET).elf
	@$(LD) $(CFLAGS) $(OBJS) $(LDOPTS)
	@$(OBJDUMP) --source -D bin/$(TARGET).elf > bin/$(TARGET).asm
	@echo
	@echo 'Size summary:'
	@$(SIZE)  --format=berkeley bin/$(TARGET).elf