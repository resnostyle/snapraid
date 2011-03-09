Name{number}
	snapraid - SnapRAID Backup For Disk Arrays

Synopsis
	:snapraid [-c, --conf CONFIG] [-s, --start BLOCK]
	:	[-f, --force] [-v, --verbose] [-e, --exclude PATTERN]
	:	COMMAND

	:snapraid [-V, --version] [-h, --help]

Description
	SnapRAID is a backup program for a disk array using redundancy.

	SnapRAID uses a disk of the array to store redundancy information,
	and it allows to recover from a complete disk failure.

	SnapRAID is based on the snapshot concept like a backup program.
	You decide the time to make the "sync" of the redundancy information,
	and you are able to restore all the changes done at a disk of the array,
	until the "sync".

	The main features of SnapRAID are:

	* You can start using SnapRAID with already filled disks.
		You do not have to reformat or copy your data.
	* The disks of the array can have different sizes.
		You have only to use the biggest one for the redundancy data.
	* The data in the disks is not changed in any way.
		It doesn't even need write access at the data.
	* If more than one disk fails, you lose the data only on the failed disks.
		All the data in the other disks is safe.
	* It doesn't lock-in your data.
		You can stop using SnapRAID at any time.

Limitations
	SnapRAID is in between a RAID and a backup program trying to get the best
	benefits of them. Altough it also has some downsides that you should
	consider before using it:

	* You have different filesystems for each disk.
		Using a RAID you have only a big filesystem.
	* It doesn't stripe data.
		With RAID you get a speed boost with striping.
	* It doesn't support realtime recovery.
		With RAID you do not have to stop working when a disk fails.
	* It's able to recover damages only from a single disk.
		With a Backup you are able to recover from a complete
		failure of the whole disk array.

Getting Started
	To use SnapRAID you need first to mount all the disks of your disk
	array and select which one to dedicate as redundancy information.

	This disk will be dedicated to this pourpuse only, and you should
	not store any other data on it.

	You have to pick the biggest disk in the array, as the redundancy
	information may grow in size as the biggest data disk in the array.

	Suppose now that you have mounted all your disks in the mount points:

		:/mnt/diskpar
		:/mnt/disk1
		:/mnt/disk2
		:/mnt/disk3

	you have to create the configuration file /etc/snapraid.conf with
	the following content:

		:parity /mnt/diskpar/parity
		:content /mnt/diskpar/content
		:disk d1 /mnt/disk1/
		:disk d2 /mnt/disk2/
		:disk d3 /mnt/disk3/

	At this point you are ready to start the "sync" command to build the
	redundancy information.

		:snapraid sync

	This process will take some hours at best the first time, depending on
	the size of the data already present in the data disks.
	If the disks are empty the process is immediate.
	You can stop it at any time pressing Ctrl+C, and at the next run it
	will start where interrupted.

	When this command completes, your data is SAFE.

	At this point you can start using your data as you like, and peridiocally
	update the redundancy information running the "sync" command.

	To check the integrity of your data you can use the "check" command:

		:snapraid check

	If will read all your data, to check if it's correct.

	If an error is found, you can use the "fix" command to fix it.

		:snapraid fix

	Note that the fix command will revert your data at the state of the
	last "sync" command executed. It works like a snapshot was taken
	in "sync".

Configuration
	SnapRAID requires a configuration file to know where your disk array
	is located, and where storing the redundancy information.

	This configuration file is located in /etc/snapraid.conf and
	it should contains the following options:

	=parity FILE
		Defines the file to use to store the redundancy information.
		It must be placed in a disk dedicated for this porpose with
		as much free space as the biggest disk in the array.
		This option can be used only one time.

	=content FILE
		Defines the file to use to store the content of the redundancy
		organization.
		It must be placed in the same disk of the parity file, or in
		another location, but not in a disk of the array.
		This option can be used only one time.

	=disk NAME DIR
		Defines the name and the mount point of the disks of the array.
		NAME is used to identify the disk, and it must be unique.
		DIR is the mount point of the disk in the filesystem.
		You can change the mount point as you like, as far you
		keep the NAME fixed.
		You should use one option for each disk of the array.

	=block_size SIZE_IN_KILOBYTES
		Defines the basic block size in kilo bytes of
		the redundancy blocks. The default is 128 and it should
		work for most conditions.
		You should use this option only if you do not have enough
		memory to run SnapRAID.
		It requires to run TS*24/BS bytes, where TS is the total
		size in bytes of your disk array, and BS is the block size
		in bytes.

		For example with 6 disk of 2 TB and a block size of 128 kB you
		have:

		:memory = (6 * 2 * 2^40) * 24 / (128 * 2^10) = 2.3 GB

	An example of a typical configuration is:

		:parity /mnt/diskpar/parity
		:content /mnt/diskpar/content
		:disk d1 /mnt/disk1/
		:disk d2 /mnt/disk2/
		:disk d3 /mnt/disk3/
		:block_size 256

Commands
	SnapRAID provides three simple commands that allow to:

	* Make a backup/snapshot -> "sync"
	* Check for integrity -> "check"
	* Restore the last backup/snapshot -> "fix".
	
	=sync
		Updates the redundancy information. All the modified files
		in the disk array are read, and the redundancy data is
		updated.
		You can stop this process at any time pressing Ctrl+C,
		without losing the work already done.

	=check
		Checks all the files the redundancy data. All the files
		are hashed and compared with the snapshot saved in the
		previous "sync" command.

	=fix
		Checks and fix all the files. It's like "check" but it
		also tries to fix problems reverting the state of the
		disk array at the previous "sync" command.

Options
	-c, --conf CONFIG
		Selects the configuration file. If not specified is assumed
		the file `/etc/snapraid.conf'.

	-s, --start BLOCK
		Starts the processing from the specified
		block number. It could be useful to easy retry to fix
		some specific block, in case of a damaged disk.

	-f, --force
		Forces insecure operations. If snapraid detects
		an unsafe operation, it stops the execution asking you
		to use this option to force the operation.
		For example, it happens if all the files in a disk are
		missing.

	-e, --exclude PATTERN
		This option define an exclusion pattern to be applyed at
		the files with the "sync" command. It has no effect with
		other commands.

	-v, --verboe
		Prints more information in the processing.

	-h, --help
		Prints a short help screen.

	-V, --version
		Prints the program version.

Copyright
	This file is Copyright (C) 2011 Andrea Mazzoleni

See Also
	rsync(1)
