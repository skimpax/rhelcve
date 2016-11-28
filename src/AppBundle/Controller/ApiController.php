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
     * @Route("/api/rhdb/cvrf", name="api_rhdb_list_cvrf")
     * @Method({"GET"})
     */
    public function getCvrfListAction(Request $request)
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
     * @Route("/api/rhdb/cvrf/{rhsa}", name="api_rhdb_one_cvrf_details",
     * requirements={"rhsa": "RH[BES]A-\d{4}:\d{4}"})
     * @Method({"GET"})
     */
    public function getOneCvrfDetailsAction(Request $request, $rhsa)
    {
        $params = array();
        $url = self::BASEURL . "/cvrf/" . $rhsa . ".json";

        $jsonrepr = $this->container->get('api_caller')->call(
            new HttpGetJson(
                $url,
                $params
            )
        );

        $data = array();
        if ($jsonrepr !== null) {
            $data = [
            'rhlink' => $url,
            'jsondata' => $jsonrepr
            ];
        }

        return new JsonResponse(['data' => $data]);
    }

    /**
     * @Route("/api/rhdb/cve", name="api_rhdb_list_cve")
     * @Method({"GET"})
     */
    public function getCveListAction(Request $request)
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
     * @Route("/api/rhdb/cve/{cve}", name="api_rhdb_one_cve_details",
     * requirements={"cve": "CVE-\d{4}-\d{4}"})
     * @Method({"GET"})
     */
    public function getOneCveDetailsAction(Request $request, $cve)
    {
        $params = array();
        $url = self::BASEURL . "/cve/" . $cve . ".json";

        $jsonrepr = $this->container->get('api_caller')->call(
            new HttpGetJson(
                $url,
                $params
            )
        );

        $data = array();
        if ($jsonrepr !== null) {
            $data = [
            'rhlink' => $url,
            'jsondata' => $jsonrepr
            ];
        }

        return new JsonResponse(['data' => $data]);
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
     * @Route("/api/rhdb/oval/{rhsa}", name="api_rhdb_one_oval_details",
     * requirements={"rhsa": "RHSA-\d{4}:\d{4}"})
     * @Method({"GET"})
     */
    public function getOneOvalDetailsAction(Request $request, $rhsa)
    {
        $params = array();
        $url = self::BASEURL . "/oval/" . $rhsa . ".json";

        $jsonrepr = $this->container->get('api_caller')->call(
            new HttpGetJson(
                $url,
                $params
            )
        );

        $data = array();
        if ($jsonrepr !== null) {
            $data = [
            'rhlink' => $url,
            'jsondata' => $jsonrepr
            ];
        }

        return new JsonResponse(['data' => $data]);
    }

    /**
     * @Route("/api/rheltriage", name="api_rheltriage")
     * @Method({"GET"})
     */
    public function getRhelTriageListAction(Request $request)
    {
        $params = array();

        // $logger = $this->get('logger');

        // $intercept_params = ['rhelversion'];
        // $allparams = $this->extractRhDbQueryParamsArray($request);

        // retrieve all CVRF for the date
        $severity = $request->query->get('severity');
        if ($severity != null) {
            $params['severity'] = $severity;
        }
        $after = $request->query->get('after');
        if ($after != null) {
            $params['after'] = $after;
        }

        switch ($request->query->get('rhelversion')) {
            case 'v7':
                $rpmversion = '.el7_';
                break;
            case 'v6':
                $rpmversion = '.el6_';
                break;
            default:
                return new JsonResponse(['data' => []]);
                break;
        }

        $jsonrepr = $this->container->get('api_caller')->call(
            new HttpGetJson(
                self::URL_CVRF,
                $params
            )
        );
        if ($jsonrepr === null) {
            return new JsonResponse(['data' => []]);
        }

        // build list of all RHSA found out by CSRF criteria
        $allRhsa = array();
        foreach ($jsonrepr as $key => $value) {
            $arr = (array)$value;
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
            if ($jsonrepr !== null) {
                // append result
                // convert object to true array
                $arr = json_decode(json_encode($jsonrepr), true);
                $allRhsaData[$rhsa] = $arr;

                //
                if (isset($arr['cvrfdoc']['triage_tree'])) {
                    foreach ($arr['cvrfdoc']['triage_tree']['branch'] as $key => $prodbranch) {
                        if ($prodbranch['type'] === 'triage Family' && strpos($prodbranch['name'], 'Red Hat Enterprise Linux') !== false) {
                            if (gettype($prodbranch['branch']) === "array") {
                                // $logger->error("YYYYY: ");
                                foreach ($prodbranch['branch'] as $key => $prod) {
                                    if (strpos($prod['full_triage_name'], 'Red Hat Enterprise Linux Server') !== false && strpos($prod['full_triage_name'], '(v. 7)') !== false) {
                                        $filteredRhsaIds[] = $rhsa;
                                        break;
                                    }
                                }
                            } else {
                                // $logger->error("XXXXXX: ");
                                foreach ($prodbranch['branch'] as $key => $prod) {
                                    if (strpos($prod['full_triage_name'], 'Red Hat Enterprise Linux Server') !== false && strpos($prod['full_triage_name'], '(v. 7)') !== false) {
                                        $filteredRhsaIds[] = $rhsa;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        $results = array();
        foreach ($filteredRhsaIds as $key => $rhsa) {
            // $logger->error("Filtered: ", array($rhsa));
            $rhsadata = $allRhsaData[$rhsa];
            $resdata = array();
            $resdata['RHSA'] = $rhsa;
            $resdata['released_on'] = $rhsadata['cvrfdoc']['document_tracking']['current_release_date'];
            $resdata['severity'] = strtolower($rhsadata['cvrfdoc']['aggregate_severity']);
            $resdata['packages'] = array();
            $resdata['triage_state'] = 'ToDo';
            if (isset($rhsadata['cvrfdoc']['triage_tree'])) {
                foreach ($arr['cvrfdoc']['triage_tree']['branch'] as $key => $prodbranch) {
                    if ($prodbranch['type'] === 'triage Version') {
                        // $logger->error("PKGGGGGGGGGGG: ", array ($rpmversion, $prodbranch['name']));

                        if (strpos($prodbranch['name'], $rpmversion) !== false) {
                            // $logger->error("RPMRPMRPMRPM: ");
                            $resdata['released_packages'][] = $prodbranch['name'];
                            // foreach ($prodbranch['branch'] as $key => $prod) {
                            //     if (strpos($prod['full_triage_name'], 'Red Hat Enterprise Linux Server') !== false && strpos($prod['full_triage_name'], '(v. 7)') !== false) {
                            //         $filteredRhsaIds[] = $rhsa;
                            //     }
                            // }
                        }
                    }
                }
            }
            // append to results
            $results[] = $resdata;
        }

        return new JsonResponse(['data' => $results]);
    }

    /**
     * @Route("/api/rheltriage/{cvrf}",
     * requirements={"cvrf": "RH[BES]{1}A-\d{4}:\d{4}"})
     * @Method({"GET"})
     */
    public function getRhelTriageOneAction(Request $request, $cvrf)
    {
        $logger = $this->get('logger');
        $params = array();
        $url = self::BASEURL . "/cvrf/" . $cvrf . ".json";

        $jsonrepr = $this->container->get('api_caller')->call(
            new HttpGetJson(
                $url,
                $params
            )
        );

        $data = array();
        if ($jsonrepr !== null) {
            // convert object to true array
            $arr = json_decode(json_encode($jsonrepr), true);
            $data = [
            'RHSA' => $arr['cvrfdoc']['document_tracking']['identification']['id'],
            'released_on' => $arr['cvrfdoc']['document_tracking']['current_release_date'],
            'severity' => $arr['cvrfdoc']['aggregate_severity'],
            'note' => $arr['cvrfdoc']['document_notes']['note'][0],
            'released_packages' => [],
            'rhel_weblink' => $arr['cvrfdoc']['document_references']['reference'][0]['url'],
            ];
            $logger->error(json_encode($data));
        }

        return new JsonResponse(['data' => $data]);
    }

    /**
     * @Route("/api/rheltriage/{cvrf}",
     * requirements={"cvrf": "RH[BES]{1}A-\d{4}:\d{4}"})
     * @Method({"POST"})
     */
    public function postRhelTriageOneAction(Request $request, $cvrf)
    {
        $logger = $this->get('logger');
// $logger->error($request->request->all());
        $repo = $this->getDoctrine()->getRepository('AppBundle:Triage');
        
        $triage = $repo->findByErrata($cvrf);
        if ($triage === null) {
            $triage = new Triage();
        }
        
        $triage->setErrata('cvrf');
        $triage->setErratadate($request->request->get('erratadate'));
        $triage->setDecision($request->request->get('decision', 'ToDo'));
        $triage->setLastchange(new \DateTime());
        $triage->setUser($request->request->get('user'));
        $triage->setDeployprio($request->request->get('deployprio', 'Low'));
        $triage->setDomain($request->request->get('domain'));
        $triage->setRebootreq($request->request->get('rebootreq', false));
        $triage->setComment($request->request->get('comment'));

        $repo->save($triage);

        $data = array();
        $data['id'] = $triage->getId();

        return new JsonResponse(['data' => $data]);
    }


    private function extractRhDbQueryParamsArray(Request $request)
    {
        $qpstring = $request->getQueryString();
        $qparray = [];
        parse_str($qpstring, $qparray);

        return $qparray;
    }
}
