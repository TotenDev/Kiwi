#
# Make File for GCC with GNUStep and Obj-c
# 
# Should Use: gcc `gnustep-config --objc-flags` -Wall -L/usr/GNUstep/System/Library/Libraries/ -lgnustep-base teste.m -o teste
# Compiler: GCC
# Linker: GNUStep Obj-c Libraries

# Macro declarations

CC = gcc
CFLAGS = `gnustep-config --objc-flags` -g -std=c99
LIBS = -L/usr/GNUstep/System/Library/Libraries/ -lgnustep-base -lobjc
SRC= RemoteProcedure.m QueueManager.m main.m

# Explicit rules
hist: $(OBJ)
	$(CC) $(CFLAGS) -o TQueue $(SRC) $(LIBS)


#clean
	echo Cleaning
	rm -rf *.d *.o 
	