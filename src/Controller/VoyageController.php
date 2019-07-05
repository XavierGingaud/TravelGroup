<?php

namespace App\Controller;

use App\Entity\Voyage;
use App\Form\VoyageType;
use App\Repository\VoyageRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

/**
 * @Route("/voyage")
 */
class VoyageController extends AbstractController
{
    /**
     * @Route("/", name="voyage_index", methods={"GET"})
     */
    public function index(VoyageRepository $voyageRepository): Response
    {
        return $this->render('voyage/index.html.twig', [
            'voyages' => $voyageRepository->findAll(),
        ]);
    }

    /**
     * @Route("/new", name="voyage_new", methods={"GET","POST"})
     */
    public function new(Request $request): Response
    {
        if($this->getUser()){
            $voyage = new Voyage();
            $form = $this->createForm(VoyageType::class, $voyage);
            $form->handleRequest($request);

            if ($form->isSubmitted() && $form->isValid()) {
                $voyage->setPlanner($this->getUser());
                $voyage->addParticipant($this->getUser());
                $entityManager = $this->getDoctrine()->getManager();
                $entityManager->persist($voyage);
                $entityManager->flush();

                return $this->redirectToRoute('voyage_index');
            }

            $current_year = getdate()['year'];
            for ($i=0; $i < 4; $i++) { 
                $allowed_years[] = $current_year+$i;
            }

            return $this->render('voyage/new.html.twig', [
                'voyage' => $voyage,
                'years' => $allowed_years,
                'form' => $form->createView(),
            ]);
        }else{
            return $this->redirectToRoute('fos_user_security_login');
        }
    }

    /**
     * @Route("/{id}", name="voyage_show", methods={"GET"})
     */
    public function show(Voyage $voyage): Response
    {
        if($this->getUser() !== null){
            if ($voyage->getPlanner() == $this->getUser() || $this->getUser()->hasRole('ROLE_SUPER_ADMIN')){
                return $this->render('voyage/show.html.twig', [
                    'voyage' => $voyage,
                    'nbr_participants' => count($voyage->getParticipants()),
                    'canEdit' => true,
                ]);
            }else{
                return $this->render('voyage/show.html.twig', [
                    'voyage' => $voyage,
                    'join' => true,
                    'nbr_participants' => count($voyage->getParticipants()),
                ]);
            }
        }else{
            return $this->render('voyage/show.html.twig', [
                'voyage' => $voyage,
                'nbr_participants' => count($voyage->getParticipants()),
            ]);
        }
    }

    /**
     * @Route("/{id}/edit", name="voyage_edit", methods={"GET","POST"})
     */
    public function edit(Request $request, Voyage $voyage): Response
    {
        $form = $this->createForm(VoyageType::class, $voyage);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $this->getDoctrine()->getManager()->flush();

            return $this->redirectToRoute('voyage_index', [
                'id' => $voyage->getId(),
            ]);
        }

        $current_year = getdate()['year'];
        for ($i=0; $i < 4; $i++) { 
            $allowed_years[] = $current_year+$i;
        }

        return $this->render('voyage/edit.html.twig', [
            'voyage' => $voyage,
            'years' => $allowed_years,
            'form' => $form->createView(),
        ]);
    }

    /**
     * @Route("/{id}", name="voyage_delete", methods={"DELETE"})
     */
    public function delete(Request $request, Voyage $voyage): Response
    {
        if ($this->isCsrfTokenValid('delete'.$voyage->getId(), $request->request->get('_token'))) {
            $entityManager = $this->getDoctrine()->getManager();
            $entityManager->remove($voyage);
            $entityManager->flush();
        }

        return $this->redirectToRoute('voyage_index');
    }

    // /**
    //  * @Route("/{id}/join", name="voyage_join", methods={"GET", "POST"})
    //  */
    // public function join(Voyage $voyage)
    // {
    //     if($this->getUser() !== null){
    //         $participants = $voyage->getParticipants();
    //         foreach ($participants as $value) {
    //             if($value == $this->getUser()){
    //                 $canJoin = false;
    //                 break;
    //             }else{
    //                 $canJoin = true;
    //             }
    //         }
    //         if ($canJoin){
    //             $voyage->addParticipant($this->getUser());
    //         }
    //     }
    //     return $this->show($voyage);
    // }
}
