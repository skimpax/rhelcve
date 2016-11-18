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

        $params = $this->extractQueryParamsArray($request);

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

        $params = $this->extractQueryParamsArray($request);

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

        $params = $this->extractQueryParamsArray($request);

        $jsonrepr = $this->container->get('api_caller')->call(
            new HttpGetJson(
                $url,
                $params
            )
        );

        return new JsonResponse(['data' => $jsonrepr]);
    }

    private function extractQueryParamsArray(Request $request)
    {
        $qpstring = $request->getQueryString();
        $qparray = [];
        parse_str($qpstring, $qparray);

        return $qparray;
    }
}
