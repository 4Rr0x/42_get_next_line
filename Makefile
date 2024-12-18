# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jopedro- <jopedro-@student.42porto.com>    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/12/02 14:05:03 by jopedro-          #+#    #+#              #
#    Updated: 2024/12/02 16:08:57 by jopedro-         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

MAKE	= make -C
SHELL	:= bash

#==============================================================================#
#                                     NAMES                                    #
#==============================================================================#

UNAME 			= $(shell uname)
NAME 			= get_next_line
EXEC			= a.out

### Message Vars
_SUCCESS 		= [$(GRN)SUCCESS$(D)]
_INFO 			= [$(BLU)INFO$(D)]
_NORM 			= [$(MAG)Norminette$(D)]
_NORM_SUCCESS 	= $(GRN)=== OK:$(D)
_NORM_INFO 		= $(BLU)File no:$(D)
_NORM_ERR 		= $(RED)=== KO:$(D)
_SEP 			= =====================

#==============================================================================#
#                                    PATHS                                     #
#==============================================================================#

SRCB_PATH	= .
LIBS_PATH	= lib
BUILD_PATH	= .build
TEMP_PATH	= .temp
TESTS_PATH	= files

SRC		= get_next_line.c get_next_line_utils.c
SRCB	= get_next_line_bonus.c get_next_line_utils_bonus.c

OBJS	= $(SRC:$(SRCB_PATH)/%.c=$(BUILD_PATH)/%.o)
OBJSB	= $(SRCB:$(SRCB_PATH)/%.c=$(BUILD_PATH)/%.o)

GNLTESTER_PATH			= $(SRCB_PATH)/gnlTester
GNL_STATION_TESTER_PATH	= $(SRCB_PATH)/gnlStationTester

#==============================================================================#
#                              COMPILER & FLAGS                                #
#==============================================================================#

CC			= cc

CFLAGS		= -Wall -Wextra -Werror
DFLAGS		= -g
BFLAGS		?= -D BUFFER_SIZE=
INC			= -I.

#==============================================================================#
#                                COMMANDS                                      #
#==============================================================================#

RM		= rm -rf
AR		= ar rcs
MKDIR_P	= mkdir -p

#==============================================================================#
#                                  RULES                                       #
#==============================================================================#

##@ get_next_line Compilation Rules 🏗

all: $(BUILD_PATH)  $(EXEC)	## Compile Mandatory version

$(EXEC): $(BUILD_PATH) $(OBJS) main.c			## Compile Mandatory version
	@echo "$(YEL)Compiling test for $(MAG)$(NAME)$(YEL) w/out bonus$(D)"
	$(CC) $(CFLAGS) $(DFLAGS) $(BFLAGS)$(BUFFER_SIZE) main.c $(OBJS) -o $(EXEC)
	@echo "$(YEL)Linking $(CYA).gdbinit$(D) $(YEL)for debugging$(D)"
	@echo "[$(_SUCCESS) compiling $(MAG)$(NAME)$(D) $(YEL)🖔$(D)]"
	make norm

bonus: $(BUILD_PATH)  $(OBJSB) $(LIBFT_ARC) main.c		## Compile Bonus version
	@echo "$(YEL)Compiling test for $(MAG)$(NAME) $(YEL)w/ bonus$(D)"
	$(CC) $(CFLAGS) $(DFLAGS) main.c $(OBJSB) -o $(EXEC)
	@echo "$(YEL)Linking $(CYA).gdbinit $(YEL)for debugging$(D)"
	@echo "[$(_SUCCESS) compiling $(MAG)$(NAME)$(D) w/ bonus $(YEL)🖔$(D)]"
	make norm

-include $(BUILD_PATH)/%.d

$(BUILD_PATH)/%.o: $(SRCB_PATH)/%.c
	@echo -n "$(MAG)█$(D)"
	$(CC) $(CFLAGS) $(DFLAGS) $(BFLAGS)$(BUFFER_SIZE) -MMD -MP -c $< -o $@

$(BUILD_PATH)/%.o: $(SRCLL_PATH)/%.c
	@echo -n "$(MAG)█$(D)"
	$(CC) $(CFLAGS) $(DFLAGS) $(BFLAGS)$(BUFFER_SIZE) -MMD -MP -c $< -o $@

