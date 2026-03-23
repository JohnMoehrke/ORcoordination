/*
 Logical Model for OR coordination. 
The control resource is a logical model that coordinates the execution of two or more tasks.
This is created upon first order for an OR event. -- ServiceRequest
The control resource includes the identifier of that request, the identifier of the patient, the code for the procedure (Procedure).
Coordinating the OR room reservation, the surgical team, the anesthesia team, the necessary equipment and supplies, and any other resources needed for the procedure.
Linkage to Encounter or EpisodeOfCare to track overall care coordination.
Creation of CareTeam to coordinate the whole surgical team.
The control resource has a set of repeating elements for each of the tasks that need to be coordinated. Who/What is needed, when is it needed, what is the status of that task (not started, in progress, completed, etc).
The control resource also has a field for the overall status of the coordination (not started, in progress, completed, etc).
*/
Logical: Coordination
Id: Coordination
Title: "Coordination Logical Model"
Description: """
A conceptual model representing coordination activities across care teams,
organizations, and systems. Captures the who/what/when/why of coordination
without prescribing a specific workflow or FHIR resource.
"""

* identifier 0..* Identifier "Identifiers for this coordination instance"
* status 1..1 code "The current state of the coordination activity (e.g., draft, active, completed)"
* category 0..* CodeableConcept "Type of coordination (care coordination, service coordination, scheduling, transition of care)"
* focus 0..1 Reference "The primary clinical focus (Condition, ServiceRequest, EpisodeOfCare, etc.)"
* subject 1..1 Reference "The patient or entity for whom coordination is being performed"
* reason 0..* CodeableConcept "Why coordination is needed"
* description 0..1 string "Narrative description of the coordination activity"

* coordinator 0..1 Reference "Primary coordinator (Practitioner, PractitionerRole, Organization)"
* participants 0..* Reference "Other participants involved in coordination"

* period 0..1 Period "Time period during which coordination is active"
* created 0..1 dateTime "When this coordination record was created"
* lastUpdated 0..1 dateTime "When this coordination record was last updated"

* relatedTask 0..* Reference "Associated workflow Tasks"
* relatedRequest 0..* Reference "Associated ServiceRequests or other requests"
* relatedEncounter 0..* Reference "Associated Encounters (e.g., care transitions)"

* communication 0..* BackboneElement "Communication events related to coordination"
* communication.type 0..1 CodeableConcept "Type of communication (call, message, meeting)"
* communication.date 0..1 dateTime "When the communication occurred"
* communication.participant 0..* Reference "Participants in the communication"
* communication.note 0..1 string "Summary of the communication"

* note 0..* Annotation "Additional notes about the coordination activity"
