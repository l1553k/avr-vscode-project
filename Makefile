MCU = atmega328p
F_CPU = 16000000UL
BAUD=9600

CC = /usr/bin/avr-g++
CCFLAGS = -mmcu=$(MCU) -DF_CPU=$(F_CPU) -DBAUD=$(BAUD) -Os -Wall -Werror

SRC_DIR = src
INC_DIR = include
BUILD_DIR = build

SRC = $(wildcard $(SRC_DIR)/*.cpp)
OBJ = $(patsubst $(SRC_DIR)/%.cpp, $(BUILD_DIR)/%.o, $(SRC))
ELF_FILE = $(BUILD_DIR)/firmware.elf
HEX_FILE = $(BUILD_DIR)/firmware.hex

all: $(HEX_FILE)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp $(BUILD_DIR)
	$(CC) $(CCFLAGS) -I$(INC_DIR) -c -o $@ $<

$(ELF_FILE): $(OBJ)
	$(CC) $(CCFLAGS) -o $(BUILD_DIR)/firmware.elf $^

$(HEX_FILE): $(ELF_FILE)
	avr-objcopy -O ihex -R .eeprom $(BUILD_DIR)/firmware.elf $@
	avr-size -C $(BUILD_DIR)/firmware.elf --mcu=$(MCU)

$(BUILD_DIR):
	mkdir $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)

.PHONY: clean