$(BUILD_PATH):
	$(MKDIR_P) $(BUILD_PATH)
	@echo "* $(YEL)Creating $(CYA)$(BUILD_PATH)$(YEL) folder:$(D) $(_SUCCESS)"

$(TEMP_PATH):
	$(MKDIR_P) $(TEMP_PATH)
	@echo "* $(YEL)Creating $(CYA)$(TEMP_PATH)$(YEL) folder:$(D) $(_SUCCESS)"

##@ Norm Rules

norm: $(TEMP_PATH)		## Run norminette test on source files
	@echo "$(CYA)$(_SEP)$(D)"
	@printf "${_NORM}: $(YEL)$(SRCB_PATH)$(D)\n"
	@ls $(SRCB_PATH) | wc -l > $(TEMP_PATH)/norm_ls.txt
	@printf "$(_NORM_INFO) $$(cat $(TEMP_PATH)/norm_ls.txt)\n"
	@printf "$(_NORM_SUCCESS) "
	@norminette $(SRCB_PATH) | grep -wc "OK" > $(TEMP_PATH)/norm.txt; \
	if [ $$? -eq 1 ]; then \
		echo "0" > $(TEMP_PATH)/norm.txt; \
	fi
	@printf "$$(cat $(TEMP_PATH)/norm.txt)\n"
	@if ! diff -q $(TEMP_PATH)/norm_ls.txt $(TEMP_PATH)/norm.txt > /dev/null; then \
		printf "$(_NORM_ERR) "; \
		norminette $(SRCB_PATH) | grep -v "OK"> $(TEMP_PATH)/norm_err.txt; \
		cat $(TEMP_PATH)/norm_err.txt | grep -wc "Error:" > $(TEMP_PATH)/norm_errn.txt; \
		printf "$$(cat $(TEMP_PATH)/norm_errn.txt)\n"; \
		printf "$$(cat $(TEMP_PATH)/norm_err.txt)\n"; \
	else \
		printf "[$(YEL)Everything is OK$(D)]\n"; \
	fi
	@echo "$(CYA)$(_SEP)$(D)"

check_ext_func: all		## Check for external functions
	@echo "[$(YEL)Checking for external functions$(D)]"
	@echo "$(YEL)$(_SEP)$(D)"
	@echo "$(CYA)Reading binary$(D): $(MAG)$(NAME)$(D)"
	nm ./$(EXEC) | grep "U" | tee $(TEMP_PATH)/ext_func.txt
	@echo "$(YEL)$(_SEP)$(D)"

##@ Test Rules 🧪

gnlTester:  $(EXEC) get_gnlTester		## Run gnlTester
	tmux split-window -h "$(MAKE) $(GNLTESTER_PATH) a"
	tmux set-option remain-on-exit on

get_gnlTester:
	@echo "* $(CYA)Getting gnlTester submodule$(D)]"
	@if test ! -d "$(GNLTESTER_PATH)"; then \
		git clone git@github.com:Tripouille/gnlTester.git $(GNLTESTER_PATH); \
		echo "* $(GRN)gnlTester download$(D): $(_SUCCESS)"; \
	else \
		echo "* $(GRN)gnlTester already exists 🖔"; \
		echo " $(RED)$(D) [$(GRN)Nothing to be done!$(D)]"; \
	fi

gnl-station-tester:  $(EXEC) get_gnlStationTester			## Run gnl-station-tester
	tmux split-window -h "$(MAKE) $(GNL_STATION_TESTER_PATH)"
	tmux set-option remain-on-exit on

get_gnlStationTester:
	@echo "* $(CYA)Getting gnlStationTester submodule$(D)]"
	@if test ! -d "$(GNL_STATION_TESTER_PATH)"; then \
		git clone git@github.com:kodpe/gnl-station-tester.git $(GNL_STATION_TESTER_PATH); \
		echo "* $(GRN)gnl-station-tester download$(D): $(_SUCCESS)"; \
	else \
		echo "* $(GRN)gnl-station-tester already exists 🖔"; \
		echo " $(RED)$(D) [$(GRN)Running tester!$(D)]"; \
	fi

##@ Debug Rules 

gdb:  $(EXEC) $(TEMP_PATH)			## Debug w/ gdb
	tmux split-window -h "gdb --tui --args ./$(EXEC) 'files/mini-vulf.txt'"
	tmux resize-pane -L 5
	@if command -v lnav; then \
		lnav gdb.txt; \
	else \
		tail -f gdb.txt; \
	fi

