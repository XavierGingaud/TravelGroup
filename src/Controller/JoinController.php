<?php

namespace App\Controller;

use App\Entity\Voyage;
use App\Repository\VoyageRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\HttpFoundation\Response;

class JoinController extends AbstractController
{
    /**
     * @Route("/join/{id}", name="join")
     */
    public function index(VoyageRepository $voyageRepository, Voyage $voyage) : Response
    {

    	if($voyageRepository->findOneById($voyage->getId())){
    		
    		$user = $this->getUser();

			if($voyage->addParticipant($user)){
				$happened = true;
			}else{
				$happened = false;
			}

    		// return $this->render('join/index.html.twig', [
      //       	'voyage' => $happened,
      //       	'user' => $user,
      //   	]);

        	return $this->redirecttoRoute('voyage_show', ['id' => $voyage->getId()]);

    		

    	}else{

	        return $this->render('join/index.html.twig', [
	            'error' => "Ce voyage n'existe pas ou plus",
	        ]);
	    }
    }
}
