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
     * @Route("/api/rhdb/cvrf/{rhsa}", name="api_rhdb_cvrf_details", 
     * requirements={"rhsa": "RH[BES]A-\d{4}:\d{4}"})
     * @Method({"GET"})
     */
    public function getCvrfDetailsAction(Request $request, $rhsa)
    {
        $logger = $this->get('logger');

        $params = array();
        $url = self::BASEURL . "/cvrf/" . $rhsa . ".json";

        $jsonrepr = $this->container->get('api_caller')->call(
            new HttpGetJson(
                $url,
                $params
            )
        );

        //$arr = json_decode(json_encode($jsonrepr), true);
        //$logger->error($arr);
        $data = [
        'rhlink' => $url,
        'data' => $jsonrepr
        ];

        return new JsonResponse(['data' => $data]);
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

        $logger = $this->get('logger');

        $intercept_params = [ 'rhelversion'];
        $allparams = $this->extractRhDbQueryParamsArray($request);

        // retrieve all CVRF for the date
        $severity = $request->query->get('severity');
        if ($severity != null) {
            $params['severity'] = $severity;
        }
        $after = $request->query->get('after');
        if ($after != null) {
            $params['after'] = $after;
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
            $arr = (array)$value;
            $logger->error("******** " . $key);
            $logger->error($arr['RHSA']);
            $allRhsa[] = $arr['RHSA'];
        }

        $params = array();
        $filteredRhsaIds = array();
        $allRhsaData = array();
        foreach ($allRhsa as $key => $rhsa) {
            // retrieve info for that specific RHSA
            $url = self::BASEURL . "/cvrf/" . $rhsa . ".json";
            $jsonrepr = $this->container->get('api_caller')->call(
                new HttpGetJson(
                    $url,
                    $params
                )
            );
            // append result
            // convert object to true array
            $arr = json_decode(json_encode($jsonrepr), true);
            $allRhsaData[$rhsa] = $arr;

            //
            if (isset($arr['cvrfdoc']['product_tree'])) {
                foreach ($arr['cvrfdoc']['product_tree']['branch'] as $key => $prodbranch) {
                    if ($prodbranch['type'] === 'Product Family' && strpos($prodbranch['name'], 'Red Hat Enterprise Linux') !== null) {
                        if (gettype($prodbranch['branch']) === "array") {
                            // TODO
                        } else {
                            foreach ($prodbranch['branch'] as $key => $prod) {
                                if (strpos($prod['full_product_name'], 'Red Hat Enterprise Linux Server') !== null && strpos($prod['full_product_name'], '(v. 7)') !== null) {
                                    $filteredRhsaIds[] = $rhsa;
                                }
                            }
                        }
                    }
                }
            }
        }

        $results = array();
        foreach ($filteredRhsaIds as $key => $rhsa) {
            $rhsadata = $allRhsaData[$rhsa];
            $resdata = array();
            $resdata['RHSA'] = $rhsa;
            if (isset($rhsadata['cvrfdoc']['product_tree'])) {
                 foreach ($arr['cvrfdoc']['product_tree']['branch'] as $key => $prodbranch) {
                    if ($prodbranch['type'] === 'Product Version') {
                        if (gettype($prodbranch['branch']) === "array") {
                            // TODO
                        } else {
                            $resdata['packages'][] = $prodbranch['name'];
                            // foreach ($prodbranch['branch'] as $key => $prod) {
                            //     if (strpos($prod['full_product_name'], 'Red Hat Enterprise Linux Server') !== null && strpos($prod['full_product_name'], '(v. 7)') !== null) {
                            //         $filteredRhsaIds[] = $rhsa;
                            //     }
                            // }
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
