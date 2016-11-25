<?php

namespace AppBundle\Entity\;

use Doctrine\ORM\Mapping as ORM;

/**
 * Triage
 *
 * @ORM\Table(name="triage")
 * @ORM\Entity(repositoryClass="AppBundle\Repository\\TriageRepository")
 */
class Triage
{
    /**
     * @var int
     *
     * @ORM\Column(name="id", type="integer")
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    private $id;

    /**
     * @var string
     *
     * @ORM\Column(name="errata", type="string", length=20, unique=true)
     */
    private $errata;

    /**
     * @var string
     *
     * @ORM\Column(name="status", type="string", length=20)
     */
    private $status;

    /**
     * @var \DateTime
     *
     * @ORM\Column(name="lastchange", type="datetimetz")
     */
    private $lastchange;

    /**
     * @var string
     *
     * @ORM\Column(name="user", type="string", length=40, nullable=true)
     */
    private $user;

    /**
     * @var string
     *
     * @ORM\Column(name="deployprio", type="string", length=10)
     */
    private $deployprio;

    /**
     * @var string
     *
     * @ORM\Column(name="domain", type="string", length=40, nullable=true)
     */
    private $domain;

    /**
     * @var bool
     *
     * @ORM\Column(name="rebootreq", type="boolean")
     */
    private $rebootreq;

    /**
     * @var string
     *
     * @ORM\Column(name="comment", type="string", length=255, nullable=true)
     */
    private $comment;


    /**
     * Get id
     *
     * @return int
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * Set errata
     *
     * @param string $errata
     *
     * @return Triage
     */
    public function setErrata($errata)
    {
        $this->errata = $errata;

        return $this;
    }

    /**
     * Get errata
     *
     * @return string
     */
    public function getErrata()
    {
        return $this->errata;
    }

    /**
     * Set status
     *
     * @param string $status
     *
     * @return Triage
     */
    public function setStatus($status)
    {
        $this->status = $status;

        return $this;
    }

    /**
     * Get status
     *
     * @return string
     */
    public function getStatus()
    {
        return $this->status;
    }

    /**
     * Set lastchange
     *
     * @param \DateTime $lastchange
     *
     * @return Triage
     */
    public function setLastchange($lastchange)
    {
        $this->lastchange = $lastchange;

        return $this;
    }

    /**
     * Get lastchange
     *
     * @return \DateTime
     */
    public function getLastchange()
    {
        return $this->lastchange;
    }

    /**
     * Set user
     *
     * @param string $user
     *
     * @return Triage
     */
    public function setUser($user)
    {
        $this->user = $user;

        return $this;
    }

    /**
     * Get user
     *
     * @return string
     */
    public function getUser()
    {
        return $this->user;
    }

    /**
     * Set deployprio
     *
     * @param string $deployprio
     *
     * @return Triage
     */
    public function setDeployprio($deployprio)
    {
        $this->deployprio = $deployprio;

        return $this;
    }

    /**
     * Get deployprio
     *
     * @return string
     */
    public function getDeployprio()
    {
        return $this->deployprio;
    }

    /**
     * Set domain
     *
     * @param string $domain
     *
     * @return Triage
     */
    public function setDomain($domain)
    {
        $this->domain = $domain;

        return $this;
    }

    /**
     * Get domain
     *
     * @return string
     */
    public function getDomain()
    {
        return $this->domain;
    }

    /**
     * Set rebootreq
     *
     * @param boolean $rebootreq
     *
     * @return Triage
     */
    public function setRebootreq($rebootreq)
    {
        $this->rebootreq = $rebootreq;

        return $this;
    }

    /**
     * Get rebootreq
     *
     * @return bool
     */
    public function getRebootreq()
    {
        return $this->rebootreq;
    }

    /**
     * Set comment
     *
     * @param string $comment
     *
     * @return Triage
     */
    public function setComment($comment)
    {
        $this->comment = $comment;

        return $this;
    }

    /**
     * Get comment
     *
     * @return string
     */
    public function getComment()
    {
        return $this->comment;
    }
}

