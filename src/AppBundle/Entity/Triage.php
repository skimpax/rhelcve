<?php

namespace AppBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * Triage
 *
 * @ORM\Table(name="triage")
 * @ORM\Entity(repositoryClass="AppBundle\Repository\TriageRepository")
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
     * @var \DateTime
     *
     * @ORM\Column(name="erratadate", type="datetime")
     */
    private $erratadate;

    /**
     * @var string
     *
     * @ORM\Column(name="decision", type="string", length=20)
     */
    private $decision;

    /**
     * @var \DateTime
     *
     * @ORM\Column(name="lastchange", type="datetime")
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
     * Set decision
     *
     * @param string $decision
     *
     * @return Triage
     */
    public function setDecision($decision)
    {
        $this->decision = $decision;

        return $this;
    }

    /**
     * Get decision
     *
     * @return string
     */
    public function getDecision()
    {
        return $this->decision;
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
        $this->lastchange = new \DateTime($lastchange->format('Y-m-d H:i:s'));
        // force save to UTC
        $this->lastchange->setTimezone(new \DateTimeZone('UTC'));

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

    /**
     * Set erratadate
     *
     * @param \DateTime $erratadate
     *
     * @return Triage
     */
    public function setErratadate($erratadate)
    {
        $this->erratadate = $erratadate;

        return $this;
    }

    /**
     * Get erratadate
     *
     * @return \DateTime
     */
    public function getErratadate()
    {
        return $this->erratadate;
    }
}
