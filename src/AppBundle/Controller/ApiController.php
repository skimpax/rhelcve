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
    const URL_CVRF = self::BASEURL . '/cvrf.json';
    const URL_CVE = self::BASEURL . '/cve.json';
    const URL_OVAL = self::BASEURL . '/oval.json';

    /**
     * @Route("/api/rhdb/cvrf", name="api_rhdb_cvrf")
     * @Method({"GET"})
     */
    public function getCvrfAction(Request $request)
    {
        $params = $this->extractRhDbQueryParamsArray($request);

        $jsonrepr = $this->container->get('api_caller')->call(
            new HttpGetJson(
                self::URL_CVRF,
                $params
            )
        );

        return new JsonResponse(['data' => $jsonrepr]);
    }

    /**
     * @Route("/api/rhdb/cve", name="api_rhdb_cve")
     * @Method({"GET"})
     */
    public function getCveAction(Request $request)
    {
        $params = $this->extractRhDbQueryParamsArray($request);

        $jsonrepr = $this->container->get('api_caller')->call(
            new HttpGetJson(
                self::URL_CVE,
                $params
            )
        );

        return new JsonResponse(['data' => $jsonrepr]);
    }

    /**
     * @Route("/api/rhdb/oval", name="api_rhdb_oval")
     * @Method({"GET"})
     */
    public function getOvalAction(Request $request)
    {
        $params = $this->extractRhDbQueryParamsArray($request);

        $jsonrepr = $this->container->get('api_caller')->call(
            new HttpGetJson(
                self::URL_OVAL,
                $params
            )
        );

        return new JsonResponse(['data' => $jsonrepr]);
    }

    /**
     * @Route("/api/rheltriage", name="api_rheltriage")
     * @Method({"GET"})
     */
    public function getRhelTriageAction(Request $request)
    {
        $params = array();

        $intercept_params = [ 'rhelversion'];
        $allparams = $this->extractRhDbQueryParamsArray($request);

        // retrieve all CVRF for the date
        $severity = $request->query->get('severity');
        if ($severity != null) {
            $params['severity'] = $severity;
        }

        $jsonrepr = $this->container->get('api_caller')->call(
            new HttpGetJson(
                self::URL_CVRF,
                $params
            )
        );

        // build list of all RHSA found out by CSRF criteria
        $allRhsa = array();
        foreach ($jsonrepr as $key => $value) {
            $allRhsa[] = $value['RHSA'];
        }

        $params = array();
        $filteredRhsa = array();
        $results = array()
        foreach ($allRhsa as $key => $rhsa) {
            // retrieve info for that specific RHSA
            $url = self::URL_CVRF . "/" . $rhsa . ".json";
            $jsonrepr = $this->container->get('api_caller')->call(
                new HttpGetJson(
                    $url,
                    $params
                )
            );
            // append result
            $results[] = $jsonrepr;

            //
            foreach ($jsonrepr['cvrfdoc']['product_tree']['branch'] as $key => $prodbranch) {
                if ($prodbranch['type'] === 'Product Family' && strpos($prodbranch['name'], 'Red Hat Enterprise Linux') !== null) {
                    if (gettype($prodbranch['branch']) === "array") {
                        // TODO
                    } else {
                        foreach ($prodbranch['branch'] as $key => $prod) {
                            if (strpos($prod['full_product_name'], 'Red Hat Enterprise Linux Server') !== null && strpos($prod['full_product_name'], '(v. 7)') !== null) {
                                $filteredRhsa[] = $rhsa;
                            }
                        }
                    }
                }
            }
        }

        return new JsonResponse(['data' => $results]);
    }

    private function extractRhDbQueryParamsArray(Request $request)
    {
        $qpstring = $request->getQueryString();
        $qparray = [];
        parse_str($qpstring, $qparray);

        return $qparray;
    }
}
