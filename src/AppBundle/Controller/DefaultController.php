<?php

namespace AppBundle\Controller;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;


class DefaultController extends Controller
{
    const BASEURL = 'https://access.redhat.com/labs/securitydataapi';

    /**
     * @Route("/", name="homepage")
     */
    public function indexAction(Request $request)
    {
        return $this->render('default/rhsearch.html.twig', [
            'base_dir' => realpath($this->getParameter('kernel.root_dir').'/..').DIRECTORY_SEPARATOR,
            ]);
    }

    /**
     * @Route("/rhdb/cvrfdetails/{rhsa}", name="rhel_cvrh_details_page",
     *  requirements={"rhsa": "RH[BES]A-\d{4}:\d{4}"}))
     */
    public function getCvrfDetailsAction(Request $request, $rhsa)
    {
        // eg. RHSA-2016:2659
        return $this->render('default/rhcvrfdetails.html.twig', [
            'base_dir' => realpath($this->getParameter('kernel.root_dir').'/..').DIRECTORY_SEPARATOR,
                'rhsa' => $rhsa
            ]);
    }

    /**
     * @Route("/rhdb/erratadetails/cvrf/{rhsa}", name="rhdb_errata_cvrf_details_page",
     *  requirements={"rhsa": "RH[BES]A-\d{4}:\d{4}"}))
     */
    public function getErrataCvrfDetailsAction(Request $request, $rhsa)
    {
        // eg. RHSA-2016:2659
        return $this->render('default/rherratadetails.html.twig', [
            'base_dir' => realpath($this->getParameter('kernel.root_dir').'/..').DIRECTORY_SEPARATOR,
            'errata' => $rhsa,
            'type' => 'CVRF'
            ]);
    }

    /**
     * @Route("/rhdb/erratadetails/cve/{cve}", name="rhdb_errata_cve_details_page",
     *  requirements={"cve": "CVE-\d{4}-\d{4}"}))
     */
    public function getErrataCveDetailsAction(Request $request, $cve)
    {
        // eg. CVE-2016-7865
        return $this->render('default/rherratadetails.html.twig', [
            'base_dir' => realpath($this->getParameter('kernel.root_dir').'/..').DIRECTORY_SEPARATOR,
            'errata' => $cve,
            'type' => 'CVE'
            ]);
    }

    /**
     * @Route("/rhdb/erratadetails/oval/{rhsa}", name="rhdb_errata_oval_details_page",
     *  requirements={"rhsa": "RH[BES]A-\d{4}:\d{4}"}))
     */
    public function getErrataOvalDetailsAction(Request $request, $rhsa)
    {
        // eg. RHSA-2016:2659
        return $this->render('default/rherratadetails.html.twig', [
            'base_dir' => realpath($this->getParameter('kernel.root_dir').'/..').DIRECTORY_SEPARATOR,
            'errata' => $rhsa,
            'type' => 'OVAL'
            ]);
    }

    /**
     * @Route("/rheltriage", name="rhel_triage_page")
     */
    public function rhelTriageAction(Request $request)
    {
        return $this->render('default/rheltriage.html.twig', [
            'base_dir' => realpath($this->getParameter('kernel.root_dir').'/..').DIRECTORY_SEPARATOR,
            ]);
    }
}
