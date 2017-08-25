<?php

namespace AppBundle\Controller;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Method;
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
        return $this->redirectToRoute('gui_rhdb_search_page', array(), 301);
    }

    /**
     * @Route("/gui/rhdbsearch", name="gui_rhdb_search_page")
     */
    public function getRhDbSearch(Request $request)
    {
        return $this->render('default/rhsearch.html.twig', [
            'base_dir' => realpath($this->getParameter('kernel.root_dir').'/..').DIRECTORY_SEPARATOR,
            ]);
    }

    /**
     * @Route("/gui/cvrfdetails/{rhsa}", name="gui_cvrf_details_page",
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
     * @Route("/gui/erratadetails/cvrf/{rhsa}", name="gui_errata_cvrf_details_page",
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
     * @Route("/gui/erratadetails/cve/{cve}", name="gui_errata_cve_details_page",
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
     * @Route("/gui/erratadetails/oval/{rhsa}", name="gui_errata_oval_details_page",
     *  requirements={"rhsa": "RH[BES]A-\d{4}:\d{4}"}))
     * @Method({"GET"})
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
     * @Route("/gui/rheltriage", name="gui_triage_list_page")
     * @Method({"GET"})
     */
    public function rhelTriageListAction(Request $request)
    {
        return $this->render('default/rheltriage.html.twig', [
            'base_dir' => realpath($this->getParameter('kernel.root_dir').'/..').DIRECTORY_SEPARATOR,
            ]);
    }

    /**
     * @Route("/gui/rheltriage/{cvrf}", name="gui_triage_one_cfrf_page",
     * requirements={"cvrf": "RH[BES]{1}A-\d{4}:\d{4}"})
     * @Method({"GET"})
     */
    public function rhelTriageOneAction(Request $request, $cvrf)
    {
        return $this->render('default/rheltriageit.html.twig', [
            'base_dir' => realpath($this->getParameter('kernel.root_dir').'/..').DIRECTORY_SEPARATOR,
            'cvrf' => $cvrf
            ]);
    }

    /**
     * @Route("/gui/issues", name="gui_issue_list_page")
     * @Method({"GET"})
     */
    public function rhelIssueIdListAction(Request $request)
    {
        return $this->render('default/rhissue.html.twig', [
            'base_dir' => realpath($this->getParameter('kernel.root_dir').'/..').DIRECTORY_SEPARATOR,
            ]);
    }
}
