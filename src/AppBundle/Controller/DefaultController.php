<?php

namespace AppBundle\Controller;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;

class DefaultController extends Controller
{
    /**
     * @Route("/", name="homepage")
     */
    public function indexAction(Request $request)
    {
        return $this->render('default/security.html.twig', [
            'base_dir' => realpath($this->getParameter('kernel.root_dir').'/..').DIRECTORY_SEPARATOR,
            ]);
    }

    /**
     * @Route("/rhelsec/cvrf", name="rhelsec_cvrf")
     */
    public function getCvrfAction(Request $request)
    {
        return $this->render('default/security.html.twig', [
            'base_dir' => realpath($this->getParameter('kernel.root_dir').'/..').DIRECTORY_SEPARATOR,
            ]);
    }

    /**
     * @Route("/rhelsec/cve", name="rhelsec_cve")
     */
    public function getCveAction(Request $request)
    {
        return $this->render('default/security.html.twig', [
            'base_dir' => realpath($this->getParameter('kernel.root_dir').'/..').DIRECTORY_SEPARATOR,
            ]);
    }

        /**
     * @Route("/rhelsec/oval", name="rhelsec_oval")
     */
    public function getOvalAction(Request $request)
    {
        return $this->render('default/security.html.twig', [
            'base_dir' => realpath($this->getParameter('kernel.root_dir').'/..').DIRECTORY_SEPARATOR,
            ]);
    }
}
