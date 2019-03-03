(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )

   (:action moveRobot
      :parameters (?r - robot ?la - location ?lb - location)
      :precondition (and (at ?r ?la) (connected ?la ?lb) (available ?lb) (no-robot ?lb))
      :effect (and (available ?la) (not (available ?lb)) (no-robot ?la) (not (no-robot ?lb)) (at ?r ?lb) (not (at ?r ?la)))
   )

   (:action moveRobotWithPallette
      :parameters (?r - robot ?p - pallette ?la - location ?lb - location)
      :precondition (and (connected ?la ?lb) (available ?lb) (no-robot ?lb) (at ?r ?la) (at ?p ?la) (no-pallette ?lb))
      :effect (and (no-robot ?la) (not (no-robot ?lb)) (no-pallette ?la) (not (no-pallette ?lb)) (available ?la) (not (available ?lb)) (not (at ?r ?la)) (not (at ?p ?la)) (at ?r ?lb) (at ?p ?lb))
   )

   (:action moveItemFromPalletteToShipment
      :parameters (?l - location ?s - shipment ?i - saleitem ?p - pallette ?o - order)
      :precondition (and (started ?s) (not (complete ?s)) (not (includes ?s ?i)) (contains ?p ?i) (packing-location ?l) (packing-at ?s ?l))
      :effect (and (not (contains ?p ?i)) (includes ?s ?i))
   )
)
