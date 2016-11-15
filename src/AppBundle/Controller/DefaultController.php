<?php

namespace AppBundle\Controller;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use Lsw\ApiCallerBundle\Call\HttpGetJson;

class DefaultController extends Controller
{
    const BASEURL = 'https://access.redhat.com/labs/securitydataapi';

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
     * @Route("/rhelsec/cvrf", name="rhelsec_cvrf")
     */
    public function getCvrfAction(Request $request)
    {
        $url = self::BASEURL . '/cvrf.json';
        $url .= '?after=2016-11-10';
        $params = array();

        $json = $this->container->get('api_caller')->call(
            new HttpGetJson(
                $url,
                $params
            )
        );
        print_r($json);

        return $this->render('default/security.html.twig', [
            'base_dir' => realpath($this->getParameter('kernel.root_dir').'/..').DIRECTORY_SEPARATOR,
            'data' => $json
            ]);
    }

    /**
     * @Route("/rhelsec/cve", name="rhelsec_cve")
     */
    public function getCveAction(Request $request)
    {
        $url = self::BASEURL . '/cve.json';
        $url .= '?after=2016-11-10';
        $params = array();

        $json = $this->container->get('api_caller')->call(
            new HttpGetJson(
                $url,
                $params
            )
        );
        print_r($json);

        return $this->render('default/security.html.twig', [
            'base_dir' => realpath($this->getParameter('kernel.root_dir').'/..').DIRECTORY_SEPARATOR,
            'data' => $json
            ]);
    }

        /**
     * @Route("/rhelsec/oval", name="rhelsec_oval")
     */
    public function getOvalAction(Request $request)
    {
        $url = self::BASEURL . '/oval.json';
        $url .= '?after=2016-11-10';
        $params = array();

        $json = $this->container->get('api_caller')->call(
            new HttpGetJson(
                $url,
                $params
            )
        );
        print_r($json);

        return $this->render('default/security.html.twig', [
            'base_dir' => realpath($this->getParameter('kernel.root_dir').'/..').DIRECTORY_SEPARATOR,
            'data' => $json
            ]);
    }
}
