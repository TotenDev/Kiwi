<?php

use TotenDev\Kiwi\Queue;

class QueueTest extends PHPUnit_Framework_TestCase
{
    public function testIsCreatingQueue()
    {
        $queue = new Queue('MyTestQueue', 5253);
        $this->assertEquals('5253', $queue->getKey());
        $this->assertTrue(msg_queue_exists($queue->getKey()));
        $this->assertEquals('MyTestQueue', $queue->getName());
        $this->assertInternalType('resource', $queue->getId());

        $queue = new Queue('MyTestQueue');
        $this->assertTrue(msg_queue_exists($queue->getKey()));
        $this->assertEquals('MyTestQueue', $queue->getName());
        $this->assertInternalType('resource', $queue->getId());
    }
}