<?php

namespace AppBundle\Controller;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Method;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use Lsw\ApiCallerBundle\Call\HttpGetJson;

class ApiController extends Controller
{
    const BASEURL = 'https://access.redhat.com/labs/securitydataapi';

    /**
     * @Route("/api/cvrf", name="api_cvrf")
     * @Method({"GET"})
     */
    public function getCvrfAction(Request $request)
    {
        $url = self::BASEURL . '/cvrf.json';
        $url .= '?after=2016-11-10';
        $params = array();

        $jsonrepr = $this->container->get('api_caller')->call(
            new HttpGetJson(
                $url,
                $params
            )
        );

        return new JsonResponse(['data' => $jsonrepr]);
    }

    /**
     * @Route("/api/cve", name="api_cve")
     * @Method({"GET"}) 
     */
    public function getCveAction(Request $request)
    {
        $url = self::BASEURL . '/cve.json';
        $url .= '?after=2016-11-10';
        $params = array();

        $jsonrepr = $this->container->get('api_caller')->call(
            new HttpGetJson(
                $url,
                $params
            )
        );

        return new JsonResponse(['data' => $jsonrepr]);
    }

    /**
     * @Route("/api/oval", name="api_oval")
     * @Method({"GET"})
     */
    public function getOvalAction(Request $request)
    {
        $url = self::BASEURL . '/oval.json';
        $url .= '?after=2016-11-10';
        $params = array();

        $jsonrepr = $this->container->get('api_caller')->call(
            new HttpGetJson(
                $url,
                $params
            )
        );

        return new JsonResponse(['data' => $jsonrepr]);
    }
}
