/*
 * Copyright (C) 2003 Parnart, Inc.
 * Arlington, Virginia USA
 *(703) 528-3280 http://www.parnart.com
 *
 * All rights reserved.
 *
*/

/*----------------------------------------------------------------*/
/* main.c							  */
/*----------------------------------------------------------------*/

#include <libpq-fe.h>
#include <ncurses.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h> //threads
#include <signal.h>  //signal handler
#include <string.h>
#include <syslog.h>
#include <unistd.h>  //getopt
#include <netinet/in.h>
#include <sys/io.h>
#include <sys/resource.h>
#include <sys/socket.h>
#include <sys/stat.h>

#include "alarms.h"

int main(int argc, char *argv[]){

	int i, j, k, opt, nice;
	s_data_t data;
	struct tm pltime;
	//struct timeval timeout;
	time_t now;
	char timestring[22], sqlbuff[256], tbuff[256], printbuff[SIZE_PRINTBUFF], tmp_path[SIZE_PATHBUFF];
	char *pid_path = data.pid_path;
	char *app_path = data.app_path;
	char *app_name = data.app_name;
	char *init_path = data.init_path;
	char *dbhost_arduino = data.dbhost_arduino;
	char *dbhost_apc_snmp = data.dbhost_apc_snmp;
	char *dbhost_app = data.dbhost_app;
	char *dbuser_arduino = data.dbuser_arduino;
	char *dbuser_apc_snmp = data.dbuser_apc_snmp;
	char *dbuser_app = data.dbuser_app;
	char *dbname_arduino = data.dbname_arduino;
	char *dbname_apc_snmp = data.dbname_apc_snmp;
	char *dbname_app = data.dbname_app;
	char *host_anemometer = data.host_anemometer;
	char *script_directory = data.script_directory;
		
	struct sigaction sa, sa_old;
	struct stat statbuf;
	mode_t modes;
	
	pthread_t process_monitor, dbtrigger_i2c, dbtrigger_dio_arduino, processloop, keyboard_handler;
	//pthread_t dbtrigger_ain, dbtrigger_dio_apc_snmp;
	//pthread_t exterior;
	//pthread_mutex_t *pmut_sql_app, *pmut_sql_apc_snmp, *pmut_sql_hvac;
	//pthread_mutex_t *pmut_sql_app;
	
	PGnotify *notify;
	PGconn *conn_arduino, *conn_app;
	//PGconn *conn_apc_snmp;
	PGresult *res1;
	//PGresult *res2, *res3;
	pid_t pid;
	uid_t uid;
	FILE *fd;
	unsigned char daemonize;
		
	//seed random number generator
	srand(time(0));
	
	//process command line arguments
	memset(app_path, 0, SIZE_PATHBUFF);
	sprintf(app_path, argv[0]);
	for (i = 0, j = 0; i <= strlen(app_path) - 1; i++)
		if (app_path[i] == 0x2F)
			j = i;
	memset(app_name, 0, SIZE_PATHBUFF);
	for (i = (j == 0) ? 0 : (j + 1), k = 0; i <= (strlen(app_path) - 1); i++, k++)
		app_name[k] = app_path[i];
	app_name[k] = 0;
	
	memset(init_path, 0, SIZE_PATHBUFF);
	sprintf(init_path, "/usr/local/etc/%s.conf", app_name);
	
	
	data.verbose = FALSE;
	data.curses = FALSE;
	data.print = TRUE;
	data.quit = FALSE;
	data.error = 0;
	data.code = 0;
	nice = 0;
	daemonize = 1;
	
	time(&now);
	localtime_r(&now, &pltime);
	strftime(timestring, 21, "20%y/%m/%d %H:%M:%S", &pltime);

	while((opt = getopt(argc, argv, "dn:vf:ch")) != -1){	//process command line overrides of defaults
		switch(opt){
			case 'd':
				daemonize = 0;
				break;
			case 'n':
				nice = atoi(optarg);
			case 'v':
				daemonize = 0;
				data.verbose = TRUE;
				break;
			case 'f':
				memset(init_path, 0, SIZE_PATHBUFF);
				sprintf(init_path, "%s", optarg);
				break;
			case 'c':
				data.curses = TRUE;
				data.verbose = TRUE;
				daemonize = 0;
				break;
			case 'h':
				printf("%s\n", argv[0]);
				printf("\tthis program must be run as user 'controller'\n");
				printf("\t-n <nice> : nice value (-15)\n");
				printf("\t-d        : run in foreground\n");
				printf("\t-f <file> : start with configuration file <file>\n");
				printf("\t-v        : run in verbose mode (implies -d)\n");
				printf("\t-c        : run in curses mode (implies -d -v)\n");
				printf("\t-h        : print this message\n\n");
				printf("alarm controller, version 0.10\n");
				printf("Copyright 2021 Parnart, Inc.\n\n");
				exit(-1);
				break;
			case '?':
				printf("try -h for option list\n");
				exit(-1);
				break;
		}
	}

       if (data.curses) {
                initscr();
                start_color();
                init_pair(WHITE, COLOR_WHITE, COLOR_BLACK);
                init_pair(RED, COLOR_RED, COLOR_BLACK);
                init_pair(GREEN, COLOR_GREEN, COLOR_BLACK);
                init_pair(YELLOW, COLOR_YELLOW, COLOR_BLACK);
                init_pair(MAGENTA, COLOR_MAGENTA, COLOR_BLACK);
                init_pair(CYAN, COLOR_CYAN, COLOR_BLACK);
                init_pair(BLUE, COLOR_BLUE, COLOR_BLACK);
                init_pair(BLACK, COLOR_BLACK, COLOR_WHITE);
                getmaxyx(stdscr, data.winheight, data.winwidth);
                data.w_main = newwin(data.winheight - 6, data.winwidth - 2, 1, 1);
                wattron(data.w_main, COLOR_PAIR(WHITE));
                data.winrow_main = 0;
                data.wincol_main = 2;
                scrollok(data.w_main, TRUE);
                //wmove(data.w_main, 0, 0); // was 1, 2
                wrefresh(data.w_main);

                data.w_banner = newwin(4, data.winwidth - 2, (data.winheight - 4), 1);
                scrollok(data.w_banner, FALSE);
                wattron(data.w_banner, COLOR_PAIR(WHITE));
                wattron(data.w_banner, A_BOLD);
                wmove(data.w_banner, 1, 3);
                wprintw(data.w_banner, "alarm processor started %s", timestring);
                wmove(data.w_banner, 1, (data.winwidth - 33));
                wprintw(data.w_banner, "copyright 2021, Conrad Rehill");
                wmove(data.w_banner, 2, 3);
                wprintw(data.w_banner, "type 'q' to quit, 'p' to suspend screen output");
                wrefresh(data.w_banner);

        }

	pthread_mutex_init(&data.mut_sql_arduino, NULL);
	pthread_mutex_init(&data.mut_sql_apc_snmp, NULL);
	pthread_mutex_init(&data.mut_sql_app, NULL);
	pthread_mutex_init(&data.mut_print, NULL);


	memset(printbuff, 0, SIZE_PRINTBUFF);
	sprintf(printbuff, "%s application start", timestring);
	do_print(&data, printbuff, RED);

	memset(&statbuf, 0, sizeof(statbuf));
	stat(init_path, &statbuf);
	modes = statbuf.st_mode;
	if (S_ISREG(modes)) {
		memset(dbhost_arduino, 0, SIZE_DB_ARG);
		parse_init(init_path, script_directory, "SCRIPT_DIRECTORY");
		if (strlen(script_directory) < 1) {
			memset(script_directory, 0, SIZE_DB_ARG);
			sprintf(script_directory, "/usr/local/sbin");
			memset(printbuff, 0, SIZE_PRINTBUFF);
			sprintf(printbuff, "alarm script directory 'script_directory' not defined. default to '%s'.", script_directory);
			do_print(&data, printbuff, WHITE);
		}
		memset(dbhost_arduino, 0, SIZE_DB_ARG);
		parse_init(init_path, dbhost_arduino, "DBHOST_ARDUINO");
		if (strlen(dbhost_arduino) < 1) {
			memset(dbhost_arduino, 0, SIZE_DB_ARG);
			sprintf(dbhost_arduino, "127.0.0.1");
			memset(printbuff, 0, SIZE_PRINTBUFF);
			sprintf(printbuff, "config file entry 'dbhost_arduino' not defined. default to '%s'.", dbhost_arduino);
			do_print(&data, printbuff, WHITE);
		}
		memset(dbhost_apc_snmp, 0, SIZE_DB_ARG);
		parse_init(init_path, dbhost_apc_snmp, "DBHOST_APC_SNMP");
		if (strlen(dbhost_apc_snmp) < 1) {
			memset(dbhost_apc_snmp, 0, SIZE_DB_ARG);
			sprintf(dbhost_apc_snmp, "127.0.0.1");
			memset(printbuff, 0, SIZE_PRINTBUFF);
			sprintf(printbuff, "config file entry 'dbhost_apc_snmp' not defined. default to '%s'.", dbhost_apc_snmp);
			do_print(&data, printbuff, WHITE);
		}
		memset(dbhost_app, 0, SIZE_DB_ARG);
		parse_init(init_path, dbhost_app, "DBHOST_APP");
		if (strlen(dbhost_app) < 1) {
			memset(dbhost_app, 0, SIZE_DB_ARG);
			sprintf(dbhost_app, "127.0.0.1");
			memset(printbuff, 0, SIZE_PRINTBUFF);
			sprintf(printbuff, "config file entry 'dbhost_app' not defined. default to '%s'.", dbhost_app);
			do_print(&data, printbuff, WHITE);
		}
		memset(dbuser_arduino, 0, SIZE_DB_ARG);
		parse_init(init_path, dbuser_arduino, "DBUSER_ARDUINO");
		if (strlen(dbuser_arduino) < 1) {
			memset(dbuser_arduino, 0, SIZE_DB_ARG);
			sprintf(dbuser_arduino, "controller");
			memset(printbuff, 0, SIZE_PRINTBUFF);
			sprintf(printbuff, "config file entry 'dbuser_arduino' not defined. default to '%s'.", dbuser_arduino);
			do_print(&data, printbuff, WHITE);
		}
		memset(dbuser_apc_snmp, 0, SIZE_DB_ARG);
		parse_init(init_path, dbuser_apc_snmp, "DBUSER_APC_SNMP");
		if (strlen(dbuser_apc_snmp) < 1) {
			memset(dbuser_apc_snmp, 0, SIZE_DB_ARG);
			sprintf(dbuser_apc_snmp, "controller");
			memset(printbuff, 0, SIZE_PRINTBUFF);
			sprintf(printbuff, "config file entry 'dbuser_apc_snmp' not defined. default to '%s'.", dbuser_apc_snmp);
			do_print(&data, printbuff, WHITE);
		}
		memset(dbuser_app, 0, SIZE_DB_ARG);
		parse_init(init_path, dbuser_app, "DBUSER_APP");
		if (strlen(dbuser_app) < 1) {
			memset(dbuser_app, 0, SIZE_DB_ARG);
			sprintf(dbuser_app, "controller");
			memset(printbuff, 0, SIZE_PRINTBUFF);
			sprintf(printbuff, "config file entry 'dbuser_app' not defined. default to '%s'.", dbuser_app);
			do_print(&data, printbuff, WHITE);
		}
		memset(dbname_arduino, 0, SIZE_DB_ARG);
		parse_init(init_path, dbname_arduino, "DBNAME_ARDUINO");
		if (strlen(dbname_arduino) < 1) {
			memset(dbname_arduino, 0, SIZE_DB_ARG);
			sprintf(dbname_arduino, "arduino_mqtt");
			memset(printbuff, 0, SIZE_PRINTBUFF);
			sprintf(printbuff, "config file entry 'dbname_arduino' not defined. default to '%s'.", dbname_arduino);
			do_print(&data, printbuff, WHITE);
		}
		memset(dbname_apc_snmp, 0, SIZE_DB_ARG);
		parse_init(init_path, dbname_apc_snmp, "DBNAME_APC_SNMP");
		if (strlen(dbname_apc_snmp) < 1) {
			memset(dbname_apc_snmp, 0, SIZE_DB_ARG);
			sprintf(dbname_apc_snmp, "apc_snmp");
			memset(printbuff, 0, SIZE_PRINTBUFF);
			sprintf(printbuff, "config file entry 'dbname_apc_snmp' not defined. default to '%s'.", dbname_apc_snmp);
			do_print(&data, printbuff, WHITE);
		}
		memset(dbname_app, 0, SIZE_DB_ARG);
		parse_init(init_path, dbname_app, "DBNAME_ALARMS");
		if (strlen(dbname_app) < 1) {
			memset(dbname_app, 0, SIZE_DB_ARG);
			sprintf(dbname_app, "alarms_mqtt");
			memset(printbuff, 0, SIZE_PRINTBUFF);
			sprintf(printbuff, "config file entry 'dbname_app' not defined. default to '%s'.", dbname_app);
			do_print(&data, printbuff, WHITE);
		}
		memset(host_anemometer, 0, SIZE_DB_ARG);
		parse_init(init_path, host_anemometer, "HOST_ANEMOMETER");
		if (strlen(host_anemometer) < 1) {
			memset(printbuff, 0, SIZE_PRINTBUFF);
			sprintf(printbuff, "no anemometer host defined. skipping wind measurents.");
			do_print(&data, printbuff, WHITE);
		}
	} else {
		data.code = 2;
		memset(printbuff, 0, SIZE_PRINTBUFF);
		sprintf(printbuff, "exiting on error, config file not readable. (code %i)", data.code);
		do_print(&data, printbuff, WHITE);
		curses_shutdown(&data, 3);
		exit(data.code);
	}

	memset(tbuff, 0, sizeof(tbuff));
	sprintf(tbuff, "host=%s user=%s dbname=%s", dbhost_arduino, dbuser_arduino, dbname_arduino);
	conn_arduino = PQconnectdb(tbuff);
	if (PQstatus(conn_arduino) != CONNECTION_OK) {
		data.code = 4;
		memset(printbuff, 0, SIZE_PRINTBUFF);
		sprintf(printbuff, "exiting on error, connecting to arduino database failed: %s", PQerrorMessage(conn_arduino));
		do_print(&data, printbuff, RED);
		PQfinish(conn_arduino);
		curses_shutdown(&data, 3);
		exit(data.code);
	}
        memset(printbuff, 0, SIZE_PRINTBUFF);
        sprintf(printbuff, "main thread - libpq connection to %s, fd: %i", tbuff, PQsocket(conn_arduino));
        do_print(&data, printbuff, RED);

	/*memset(tbuff, 0, sizeof(tbuff));
	sprintf(tbuff, "host=%s user=%s dbname=%s", dbhost_apc_snmp, dbuser_apc_snmp, dbname_apc_snmp);
	conn_apc_snmp = PQconnectdb(tbuff);
	if (PQstatus(conn_apc_snmp) != CONNECTION_OK) {
		memset(printbuff, 0, SIZE_PRINTBUFF);
		sprintf(printbuff, "exiting on error, connecting to APC SNMP database failed: %s", PQerrorMessage(conn_apc_snmp));
		do_print(&data, printbuff, RED);
		PQfinish(conn_apc_snmp);
		exit(ERROR_DB_CONNECT_APC_SNMP);
	}
        memset(printbuff, 0, SIZE_PRINTBUFF);
        sprintf(printbuff, "main thread - libpq connection to %s, fd: %i", tbuff, PQsocket(conn_apc_snmp));
        do_print(&data, printbuff, RED);*/

	memset(tbuff, 0, sizeof(tbuff));
	sprintf(tbuff, "host=%s user=%s dbname=%s", dbhost_app, dbuser_app, dbname_app);
	conn_app = PQconnectdb(tbuff);
	if (PQstatus(conn_app) != CONNECTION_OK) {
		memset(printbuff, 0, SIZE_PRINTBUFF);
		sprintf(printbuff, "exiting on error, connecting to app database failed: %s", PQerrorMessage(conn_app));
		do_print(&data, printbuff, RED);
		PQfinish(conn_app);
		exit(ERROR_DB_CONNECT_APP);
	}
        memset(printbuff, 0, SIZE_PRINTBUFF);
        sprintf(printbuff, "main thread - libpq connection to %s, fd: %i", tbuff, PQsocket(conn_app));
        do_print(&data, printbuff, RED);

        res1 = PQexec(conn_app, "insert into log (description) values ('application start')");
        PQclear(res1);

	//daemonize application
	if (daemonize){
		if ((pid = fork()) < 0)
			return(-1);
		else if (pid != 0)
			exit(0);
		setsid();
		chdir("/");
		umask(0);
	}

	pid = getpid();
	iopl(3);
	setpriority(PRIO_PROCESS, pid, nice);
	//set up signal handler for Ctrl-C & broken pipe (socket failure)
	sa.sa_handler = handler;
	//sigfillset(&sa.sa_mask);
	sigemptyset(&sa.sa_mask);
	sigaddset(&sa.sa_mask, SIGINT);
	sigaddset(&sa.sa_mask, SIGPIPE);
	sigaddset(&sa.sa_mask, SIGCHLD);
	sa.sa_flags = 0;
	sigaction(SIGINT, &sa, &sa_old);
	sigaction(SIGPIPE, &sa, &sa_old);

	uid = getuid();
	if (uid == 0)
		sprintf(pid_path, "/var/run/%s.pid", data.app_name);
	else	sprintf(pid_path, "/var/run/user/%i/%s.pid", uid, data.app_name);
	sprintf(tmp_path, "/tmp/%i", pid);
	unlink(tmp_path);
	unlink(pid_path);
	fd = fopen(tmp_path, "w");
	fprintf(fd, "%s\n", app_name);
	fclose(fd);

	fd = fopen(pid_path, "w");
	fprintf(fd, "main: %i\n", pid);
	fclose(fd);

	pthread_create(&dbtrigger_i2c, NULL, (void *) t_dbtrigger_i2c, &data);
	sleep(1);
	//pthread_create(&dbtrigger_ain, NULL, (void *) t_dbtrigger_ain, &data);
	//sleep(1);
	pthread_create(&dbtrigger_dio_arduino, NULL, (void *) t_dbtrigger_dio_arduino, &data);
	sleep(1);
	//pthread_create(&dbtrigger_dio_apc_snmp, NULL, (void *) t_dbtrigger_dio_apc_snmp, &data);
	//sleep(1);
	pthread_create(&process_monitor, NULL, (void *) t_process_monitor, &data);
	sleep(1);
	pthread_create(&processloop, NULL, (void *) t_processloop, &data);
	sleep(1);
	if (data.verbose) {
		pthread_create(&keyboard_handler, NULL, (void *) t_keyboard_handler, &data);
		sleep(1);
	}
	////pthread_create(&exterior, NULL, (void *) t_exterior, &data);
	////sleep(1);

	////pthread_detach(exterior);
	//pthread_detach(processloop);
	//pthread_detach(dbtrigger_i2c);
	//pthread_detach(dbtrigger_ain);
	//pthread_detach(dbtrigger_dio_arduino);
	//pthread_detach(dbtrigger_dio_apc_snmp);
	//pthread_detach(process_monitor);

        memset(printbuff, 0, SIZE_PRINTBUFF);
        sprintf(printbuff, "main thread libpq connection to %s, fd: %i", tbuff, PQsocket(conn_app));
        do_print(&data, printbuff, RED);
        res1 = PQexec(conn_app, "LISTEN new_event");
        if (PQresultStatus(res1) != PGRES_COMMAND_OK) {
                PQclear(res1);
                PQfinish(conn_app);
                exit(ERROR_DB_LISTEN_ARDUINO);
        }
        PQclear(res1);

	while (data.quit == FALSE) {

                int socksql;
                fd_set input_mask;

		if (db_conn_error(conn_app))
			data.error = ERROR_DB_CONNECT_APP;
		if (db_conn_error(conn_arduino))
			data.error = ERROR_DB_CONNECT_ARDUINO;
		//if (db_conn_error(conn_apc_snmp))
		//	data.error = ERROR_DB_CONNECT_APC_SNMP;

                socksql = PQsocket(conn_app);
                FD_ZERO(&input_mask);
                FD_SET(socksql, &input_mask);
                if (select(socksql + 1, &input_mask, NULL, NULL, NULL) < 0) {
                        PQfinish(conn_app);
                        exit(1);
                }

                PQconsumeInput(conn_app);
                while ((notify = PQnotifies(conn_app)) != NULL) {
                        memset(printbuff, 0, sizeof(printbuff));
                        sprintf(printbuff, "ASYNC NOTIFY of '%s' PID %d: %s", notify->relname, notify->be_pid, notify->extra);
                        do_print(&data, printbuff, BLUE);

			memset(printbuff, 0, sizeof(printbuff));
			sprintf(printbuff, "%s/%s &", script_directory, notify->extra);
                     	if (strlen(printbuff) > (strlen(script_directory)+ 3)) {
	                     	system(printbuff);
				do_print(&data, printbuff, BLACK);	
			}

                }
		//sleep(1);
	}

	pthread_join(processloop, NULL);
	pthread_join(dbtrigger_i2c, NULL);
	//pthread_join(dbtrigger_ain, NULL);
	pthread_join(dbtrigger_dio_arduino, NULL);
	//pthread_join(dbtrigger_dio_apc_snmp, NULL);
	pthread_join(process_monitor, NULL);
        if (data.verbose)
                pthread_join(keyboard_handler, NULL);




	//sleep a bit and then quit gracefully
	sleep(2);
	PQfinish(conn_app);
	//PQfinish(conn_apc_snmp);
	PQfinish(conn_arduino);

        memset(printbuff, 0, SIZE_PRINTBUFF);
        sprintf(printbuff, "exiting normally with code %i.", data.code);
        do_print(&data, printbuff, BLACK);
        curses_shutdown(&data, 1);
	exit(data.error);

}
	
int db_conn_error (PGconn *conn) {
	int i = 0;
	while ((PQstatus(conn) != CONNECTION_OK) && (i < 60)) {
		PQreset(conn);
		sleep(1);
		i++;
	}
	if (PQstatus(conn) != CONNECTION_OK)
		return TRUE;
	else	return FALSE;		
}
