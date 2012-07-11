Kiwi Queue [![Build Status](https://secure.travis-ci.org/TotenDev/TDevShortener.png?branch=master)](http://travis-ci.org/TotenDev/TDevShortener)
=========================

Kiwi Queue has been developed by TotenDev team, as an internal system with the main principle of queuing async messages of multiple process into one process, so it can be done FIFO.

Requirements
=========
- [GNU Step](http://www.techotopia.com/index.php/Building_and_Installing_GNUstep_on_Linux) **and some dependencies**

Installing
=========
All Stable code will be on `master` branch, any other branch is designated to unstable codes. So if you are installing for production environment, use `master` branch for better experience.

To run Kiwi you MUST have GNU Step configured and running on server. All preferences and configurations can be configured at `Config.h` file before compile it.

After configured your environment you can run commands below to compile Kiwi:

	1.make
	2.make install
	3.kiwid (will start the process)

Configuration
========
All Configuration can be done through `Config.h` file in root three.

- `logFilePath` - Log Full File Path. **REQUIRED**
- `logPath` - Log Path, used to store old log files. **REQUIRED**
- `logFileSize` - Maximum Log File size. **REQUIRED**
- `ipcQueueKey` - IPC Queue ID (INTEGER). **REQUIRED**
- `maxNumberOfConcurrencyProcedures` - Max Number of concurrency procedures. **REQUIRED**
- `optimizedMode` - Optimized mode will receive 1 message at .1 seconds, if not optimized will receive all messages that it can process in .1 seconds. **REQUIRED**

Messaging
========
There are some wrappers to send message to Kiwi Queue as:

[Kiwi PHP]()

[Kiwi NodeJS]()

[Kiwi Ruby]()

But you can still sending very simple messages through php:

        $MSGKEY = 9090;
        $msg_id = msg_get_queue ($MSGKEY, 0600);

		$message[] = "EmailQueueID";
        $message[] = "/var/worker.php";
        $message[] = "--test";

        if (!msg_send ($msg_id, 1, implode('||', $message), true, 0, $msg_err))
        echo "Msg not sent because $msg_err\n";
	
There are four important pieces in sending messages:
	
- Message Queue ID (Same as `$MSGKEY`. It got be same as `ipcQueueKey` in `Config.h` file.
- QueueID (First parameter of `$message`. This is QueueID, where all messages with this QueueID, will be done FIFO and in one thread).
- Worker FilePath (Second parameter of `$message`. This is the worker which will be executed by Kiwi, when it can).
- Worker Parameters (Third parameter of `$message`. Will be the worker parameters when it get reached by Kiwi queue).

License
========
[GNU GENERAL PUBLIC LICENSE V3](Kiwi/raw/master/LICENSE)