# This Makefile assumes the following file structure:
# include/   holds .h header files
# test/      holds doctest test definition .cpp files
# src/       holds tested .cpp source files (excluding main drivers)
# drivers/      holds main-driver.cpp and test-driver.cpp
# bin/       will be created to place created executables main-driver and test-driver
# build/     will be created to hold intermediate .o files

# It automatically figures out dependencies.
# ideas from https://spin.atomicobject.com/2016/08/26/makefile-c-projects/

# compiler flags and source directories can be changed here
CXX		  := g++
CXXFLAGS := -Wall -Wextra -std=c++17 -ggdb -pedantic -Og

TARGET_MAIN ?= main-driver
TARGET_TEST ?= test-driver

BUILD_DIR ?= ./build
BIN_DIR ?= ./bin
SRC_DIRS ?= ./src
TEST_DIRS ?= ./test
MAIN_DIR ?= ./drivers
INC_DIRS ?= ./include
MKDIR_P ?= mkdir -p

MAIN_SRCS := $(shell find $(SRC_DIRS) $(MAIN_DIR)/main-driver.cpp -name "*.cpp")
TEST_SRCS := $(shell find $(SRC_DIRS) $(TEST_DIRS) $(MAIN_DIR)/test-driver.cpp -name "*.cpp")
SRCS := $(shell find $(SRC_DIRS) $(TEST_DIRS) $(MAIN_DIR) -name "*.cpp")
MAIN_OBJS := $(MAIN_SRCS:%=$(BUILD_DIR)/%.o)
TEST_OBJS := $(TEST_SRCS:%=$(BUILD_DIR)/%.o)
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

INC_FLAGS ?= $(addprefix -I,$(INC_DIRS))

CPPFLAGS := $(INC_FLAGS) -MMD -MP -Og

.PHONY: bin test run clean

all: $(BIN_DIR)/$(TARGET_MAIN) $(BIN_DIR)/$(TARGET_TEST)

bin: $(BIN_DIR)/$(TARGET_MAIN)

$(TEST_SRCS): include/doctest.h

build-test: $(BIN_DIR)/$(TARGET_TEST)

run: $(BIN_DIR)/$(TARGET_MAIN)
	$^

test: $(BIN_DIR)/$(TARGET_TEST)
	$^

# runs a simple, commandline debugger called gdb;
# enter `run` after it starts up or first set a breakpoint
# with e.g. `break task.cpp:20` which would set a breakpoint at
# line 20 of task.cpp
run-debug: $(BIN_DIR)/$(TARGET_MAIN)
	gdb $^

test-debug: $(BIN_DIR)/$(TARGET_TEST)
	gdb $^

# clean and then created a zipped copy of this folder
zip: clean
	d=`pwd | xargs basename`; rm -f $$d.zip
	d=`pwd | xargs basename`; cd ../; zip -r $$d/$$d.zip $$d;

# downloads doctest.h and license
include/doctest.h:
	cd include; rm doctest.LICENSE.txt; wget https://raw.githubusercontent.com/onqtam/doctest/2.4.0/LICENSE.txt -O doctest.LICENSE.txt
	cd include; wget https://raw.githubusercontent.com/onqtam/doctest/2.4.0/doctest/doctest.h

README.html: README.md
	pandoc -o README.html README.md

$(BIN_DIR)/$(TARGET_MAIN): $(MAIN_OBJS)
	$(MKDIR_P) $(dir $@)
	$(CXX) $(MAIN_OBJS) -o $@ $(LDFLAGS)

$(BIN_DIR)/$(TARGET_TEST): $(TEST_OBJS)
	$(MKDIR_P) $(dir $@)
	$(CXX) $(TEST_OBJS) -o $@ $(LDFLAGS)

# c++ source
$(BUILD_DIR)/%.cpp.o: %.cpp
	$(MKDIR_P) $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

clean:
	$(RM) -r $(BUILD_DIR) $(BIN_DIR) fixed-debugger

# extra make targets to make debugging with ide.cs50.io easier
# otherwise, you have to put breakpoints in the files
.PHONY: run-debug50 test-debug50
fixed-debugger: $(shell which debug50)
	debug=`which debug50`; n=$$(grep -n -m1 "any breakpoint" $$debug | grep -o "^[^:]*"); (head -n $$n $$debug; tail -n +$$(($$n + 2)) $$debug) > fixed-debugger

run-debug50: fixed-debugger $(BIN_DIR)/$(TARGET_MAIN)
	bash fixed-debugger $(BIN_DIR)/$(TARGET_MAIN)

test-debug50: fixed-debugger $(BIN_DIR)/$(TARGET_TEST)
	bash fixed-debugger $(BIN_DIR)/$(TARGET_TEST)


# include the dependencies generated using the
-include $(DEPS)

