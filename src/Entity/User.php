<?php

namespace App\Entity;

use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use FOS\UserBundle\Model\User as BaseUser;
use Doctrine\ORM\Mapping as ORM;

/**
 * @ORM\Entity
 * @ORM\Table(name="fos_user")
 */
class User extends BaseUser
{
    /**
     * @ORM\Id
     * @ORM\Column(type="integer")
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    protected $id;

    /**
     * @ORM\ManyToMany(targetEntity="App\Entity\Voyage", mappedBy="participants")
     */
    private $voyages;

    /**
     * @ORM\OneToMany(targetEntity="App\Entity\Voyage", mappedBy="planner", orphanRemoval=true)
     */
    private $myVoyages;

    public function __construct()
    {
        parent::__construct();
        $this->voyages = new ArrayCollection();
        $this->myVoyages = new ArrayCollection();
        // your own logic
    }

    /**
     * @return Collection|Voyage[]
     */
    public function getVoyages(): Collection
    {
        return $this->voyages;
    }

    public function addVoyage(Voyage $voyage): self
    {
        if (!$this->voyages->contains($voyage)) {
            $this->voyages[] = $voyage;
            $voyage->addParticipant($this);
        }

        return $this;
    }

    public function removeVoyage(Voyage $voyage): self
    {
        if ($this->voyages->contains($voyage)) {
            $this->voyages->removeElement($voyage);
            $voyage->removeParticipant($this);
        }

        return $this;
    }

    /**
     * @return Collection|Voyage[]
     */
    public function getMyVoyages(): Collection
    {
        return $this->myVoyages;
    }

    public function addMyVoyage(Voyage $myVoyage): self
    {
        if (!$this->myVoyages->contains($myVoyage)) {
            $this->myVoyages[] = $myVoyage;
            $myVoyage->setPlanner($this);
        }

        return $this;
    }

    public function removeMyVoyage(Voyage $myVoyage): self
    {
        if ($this->myVoyages->contains($myVoyage)) {
            $this->myVoyages->removeElement($myVoyage);
            // set the owning side to null (unless already changed)
            if ($myVoyage->getPlanner() === $this) {
                $myVoyage->setPlanner(null);
            }
        }

        return $this;
    }
}