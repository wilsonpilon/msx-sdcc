CC = sdcc
ASM = sdasz80
PLATFORM = -mz80
EMULATOR = openmsx -script emulation/boot.tcl
HEXBIN = hex2bin

STARTUPDIR = startups
INCLUDEDIR = includes
LIBDIR = libs
SRCDIR = src

# See startup files for the correct ADDR_CODE and ADDR_DATA
CRT0 = crt0msx_msxdos_advanced.s
ADDR_CODE = 0x0180
ADDR_DATA = 0

VERBOSE = -V
LIBS = $(LIBDIR)/fusion.lib
CCFLAGS = $(VERBOSE) $(PLATFORM) --code-loc $(ADDR_CODE) --data-loc $(ADDR_DATA) \
          --no-std-crt0 --opt-code-size --out-fmt-ihx $(LIBS)
OBJECTS = $(CRT0) putchar.s getchar.s dos.s conio.c
SOURCES = main.c
OUTFILE = main.com

.PHONY: all compile build clean emulator

all: clean compile build emulator

compile: $(OBJECTS) $(SOURCES)

$(CRT0):
		@echo "Compiling $(CRT0)"
		@$(ASM) -o $(notdir $(@:.s=.rel)) $(STARTUPDIR)/$(CRT0)
%.s:
		@echo "Compiling $@"
		@[ -f $(LIBDIR)/$@ ] && $(ASM) -o $(notdir $(@:.s=.rel)) $(LIBDIR)/$@ || true
		@[ -f $(SRCDIR)/$@ ] && $(ASM) -o $(notdir $(@:.s=.rel)) $(SRCDIR)/$@ || true
%.c:
		@echo "Compiling $@"
		@[ -f $(LIBDIR)/$@ ] && $(CC) $(VERBOSE) $(PLATFORM) -I$(INCLUDEDIR) -c -o $(notdir $(@:.c=.rel)) $(LIBDIR)/$@ || true
		@[ -f $(SRCDIR)/$@ ] && $(CC) $(VERBOSE) $(PLATFORM) -I$(INCLUDEDIR) -c -o $(notdir $(@:.c=.rel)) $(SRCDIR)/$@ || true

$(SOURCES):
		$(CC) -I$(INCLUDEDIR) $(CCFLAGS) \
				$(addsuffix .rel, $(basename $(notdir $(OBJECTS)))) \
				$(SRCDIR)/$(SOURCES)

build: main.ihx
		@echo "Building $(OUTFILE)..."
		@$(HEXBIN) main.ihx
		@mv main.bin bin/${OUTFILE}
		@echo "Done."

clean:
		@echo "Cleaning ...."
		rm -f *.asm *.bin *.cdb *.ihx *.lk *.lst *.map *.mem *.omf *.rst *.rel *.sym *.noi *.hex *.lnk *.dep
		rm -f bin/$(OUTFILE)

emulator: 
		#$(OUTFILE)
		@echo "Emulator $(OUTFILE)..."
		$(EMULATOR) &
		#For ROM use:
		#$(EMULATOR) $(OUTFILE) &
