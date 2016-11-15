<?php

namespace AppBundle\Controller;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use Lsw\ApiCallerBundle\Call\HttpGetJson;

class DefaultController extends Controller
{
    /**
     * @Route("/", name="homepage")
     */
    public function indexAction(Request $request)
    {
        // replace this example code with whatever you need
        return $this->render('default/index.html.twig', [
            'base_dir' => realpath($this->getParameter('kernel.root_dir').'/..').DIRECTORY_SEPARATOR,
        ]);
    }

    /**
     * @Route("/cve", name="cve")
     */
    public function getCveAction(Request $request)
    {
        // $data = [];

        // $arrayToPost = array(
        //     'ip_address' => array(
        //         'name' => 'IpName',
        //         'hostname' => 'HostName',
        //         'ip' => '192.168.0.1',
        //         'throttling_template' => array(
        //             'name' => 'Throttling Template'
        //         )
        //     )
        // ); // this will be json_encode. If you don't want to json_encode, use HttpPostJson instead of HttpPostJsonBody
        // $output = $this->get('api_caller')->call(new HttpPostJsonBody($url, $arrayToPost, true, $parameters)); // true to have an associative array as answer


$url = 'https://access.redhat.com/labs/securitydataapi';
$url .= '/cvrf.json'
$url .= '?after=2016-11-10'
$data = array();
$returnAssociativeArray = true;

//add curl options
// $options = array(
//     'userpwd' => 'demo:privateKey'
//     'httpheader' => array('Content-type' => 'application/json')
// );


        $json = $this->container->get('api_caller')->call(
                    new HttpPostJson(
                        $url,
                        $data,
                        // $returnAssociativeArray,
                        // $options
                    )
                );

        return $this->render('default/cve.html.twig', [
            'base_dir' => realpath($this->getParameter('kernel.root_dir').'/..').DIRECTORY_SEPARATOR,
            'allcve' => json_decode($json)
        ]);
    }
}
