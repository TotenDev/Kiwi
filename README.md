#Kiwi Queue

Kiwi Queue has been developed by TotenDev team, as an internal system with the main principle of queuing async messages of multiple process into one process, so it can be done FIFO. 
This messages execute scripts in any language with parameters recorded in memory, until the message is executed.

##Requirements

- [GNU Step](http://www.techotopia.com/index.php/Building_and_Installing_GNUstep_on_Linux) **and some dependencies**

##Installing

All Stable code will be on `master` branch, any other branch is designated to unstable codes. So if you are installing for production environment, use `master` branch for better experience.

To run Kiwi you MUST have GNU Step configured and running on server. All preferences and configurations can be configured at `Config.h` file before compile it.

After configured your environment follow steps below to get Kiwi working.

1.Compile it

	1.make
	
2.Install it (it'll be moved to `/usr/bin/`)

	$ make install
	
3.Start kiwid process


	$ kiwid

##Configuration

All Configuration can be done through `Config.h` file in root three.

- `logFilePath` - Log Full File Path. **REQUIRED**
- `logPath` - Log Path, used to store old log files. **REQUIRED**
- `logFileSize` - Maximum Log File size. **REQUIRED**
- `ipcQueueKey` - IPC Queue ID (INTEGER). **REQUIRED**
- `maxNumberOfConcurrencyProcedures` - Max Number of concurrency procedures. **REQUIRED**
- `optimizedMode` - Optimized mode will receive 1 message at .1 seconds, if not optimized will receive all messages that it can process in .1 seconds. **REQUIRED**

##How It Works
Kiwi is based on IPC message queue, and is designed to fast and reliable message queuing in same environment as message sender.

Basically Kiwi, queue all messages with same queue identifier and execute then FIFO, so you can have multiple process in different queues and not worry about opening to much threads or waiting for child process to finish. :)

When you send a message to Kiwi, can be thousands of messages (with same queue id) waiting to execute before you, meaning that it can take hours to execute your message. By this we must have a piece of code to execute in local files as scripts, so we can assure that our message will be executed when it can.

When you are sending the message, you have four parameters to send:

- `MessageQueue Key` - It got be same as `ipcQueueKey` in `Config.h` file. It's the system queue identifier. This should be unique for each Kiwi that you are running.
- `QueueID` - This parameter represents a thread identifier, so all messages with same QueueID will be done FIFO and in one thread. With this you can control your concurrency between messages, example: one ID for mailing and other for metrics.
- `Worker FilePath` - This is the worker which will be executed by Kiwi.
- `Worker Parameters` - (Will be the worker parameters when it get reached by Kiwi queue.

##Features

- Can have multiple Kiwi queues running on same environment. (shouldn't be necessary)
- No CPU usage when idle.
- Execute any language script (since installed on environment).
- Allows thousands of messages in on process.
- Message run time concurrency control.

##Wrappers

There are some wrappers to send message to Kiwi Queue as:

Kiwi PHP (not available yet)

Kiwi NodeJS(not available yet)

[Kiwi Ruby](https://github.com/TotenDev/Kiwi-LibRuby/)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

##License

[GNU GENERAL PUBLIC LICENSE V3](Kiwi/raw/master/LICENSE)