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
SRC=main.m QueueManager.m RemoteProcedure.m
OBJ=main.o QueueManager.o RemoteProcedure.o 
D_HEADERS=queue-Prefix.pch TDLog.h

# Explicit rules
hist: $(OBJ)
	$(CC) $(CFLAGS) -o main $(OBJ) $(LIBS)


# Implicit rules
main.o: 
	$(CC) $(CFLAGS) main.m QueueManager.h $(D_HEADERS) $(LIBS)
QueueManager.o: 
	$(CC) $(CFLAGS) QueueManager.h QueueManager.m RemoteProcedure.h $(D_HEADERS) $(LIBS)
RemoteProcedure.o: 
	$(CC) $(CFLAGS) RemoteProcedure.h RemoteProcedure.m $(D_HEADERS) $(LIBS)


#clean