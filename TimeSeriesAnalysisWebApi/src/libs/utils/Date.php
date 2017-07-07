<?php
namespace TimeSeriesAnalysisWebApi\libs\utils;

use DateTime;
use DateTimeZone;
use Exception;

class Date extends DateTime {
    public static $default_format = 'Y-m-d H:i:s';
    public static $nano_format = 'U.u';
    public static $timestamp_format = 'U';

    /**
     * Date constructor.
     * @param string $date
     * @param string $format
     * @param $timezone
     * @throws Exception
     */
    public function __construct($date, $format, $timezone) {
        $_timezone = new DateTimeZone($timezone);

        if($format == self::$timestamp_format) {
            $date_formated = new DateTime('now', $_timezone);
            $date_formated->setTimestamp($date);
        }
        else if($format == 'nt') {
            $second = substr($date, 0, 10);
            $date = $second . '.' . substr($date, 10, 6);
            $date_formated = parent::createFromFormat(self::$nano_format, $date, $_timezone);
        } else {
            $date_formated = parent::createFromFormat($format, $date, $_timezone);
        }

        if($date_formated == false) {
            throw new Exception('Error: Wrong date format');
        }

        parent::__construct($date_formated->format(self::$default_format), $_timezone);
    }
    
    public function getTimestamp($nanosecond = false) {
        if($nanosecond) {
            $timestamp = ((double) $this->format(self::$nano_format)) * 1000000000;
        } else {
            $timestamp = ((int) $this->format(self::$timestamp_format));
        }
        return $timestamp;
    }
    
    public function getDate($format = null) {
        if ($format == null) {
            $format = self::$default_format;
        }

        return $this->format($format);
    }
    
    public function __toString() {
        return $this->getDate();
    }

    public static function getFormatOfArray($arrayOfDates, $timezone) {
        $_timezone = new DateTimeZone($timezone);
        $formats = array('Y-m-d', 'Y-d-m', self::$default_format, self::$nano_format, self::$timestamp_format);
        $format_i = 0;
        $formatCorrect = NULL;
        $dateFormated = false;

        while($formatCorrect == NULL && $format_i <= count($formats)) {
            $format = $formats[$format_i];
            foreach($arrayOfDates as $date) {
                $dateFormated = parent::createFromFormat($format, $date, $_timezone);
                if ($dateFormated == false) {
                    break;
                }
            }
            if ($dateFormated != false) {
                $formatCorrect = $format;
            } else {
                $format_i++;
            }
        }
        if ($formatCorrect == NULL) {
            throw new Exception('Error: Wrong date format');
        }

        return $formatCorrect;
    }
}
