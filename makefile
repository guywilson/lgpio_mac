PROJNAME=liblgpio

# What is our target
TARGET=$(PROJNAME).a

SOURCE=src
BUILD=build
DEP = dep

LIBDIR=lib

C = gcc
LINKER = gcc
LIBTOOL=libtool

# postcompile step
PRECOMPILE = @ mkdir -p $(BUILD) $(DEP)
# postcompile step
POSTCOMPILE = @ mv -f $(DEP)/$*.Td $(DEP)/$*.d

CFLAGS = -c -O2 -Wall -pedantic
DEPFLAGS = -MT $@ -MMD -MP -MF $(DEP)/$*.Td

COMPILE.c = $(C) $(CFLAGS) $(DEPFLAGS) -o $@
LINK.o = $(LINKER) -o $@
LIB.o = $(LIBTOOL) -o $@

CSRCFILES = $(wildcard $(SOURCE)/*.c)
OBJFILES = $(patsubst $(SOURCE)/%.c, $(BUILD)/%.o, $(CSRCFILES))
DEPFILES = $(patsubst $(SOURCE)/%.c, $(DEP)/%.d, $(CSRCFILES))

all: $(LIBDIR)/$(TARGET)

# Compile C/C++ source files
#
$(LIBDIR)/$(TARGET): $(OBJFILES)
	$(LIB.o) $<

$(BUILD)/%.o: $(SOURCE)/%.c
$(BUILD)/%.o: $(SOURCE)/%.c $(DEP)/%.d
	$(PRECOMPILE)
	$(COMPILE.c) $<
	$(POSTCOMPILE)

.PRECIOUS = $(DEP)/%.d
$(DEP)/%.d: ;

-include $(DEPFILES)

install: $(TARGET)
	cp $(TARGET) /usr/local/lib
	cp $(SRC)/lgpio.h /usr/local/include

clean:
	rm -r $(BUILD)
	rm -r $(DEP)
	rm -r $(LIBDIR)
