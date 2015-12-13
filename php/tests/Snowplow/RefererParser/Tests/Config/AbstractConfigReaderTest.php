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
    
    public function testAddReferer()
    {
        $reader = $this->createConfigReaderFromFile();
        $this->assertNull($reader->addReferer("intra.example.com", "Custom search", "search", ['searchq']));
        
        $res = $reader->lookup("intra.example.com");
        $this->assertArrayHasKey('source', $res);
        $this->assertArrayHasKey('medium', $res);
        $this->assertNotEmpty('parameters', $res);
        
        $this->assertNull($reader->lookup("nosearch.example.com"));
    }
    
    public function testErrorOnAddingWrongReferer()
    {
        $reader = $this->createConfigReaderFromFile();
        $this->setExpectedException('Exception');
        $this->assertNull($reader->addReferer("intra.example.com", "Custom search", "search", 'noarray'));
    }
}
