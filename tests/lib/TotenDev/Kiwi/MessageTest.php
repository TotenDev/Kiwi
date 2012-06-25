<?php

use TotenDev\Kiwi\Queue;
use TotenDev\Kiwi\Message;

class MessageTest extends PHPUnit_Framework_TestCase
{
    public function testIsCreatingMessage()
    {
        $queue = new Queue('MyTestQueue');
        $message = new Message;
        $message->setQueue($queue);
        $message->setWorker('/var/www/test.php');
        $message->setArgs(array(
            'arg1' => 'test',
            'arg2' => 'anotherTest',
        ));
        $message->send();

        msg_receive($queue->getId(), 0, $type, 10000, $results, true);
        $this->assertEquals('MyTestQueue||/var/www/test.php||"test anotherTest"', $results);
        $this->assertEquals(1, $type);
    }
}