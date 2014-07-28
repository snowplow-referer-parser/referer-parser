<?php
namespace Snowplow\RefererParser\Tests\Config;

use PHPUnit_Framework_TestCase as TestCase;
use Snowplow\RefererParser\Config\ConfigReaderInterface;

abstract class AbstractConfigReaderTest extends TestCase
{
    /** @return ConfigReaderInterface */
    abstract protected function createConfigReader($fileName);

    public function testExceptionIsThrownIfFileDoesNotExist()
    {
        $this->setExpectedException(
            'Snowplow\RefererParser\Exception\InvalidArgumentException',
            'File "INVALIDFILE" does not exist'
        );
        $this->createConfigReader('INVALIDFILE');
    }
}
