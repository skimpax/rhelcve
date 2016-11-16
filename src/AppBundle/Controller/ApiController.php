<?php

namespace AppBundle\Controller;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Method;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\JsonResponse;
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
        $qs = $request->getQueryString();
        if ($qs != null) {
            $url .= '?';
            $url .= $qs;
        }
        $logger = $this->get('logger');
        $logger->warn($url);
        if ($request->query->get('after')) {
            $logger->warn($request->query->get('after'));
            $logger->warn($request->query->get('severity'));
        }

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

        $qs = $request->getQueryString();
        if ($qs != null) {
            $url .= '?';
            $url .= $qs;
        }
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
        $qs = $request->getQueryString();
        if ($qs != null) {
            $url .= '?';
            $url .= $qs;
        }
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
