PROJECT_NAME = relay-board
SHELL = /bin/bash
PROJECT_DIRECTORY:=$(shell git rev-parse --show-toplevel)
SOURCE_DIRECTORY:=$(PROJECT_DIRECTORY)
BUILD_DIRECTORY:=$(PROJECT_DIRECTORY)/build/
DESTDIR:=$(PROJECT_DIRECTORY)/install/
port:=/dev/ttyUSB0
upload_speed:=57600
upload_protocol:=arduino
mcu:=atmega328p
cpu_frequency:=16000000
board_variant:=eightanaloginputs

#location of the arduino installation, set for default in debian.
#Arduino libraries are not considered for this core make file
#This makefile generates a library called libarduinocore.a
arduino_dir:=/usr/share/arduino/
arduino_core_directory:=$(arduino_dir)hardware/arduino/cores/arduino/
arduino_variants_directory:=$(arduino_dir)hardware/arduino/variants/

avr_core_src_c:=wiring.c \
	wiring_analog.c wiring_digital.c \
	wiring_pulse.c \
	wiring_shift.c WInterrupts.c


avr_core_src_cpp:=HardwareSerial.cpp WMath.cpp Print.cpp CDC.cpp

avr_core_obj_dir:=$(BUILD_DIRECTORY)/core
avr_core_cpp_obj:=$(patsubst %.cpp, $(avr_core_obj_dir)/%.o, $(avr_core_src_cpp))
avr_core_c_obj:=$(patsubst %.c, $(avr_core_obj_dir)/%.o, $(avr_core_src_c))

avr_core_inc:=-I$(arduino_core_directory) -I$(arduino_variants_directory)$(board_variant)

arduino_static_library_name:=arduinocore
arduino_static_library:=$(avr_core_obj_dir)/lib$(arduino_static_library_name).a

#See arduino/hardware/arduino/avr/platform.txt for compilation flags
AVR_CPPFLAGS:=-c -O2 -g -mmcu=$(mcu) -DF_CPU=$(cpu_frequency) -DARDUINO=105 -D__PROG_TYPES_COMPAT__ \
	-fno-exceptions -ffunction-sections -fdata-sections \
	-funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums -fno-threadsafe-statics \
	-std=c++11 -Wall
AVR_LFLAGS:= -mmcu=$(mcu) -Os  -Wl,--gc-sections
AVR_INC:=$(avr_core_inc)
AVR_CC:=avr-g++
AVR_OBJCOPY:=avr-objcopy
AVR_OBJDUMP:=avr-objdump
AVR_AR:=avr-ar
AVR_SIZE:=avr-size
AVR_NM:=avr-nm

AVRDUDE:=avrdude
AVRDUDE_MCU:=ATmega328p
AVRDUDE_WRITE_FLASH = -U flash:w:
AVRDUDE_FLAGS = -q -D -F \
    -p $(AVRDUDE_MCU) -P $(port) -c $(upload_protocol) \
    -b $(upload_speed) -C $(arduino_dir)hardware/tools/avrdude.conf


$(avr_core_obj_dir)/%.o:
	@mkdir -p $(avr_core_obj_dir)
	@echo "CC $(filter $*.%, $(avr_core_src_cpp) $(avr_core_src_c)) \
	------> $*.o"
	@$(AVR_CC) $(AVR_CPPFLAGS) -MMD \
	$(avr_core_inc) $(arduino_core_directory)$(filter $*.%, $(avr_core_src_cpp) $(avr_core_src_c)) \
	-o $@


$(arduino_static_library): $(avr_core_c_obj) $(avr_core_cpp_obj)
	@echo "Creating arduino library"
	$(AVR_AR) rcs $(arduino_static_library) $(avr_core_c_obj) $(avr_core_cpp_obj)


SOURCE_FILES:=$(wildcard $(SOURCE_DIRECTORY)/*.cpp)

$(PROJECT_NAME)_obj:=$(patsubst %.cpp, $(BUILD_DIRECTORY)/%.o, $(SOURCE_FILES))

$(BUILD_DIRECTORY)/%.o: %.cpp
	@echo "CC $^ ------> $@"
	$(AVR_CC) $(CPPFLAGS) $(ACFLAGS) $(INC_PARAMS) $^ -o $@

clean:
	find $(SOURCE_DIRECTORY) -type f -name "*.d" -o -name "*.o" -o -name "*.a"  \
		-o -name "*.hex" -o -name "*.zip" | xargs rm -f

$(BUILD_DIRECTORY)/$(PROJECT_NAME).elf: CC:=$(AVR_CC)
$(BUILD_DIRECTORY)/$(PROJECT_NAME).elf: CPPFLAGS:=$(AVR_CPPFLAGS)
$(BUILD_DIRECTORY)/$(PROJECT_NAME).elf: AC_FLAGS:=$(AVR_CPPFLAGS)
$(BUILD_DIRECTORY)/$(PROJECT_NAME).elf: INC_PARAMS+=$(AVR_INC)
$(BUILD_DIRECTORY)/$(PROJECT_NAME).elf: $(arduino_static_library) $($(PROJECT_NAME)_obj)
	$(AVR_CC) $($(PROJECT_NAME)_obj) \
		$($(PROJECT_NAME)_softwareserial_obj) \
		$(AVR_LFLAGS) -L$(avr_core_obj_dir) -l$(arduino_static_library_name) \
		-o $@

$(DESTDIR)/$(PROJECT_NAME).hex: $(BUILD_DIRECTORY)/$(PROJECT_NAME).elf
	mkdir -p $(DESTDIR)
	$(AVR_OBJCOPY) -O ihex -R .eeprom $< $@


.PHONY = upload_$(PROJECT_NAME)
.DEFAULT_GOAL = $(DESTDIR)/$(PROJECT_NAME).hex

upload_$(PROJECT_NAME): $(PROJECT_NAME).hex
	md5sum $<
	$(AVRDUDE) $(AVRDUDE_FLAGS) $(AVRDUDE_WRITE_FLASH)$<:i

all: upload_$(PROJECT_NAME)
