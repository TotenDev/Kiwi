<?php

namespace TotenDev\Kiwi;

class Queue
{
    protected $key;
    protected $id;
    protected $name;

    public function __construct($name, $key)
    {
        $this->key = $key;
        $this->name = $name;
        $this->id = msg_get_queue($this->key, 0777);
    }

    public function getId()
    {
        return $this->id;
    }

    public function getName()
    {
        return $this->name;
    }

    public function getKey()
    {
        return $this->key;
    }
}
