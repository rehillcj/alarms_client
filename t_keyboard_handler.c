/*
 * Copyright (C) 2021 Parnart, Inc.
 * Arlington, Virginia USA
 *(703) 528-3280 http://www.parnart.com
 *
 * All rights reserved.
 *
*/

/*----------------------------------------------------------------*/
/* t_process_monitor.c						  */
/*----------------------------------------------------------------*/

#include <errno.h>
#include <libpq-fe.h>
#include <ncurses.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <sys/time.h>
#include <sys/types.h>

#include "alarms.h"

void t_keyboard_handler(s_data_t *data)
{
	struct timeval timeout;
	unsigned char key;
	char tbuff[1024], printbuff[SIZE_PRINTBUFF];
	PGconn *conn_app = NULL;
	PGconn *conn_arduino = NULL;
	PGresult *res1 = NULL;

	pthread_mutex_t *pmut_sql_app = &data->mut_sql_app;
	
	pid_t pid;
	FILE *pidfd;

	pid = getpid();
	pidfd = fopen(data->pid_path, "a");
	fprintf(pidfd, "t_keyboard_handler: %i\n", pid);
	fclose(pidfd);


	//set_tty_raw();
	while(data->quit == FALSE) {

		key = kb_getc();
		if ((key == 'q') || (key == 'Q')) {
			data->quit = TRUE;

			//release main.c primary loop

		        memset(tbuff, 0, sizeof(tbuff));
		        sprintf(tbuff, "host=%s user=%s dbname=%s", data->dbhost_app, data->dbuser_app, data->dbname_app);
		        conn_app = PQconnectdb(tbuff);
		        if (PQstatus(conn_app) != CONNECTION_OK) {
		        	memset(printbuff, 0, SIZE_PRINTBUFF);
		                sprintf(printbuff, "exiting on error, connecting to app database in 't_keyboard_handler' failed: %s", PQerrorMessage(conn_app));
		                do_print(data, printbuff, RED);
		                PQfinish(conn_app);
		                exit(ERROR_DB_CONNECT_APP);
		        }
		
			memset(tbuff, 0, sizeof(tbuff));
			sprintf(tbuff, "select pg_notify('new_event', '');");
			pthread_mutex_lock(pmut_sql_app);
			res1 = PQexec(conn_app, tbuff);
			pthread_mutex_unlock(pmut_sql_app);
			PQclear(res1);

			//release peripheral threads
		        memset(tbuff, 0, sizeof(tbuff));
		        sprintf(tbuff, "host=%s user=%s dbname=%s", data->dbhost_arduino, data->dbuser_arduino, data->dbname_arduino);
		        conn_arduino = PQconnectdb(tbuff);
		        if (PQstatus(conn_arduino) != CONNECTION_OK) {
		        	memset(printbuff, 0, SIZE_PRINTBUFF);
		                sprintf(printbuff, "exiting on error, connecting to arduino database in 't_keyboard_handler' failed: %s", PQerrorMessage(conn_app));
		                do_print(data, printbuff, RED);
		                PQfinish(conn_arduino);
		                exit(ERROR_DB_CONNECT_APP);
		        }
		
			memset(tbuff, 0, sizeof(tbuff));
			sprintf(tbuff, "select pg_notify('status_i2c_arduino_mqtt', '');");
			pthread_mutex_lock(pmut_sql_app);
			res1 = PQexec(conn_arduino, tbuff);
			pthread_mutex_unlock(pmut_sql_app);
			PQclear(res1);

			memset(tbuff, 0, sizeof(tbuff));
			sprintf(tbuff, "select pg_notify('status_dio_arduino_mqtt', '');");
			pthread_mutex_lock(pmut_sql_app);
			res1 = PQexec(conn_arduino, tbuff);
			pthread_mutex_unlock(pmut_sql_app);
			PQclear(res1);
		}

		if ((key == 'p') || (key == 'P')) {
			if (data->print == FALSE)
				data->print = TRUE;
			else	data->print = FALSE;
			if (data->curses) {
				wmove(data->w_banner, 2, 3);
				if (data->print)
					wprintw(data->w_banner, "type 'q' to quit, 'p' to suspend screen output");
				else	wprintw(data->w_banner, "type 'q' to quit, 'p' to resume screen output ");
				wrefresh(data->w_banner);
			} else if (data->print == FALSE)
				printf("\n\nprinting suspended.  type 'p <enter>' to resume.\n\n");

		}
		timeout.tv_sec = (long) 0;
		timeout.tv_usec = (long) 520000;
		select(0, (fd_set *) 0, (fd_set *) 0, (fd_set *) 0, &timeout);
	}
	//set_tty_cooked();
}

