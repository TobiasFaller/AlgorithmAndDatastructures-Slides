ALGO_NAME_LECTURES = Lectures
ALGO_NAME_EXERCISESHEETS = ExerciseSheets

ALGO_ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
ALGO_FULL_NAME := $(shell basename $(ALGO_ROOT_DIR))

ALGO_LANGUAGE ?= eng
ALGO_PROGLANG ?= python
ALGO_DESIGN ?= plain

all: clean build

# ------------------------------------------------------------------------------
help:
	@echo "Language:"
	@echo "	Use switch ALGO_LANGUAGE=<value> to set the language"
	@echo "	eng: english"
	@echo
	@echo "Programming Language:"
	@echo "	Use switch ALGO_PROGLANG=<value> to set the language"
	@echo "	java: Java"
	@echo "	cpp: C++"
	@echo "	python: Python"
	@echo
	@echo "Design:"
	@echo "	Use switch ALGO_DESIGN=<value> to set the lecture design"
	@echo "	ufcd: Design of University of Freiburg"
	@echo "	plain: Standard design of the beamer template"
	@echo
	@echo "MikTeX: (Windows)"
	@echo "	clean/lectures: Clean all lectures"
	@echo "	clean/exercisesheets: Clean all exercisesheets"
	@echo "	clean/full: Clean all build folders erasing all build files"
	@echo "	build: Build all files into the build directories"
	@echo "	build/lectures: Build all lectures into the build directories"
	@echo "	build/exercisesheets: Build all exercisesheets into the build directories"
	@echo
	@echo "TeX: (General)"
	@echo "	clean: Clean only the export folders"
	@echo "	build_server:"
	@echo "		Build all files of a language into the source directory"
	@echo "	build_server/lectures:"
	@echo "		Build all lectures of a language into the source directory"
	@echo "	build_server/exercisesheets:"
	@echo "		Build all exercisesheets of a language into the source directory"
	@echo "	export: Move all build files into the root directory"

# ------------------------------------------------------------------------------
clean:
	@echo "Cleaning"
	@rm -r -f $(ALGO_NAME_LECTURES)
	@rm -r -f $(ALGO_NAME_EXERCISESHEETS)

clean/lectures:
	@echo "Cleaning Lectures"
	@ls -d Lecture-* | awk '{system("$(MAKE) --directory="$$1" clean");}'

clean/exercisesheets:
	@echo "Cleaning ExerciseSheets"
	@ls -d ExerciseSheet-* | awk '{system("$(MAKE) --directory="$$1" clean");}'

clean/full: clean clean/lectures clean/exercisesheets
	@rm -f ./*.pdf

# ------------------------------------------------------------------------------
directories:
	@echo "Creating directories"
	@mkdir -p $(ALGO_NAME_LECTURES)
	@mkdir -p $(ALGO_NAME_EXERCISESHEETS)

# ------------------------------------------------------------------------------
build: directories build/lectures build/exercisesheets

build/lectures:
	@echo "Building lectures"
	@ls -d Lecture-* | awk '{system("$(MAKE) --directory="$$1" ALGO_LANGUAGE=$(ALGO_LANGUAGE) ALGO_PROGLANG=$(ALGO_PROGLANG) ALGO_DESIGN=$(ALGO_DESIGN) export");}'

build/exercisesheets:
	@echo "Building exercise-sheets"
	@ls -d ExerciseSheet-* | awk '{system("$(MAKE) --directory="$$1" ALGO_LANGUAGE=$(ALGO_LANGUAGE) ALGO_PROGLANG=$(ALGO_PROGLANG) ALGO_DESIGN=$(ALGO_DESIGN) export");}'

# ------------------------------------------------------------------------------
build_server: directories build_server/lectures build_server/exercisesheets
build_server/lectures:
	@echo "Building lectures (server)"
	@ls -d Lecture-* | awk '{system("$(MAKE) --directory="$$1" ALGO_LANGUAGE=$(ALGO_LANGUAGE) ALGO_PROGLANG=$(ALGO_PROGLANG) ALGO_DESIGN=$(ALGO_DESIGN) export_server");}'

build_server/exercisesheets:
	@echo "Building exercise-sheets (server)"
	@ls -d ExerciseSheet-* | awk '{system("$(MAKE) --directory="$$1" ALGO_LANGUAGE=$(ALGO_LANGUAGE) ALGO_PROGLANG=$(ALGO_PROGLANG) ALGO_DESIGN=$(ALGO_DESIGN) export_server");}'

export:
	@echo "Exporting generated files"
	@mv $(ALGO_NAME_LECTURES)/*.pdf .
	@mv $(ALGO_NAME_EXERCISESHEETS)/*.pdf .
