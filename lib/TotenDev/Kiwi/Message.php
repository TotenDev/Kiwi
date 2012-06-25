<?php

namespace TotenDev\Kiwi;

class Message
{
    protected $queue;
    protected $worker;
    protected $args;

    public function setQueue(Queue $queue)
    {
        $this->queue = $queue;
    }

    public function getQueue()
    {
        return $this->queue;
    }

    public function setWorker($worker)
    {
        $this->worker = $worker;
    }

    public function getWorker()
    {
        return $this->worker;
    }

    public function setArgs(array $args)
    {
        $this->args = $args;
    }

    public function getArgs()
    {
        $args = implode(' ', $this->args);
        return "\"$args\"";
    }

    public function send()
    {
        $message[] = $this->getQueue()->getName();
        $message[] = $this->getWorker();
        $message[] = $this->getArgs();

        $status = msg_send($this->getQueue()->getId(), 1, implode('||', $message), true, true, $errorCode);
        
        if (!$status) {
            throw new \RuntimeException('Message could not be sent. Error code: ' . $errorCode);
        }
    }
}
