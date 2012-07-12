#
# makefile — Kiwi
# today is 7/12/12, it is now 19:25 PM
# created by TotenDev
# see LICENSE for details.
#
# Make File for GCC with GNUStep and Obj-c
# 
# Should Use: gcc `gnustep-config --objc-flags` -Wall -L/usr/GNUstep/System/Library/Libraries/ -lgnustep-base teste.m -o teste
# Compiler: GCC
# Linker: GNUStep Obj-c Libraries

# Macro declarations

CC = gcc
CFLAGS = `gnustep-config --objc-flags` -Wno-unknown-pragmas -g -std=c99
LIBS = -L/usr/GNUstep/System/Library/Libraries/ -lgnustep-base -lobjc
SRC= RemoteProcedure.m WWQueue.m Logger.m QueueManager.m MessageCenter.m main.m

# Explicit rules
hist: $(OBJ)
	$(CC) $(CFLAGS) -o kiwid $(SRC) $(LIBS)

# Clean
	@echo -n "Cleaning... "
	@rm -rf *.d *.o
	@echo "[done]"

test:
	@echo -n "Testing... "
	./kiwid
	@echo "[done]"

clean:
	@echo -n "Cleaning... "
	@rm -rf *.d *.o kiwid
	@echo "[done]"

install:
	@echo -n "Coping to /usr/bin ... "
	@sudo cp kiwid /usr/bin
	@echo "[done]"

