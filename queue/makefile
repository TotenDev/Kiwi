#
# Make File for GCC with GNUStep and Obj-c
# 
# Should Use: gcc `gnustep-config --objc-flags` -L/usr/GNUstep/System/Library/Libraries/ -lgnustep-base teste.m -o teste
# Compiler: GCC
# Linker: GNUStep Obj-c Libraries

# Macro declarations

CC = gcc
CFLAGS = `gnustep-config --objc-flags` -g -std=c99
LIBS = -L/usr/GNUstep/System/Library/Libraries/ -lgnustep-base -lobjc
SRC= RemoteProcedure.m QueueManager.m main.m
OBJ=main.o QueueManager.o RemoteProcedure.o 

# Explicit rules
hist: $(OBJ)
	$(CC) $(CFLAGS) -o TQueue $(OBJ) $(LIBS)


# Implicit rules
main.o: 
	$(CC) $(CFLAGS) main.m $(LIBS)
QueueManager.o: 
	$(CC) $(CFLAGS) QueueManager.m $(LIBS)
RemoteProcedure.o: 
	$(CC) $(CFLAGS) RemoteProcedure.m $(LIBS)


#clean