<?php

class BuzzBlaze_Plugin_Profiler extends Zend_Controller_Plugin_Abstract
{

  protected $_timeStart = 0;

  public function routeStartup(Zend_Controller_Request_Abstract $request)
  {
    $this->_timeStart = microtime(true);
  }

  public function dispatchLoopShutdown()
  {
    $output = '<div id="profiler">';

    // execution profiler
    $timeEnd = microtime(true);
    $time = $timeEnd - $this->_timeStart;

    $output .= '<strong>Execution Profiler</strong>';
    $output .= '<pre>Script executed in ' . $time . ' seconds</pre>' . "\n";

    // db profiler
    $bootstrap = Zend_Controller_Front::getInstance()->getParam('bootstrap');
    $db = $bootstrap->getResource('db'); 
    $profiler = $db->getProfiler();

    $totalTime = $profiler->getTotalElapsedSecs();
    $queryCount = $profiler->getTotalNumQueries();

    $longestTime = 0;
    $longestQuery = null;
    $queriesArray = array();

    $dbo = '<pre>No database queries</pre>';
    if($profiler->getQueryProfiles()) {
      foreach($profiler->getQueryProfiles() as $query) {
        $queriesArray[] = array(
        					'elapsed' => $query->getElapsedSecs(),
                            'query' => $query->getQuery(),
                            'type' => substr($query->getQuery(),0,strpos($query->getQuery(),' ')),
                            'params' => $query->getQueryParams()
                          );
        
        if($query->getElapsedSecs() > $longestTime) {
          $longestTime = $query->getElapsedSecs();
          $longestQuery = $query->getQuery();
        }
      }

      $dbo = '<pre>'
        . 'Executed ' . $queryCount . ' queries in ' . $totalTime . ' seconds' . "\n"
        . 'Average query length: ' . $totalTime / $queryCount . ' seconds' . "\n"
        . 'Queries per second: ' . $queryCount / $totalTime . "\n"
        . 'Longest query length: ' . $longestTime . "\n"
        . "Longest query: \n" . $longestQuery . "\n"
        . '</pre>';
    }

    $output .= '<strong>Db Profiler</strong>';
    $output .= $dbo;

    $n = 1;
    $queries = '<div id="allqueries">';
    foreach($queriesArray as $query){
      $queries .= '<div class="query">'
      . '<div class="query_title"><div class="query_num">'.$n.'</div>'
      . '<div class="query_type">'.$query['type'].'</div>'
      . $query['elapsed'].'</div>'
      . '<p class="query_query">'.$query['query'].'</p>'
      . '</div>';
      $n++;
    }

    $queries .= '</div>';
    $output .= $queries;  
    $output .= '</div>';
    
    $this->getResponse()->appendBody($output);
  }

}

