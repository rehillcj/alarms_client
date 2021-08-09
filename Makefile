#
# Copyright (C) 2003 Conrad Rehill (703) 528-3280
# All rights reserved.
#
# This software may be freely copied, modified, and redistributed
# provided that this copyright notice is preserved on all copies.
#
# There is no warranty or other guarantee of fitness of this software
# for any purpose.  It is provided solely "as is".
#
#

#----------------------------------------------------------------
# pronoc 33/53 Server Program Makefile
#----------------------------------------------------------------

SHELL=/bin/bash

EXECUTABLE= alarms
OBJ= main.o signal_handlers.o t_process_monitor.o t_loop.o t_dbtrigger_i2c.o t_dbtrigger_ain.o t_dbtrigger_dio_arduino.o t_dbtrigger_dio_apc_snmp.o parser.o t_keyboard_handler.o do_print.o kbhit.o
INCLUDEDIR=.
CFLAGS= -I$(INCLUDEDIR) -I/usr/include/postgresql -Wall
LDFLAGS= -lpthread -lpq -lncurses
CC = gcc

all: $(EXECUTABLE)

$(EXECUTABLE): $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) -o $@ $(LDFLAGS)
	chmod 775 $(EXECUTABLE)

main.o: main.c alarms.h
	$(CC) $(CFLAGS) -c main.c -o $*.o
parser.o: parser.c alarms.h
	$(CC) $(CFLAGS) -c $*.c
signal_handlers.o: signal_handlers.c alarms.h
	$(CC) $(CFLAGS) -c $*.c
t_process_monitor.o: t_process_monitor.c alarms.h
	$(CC) $(CFLAGS) -c $*.c
t_loop.o: t_loop.c alarms.h
	$(CC) $(CFLAGS) -c $*.c
t_dbtrigger_i2c.o: t_dbtrigger_i2c.c alarms.h
	$(CC) $(CFLAGS) -c $*.c
t_dbtrigger_ain.o: t_dbtrigger_ain.c alarms.h
	$(CC) $(CFLAGS) -c $*.c
t_dbtrigger_dio_arduino.o: t_dbtrigger_dio_arduino.c alarms.h
	$(CC) $(CFLAGS) -c $*.c
t_dbtrigger_dio_apc_snmp.o: t_dbtrigger_dio_apc_snmp.c alarms.h
	$(CC) $(CFLAGS) -c $*.c
#t_exterior.o: t_exterior.c alarms.h
#	$(CC) $(CFLAGS) -c $*.c
t_keyboard_handler.o: t_keyboard_handler.c alarms.h
	$(CC) $(CFLAGS) -c $*.c
do_print.o: do_print.c alarms.h
	$(CC) $(CFLAGS) -c $*.c
kbhit.o: kbhit.c
	$(CC) $(CFLAGS) -c $*.c


clean:
	rm -f ./*.o
	rm -f ./$(EXECUTABLE)
	rm -f ./a.out
	rm -f ./core

install:
	cp -f ./alarms.conf /usr/local/etc
	cp -f ./alarms /usr/local/bin
	cp -f ./scripts/* /usr/local/sbin/alarms