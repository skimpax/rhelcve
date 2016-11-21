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
     * @Route("/rheltriage", name="rhel_triage_page")
     */
    public function rhelTriageAction(Request $request)
    {
        return $this->render('default/rheltriage.html.twig', [
            'base_dir' => realpath($this->getParameter('kernel.root_dir').'/..').DIRECTORY_SEPARATOR,
            ]);
    }
}
