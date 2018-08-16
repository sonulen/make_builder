# Путь к локальным директориям
DIRS += .
DIRS_OBJ := .obj/
DIRS_BIN := bin/
DIRS_DEPS := .d/

# Флаги компиляции
AS := gcc
CC :=  gcc
CPP :=  g++
OPTIM := -O0
BFLAGS += -Wall -g3 -Wextra -Werror -flto
CPPFLAGS += $(OPTIM) $(BFLAGS) -std=c++17 -pthread

# Объекты формируем
OBJECTS = $(SOURCE:.cpp=.o)
OBJS = $(addprefix $(DIRS_OBJ),$(OBJECTS))

# Формируем зависимости
DEPS = $(addprefix $(DIRS_DEPS),$(OBJECTS:.o=.d))
#DEPFLAGS = -MT $@ -MMD -MP -MF .d/$*.Td
DEPFLAGS = -MMD -MP -MF .d/$*.Td
DIRFLAGS = $(addprefix -I, $(DIRS))
DEFFLAGS = $(addprefix -D,$(DEFS)) $(addprefix -D,$(DEFS_EXT))

#this would rename temporary dep files (.Td) into final *.d ones
POSTCOMPILE = @mv -f .d/$*.Td .d/$*.d && touch $@

#directory, where this (makefile) file is located (for dependancy)
ROOT_DIR := $(notdir $(CURDIR))
PROJ_DIR := $(dir $(firstword $(MAKEFILE_LIST)))

MAKEFILE_DEPS := makefile builder/compile.mk
MAKEFILE_DEPS += $(PROJ_DIR)/makefile 

# Подтягиваем зависимости
-include $(DEPS)

# compile and generate dependency info
.obj/%.o: %.cpp $(MAKEFILE_DEPS)
	@echo [CPP] $<
	@mkdir -p $(dir .d/$<)
	@mkdir -p $(dir .obj/$<)
	@$(CPP) $(CPPFLAGS) $(DEPFLAGS) $(DIRFLAGS) $(DEFFLAGS) -c $< -o $@
	@$(POSTCOMPILE)
	
.d/%.d: ;
.PRECIOUS: .d/%.d

.SECONDEXPANSION:
all: $$(OBJS)