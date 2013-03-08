ZJLogger
========

a light-weight log tools for cocoa

The log message is like:
[TIME:timestamp PID:process_id TID:thread_id LVL:log_msg_level] log_msg

Description of the log message fields:

timestamp	 The date and time when the log message was generated. The
		timestamp has the following format: "yyyy/MM/dd HH:mm:ss".

process_id	The ID of the process that generated the log message.

thread_id	The ID of the thread that generated the log message.

log_msg_level	The level of importance of the log message. See below for more
		details.

log_msg	The contents of the log message.

-------------------------------------------------------------------------------
LOG MESSAGE LEVELS
-------------------------------------------------------------------------------

Every log message generated by the application is assigned one of the following
log message levels:

"FATAL"		A fatal error that will cause the application to terminate.
		This log level is used to report an error during application
		initialization or initialization of application components and
		libraries needed for proper application execution.

"ERROR"		A non fatal error that will not cause the application to
		terminate, but will not be able to correctly execute the action
		that user requested. This messages can include: network errors,
		API errors, and so on.

"WARNING"	This level is used to report a potentially dangerous situation
		that does not cause an error yet, but might lead to an error in
		the future. This messages can include: warnings about data/file
		conflicts in iCloud, file not exist and so on.

"INFO"		This level is used to briefly trace the stack execution flow of
		the application. It helps to put the log messages with higher
		levels (warning, error, fatal) into a context. This messages
		can include: user action, important function names currently
		executed, etc.

"DEBUG"        This level is used for log messages that are useful during
		application development and debugging.


ALL the message will be written into disk.
When in Release, only level not less than INFO will be written into the disk.
In other words, the DEBUG level message will only be outputted into the console.
While in DEBUG, all the message will both be outputted into disk and be printed 
in the console.


Notice:
This is mainly created for cocoa project, but iOS project can work,too.
Fully-objc support will be in the future.
ARC will also be supported in the near future.