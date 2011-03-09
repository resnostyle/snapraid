/*
 * Copyright (C) 2011 Andrea Mazzoleni
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef __HANDLE_H
#define __HANDLE_H

/****************************************************************************/
/* handle */

struct snapraid_handle {
	char path[PATH_MAX]; /**< Path of the file. */
	struct snapraid_disk* disk; /**< Disk of the file. */
	struct snapraid_file* file; /**< File opened. */
	int f; /**< Handle of the file. */
};

/**
 * Create a file.
 * The file is created if missing, and opening with write access.
 */
int handle_create(struct snapraid_handle* handle, struct snapraid_file* file);

/**
 * Open a file.
 * The file is opened for reading.
 */
int handle_open(int ret_on_error, struct snapraid_handle* handle, struct snapraid_file* file);

void handle_close(struct snapraid_handle* handle);

int handle_read(int ret_on_error, struct snapraid_handle* handle, struct snapraid_block* block, unsigned char* block_buffer, unsigned block_size);

void handle_write(struct snapraid_handle* handle, struct snapraid_block* block, unsigned char* block_buffer, unsigned block_size);

#endif
