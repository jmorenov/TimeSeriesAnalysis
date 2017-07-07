<?php

foreach (glob(__DIR__ . '/../src/controllers/*.php') as $filename)
{
    include $filename;
}