##@ Clean-up Rules 󰃢

clean: 				## Remove object files
	@echo "*** $(YEL)Removing $(MAG)$(NAME)$(D) and  $(YEL)object files$(D)"
	@if [ -d "$(BUILD_PATH)" ] || [ -d "$(TEMP_PATH)" ] || [ -d "$(GNLTESTER_PATH)" ]; then \
		if [ -d "$(BUILD_PATH)" ]; then \
			$(RM) $(BUILD_PATH); \
			echo "* $(YEL)Removing $(CYA)$(BUILD_PATH)$(D) folder & files$(D): $(_SUCCESS)"; \
		fi; \
		if [ -d "$(TEMP_PATH)" ]; then \
			$(RM) $(TEMP_PATH); \
			echo "* $(YEL)Removing $(CYA)$(TEMP_PATH)$(D) folder & files:$(D) $(_SUCCESS)"; \
		fi; \
		if [ -d "$(GNLTESTER_PATH)" ]; then \
			$(RM) $(GNLTESTER_PATH); \
			echo "* $(YEL)Removing $(CYA)$(GNLTESTER_PATH)$(D) folder & files:$(D) $(_SUCCESS)"; \
		fi; \
		if [ -d "$(GNL_STATION_TESTER_PATH)" ]; then \
			$(RM) $(GNL_STATION_TESTER_PATH); \
			echo "* $(YEL)Removing $(CYA)$(GNL_STATION_TESTER_PATH)$(D) folder & files:$(D) $(_SUCCESS)"; \
		fi; \
	else \
		echo " $(RED)$(D) [$(GRN)Nothing to clean!$(D)]"; \
	fi

fclean: clean			## Remove executable and .gdbinit
	@if [ -f ".gdbinit" ] || [ -f "$(EXEC)" ]; then \
		if [ -f "$(EXEC)" ]; then \
			$(RM) $(EXEC); \
			echo "* $(YEL)Removing $(CYA)$(EXEC)$(D) file: $(_SUCCESS)"; \
		fi; \
		if [ -f ".gdbinit" ]; then \
			$(RM) .gdbinit; \
			echo "* $(YEL)Removing $(CYA).gdbinit$(D) file: $(_SUCCESS)"; \
		fi; \
	else \
		echo " $(RED)$(D) [$(GRN)Nothing to be fcleaned!$(D)]"; \
	fi

re: fclean all	## Purge & Recompile

##@ Help 󰛵

help: 			## Display this help page
	@awk 'BEGIN {FS = ":.*##"; \
			printf "\n=> Usage:\n\tmake $(GRN)<target>$(D)\n"} \
		/^[a-zA-Z_0-9-]+:.*?##/ { \
			printf "\t$(GRN)%-18s$(D) %s\n", $$1, $$2 } \
		/^##@/ { \
			printf "\n=> %s\n", substr($$0, 5) } ' Makefile
## Tweaked from source:
### https://www.padok.fr/en/blog/beautiful-makefile-awk

.PHONY: bonus extrall clean fclean re help

#==============================================================================#
#                                  UTILS                                       #
#==============================================================================#

# Colors
#
# Run the following command to get list of available colors
# bash -c 'for c in {0..255}; do tput setaf $c; tput setaf $c | cat -v; echo =$c; done'
#
B  		= $(shell tput bold)
BLA		= $(shell tput setaf 0)
RED		= $(shell tput setaf 1)
GRN		= $(shell tput setaf 2)
YEL		= $(shell tput setaf 3)
BLU		= $(shell tput setaf 4)
MAG		= $(shell tput setaf 5)
CYA		= $(shell tput setaf 6)
WHI		= $(shell tput setaf 7)
GRE		= $(shell tput setaf 8)
BRED 	= $(shell tput setaf 9)
BGRN	= $(shell tput setaf 10)
BYEL	= $(shell tput setaf 11)
BBLU	= $(shell tput setaf 12)
BMAG	= $(shell tput setaf 13)
BCYA	= $(shell tput setaf 14)
BWHI	= $(shell tput setaf 15)
D 		= $(shell tput sgr0)
BEL 	= $(shell tput bel)
CLR 	= $(shell tput el 1)
