

Logical: Case
Id: Case
Title: "Case Logical Model"
Description: """
A conceptual model representing a case or episode of care. Captures the clinical and administrative details of a case without prescribing a specific workflow or FHIR resource.
"""

* caseId 1..1 Identifier "Unique identifier for the case"

* externalIds 0..* BackboneElement "External identifiers from connected systems"
* externalIds.ehrAppointmentId 0..1 Identifier "Appointment identifier from the EHR"
* externalIds.ehrProcedureId 0..1 Identifier "Procedure/order identifier from the EHR"

* patientId 1..1 Identifier "Identifier for the patient"
* surgeonId 0..* Identifier "Identifier for the primary surgeon"
* facilityId 0..1 Identifier "Identifier for the facility"
* scheduledTime 0..1 dateTime "Scheduled date/time for the case"

* status 1..1 BackboneElement "Case readiness status details"
* status.readinessStatus 1..1 code "Readiness state: NOT_READY | AT_RISK | READY | VERIFIED"
* status.readinessScore 0..1 decimal "Numeric readiness score"

* vendorAssignment 0..* BackboneElement "Assigned vendor and representative for the case"
* vendorAssignment.vendorId 0..1 Identifier "Identifier for the assigned vendor"
* vendorAssignment.repId 0..1 Identifier "Identifier for the assigned representative"
* vendorAssignment.confirmed 0..1 boolean "Whether assignment has been confirmed"
* vendorAssignment.confirmationTimestamp 0..1 dateTime "When assignment confirmation occurred"


Logical: Task
Id: Task
Title: "Task Logical Model"
Description: """
A conceptual model representing a task or activity that needs to be performed as part of care coordination. Captures the details of the task without prescribing a specific workflow or FHIR resource.
"""

* taskId 1..1 Identifier "Unique identifier for the task"
* caseId 1..1 Identifier "Identifier of the case this task belongs to"

* type 1..1 code "Task type: VENDOR_CONFIRMATION | IMPLANT_AVAILABILITY | CONSENT_COMPLETE | CLEARANCE_COMPLETE"

* assignedTo 1..1 BackboneElement "Entity assigned to complete the task"
* assignedTo.entityType 1..1 code "Assigned entity type: VENDOR | FACILITY | SURGEON"
* assignedTo.entityId 1..1 Identifier "Identifier of the assigned entity"

* dueTime 0..1 dateTime "Date/time by which the task should be completed"
* status 1..1 code "Task status: PENDING | COMPLETED | FAILED"

* completion 0..1 BackboneElement "Completion details for the task"
* completion.timestamp 0..1 dateTime "When the task was completed"
* completion.method 0..1 code "Completion method: SYSTEM | USER | API | MESSAGE_LINK"


Logical: Verification
Id: Verification
Title: "Verification Logical Model"
Description: """
A conceptual model representing a verification event tied to a case and task. Captures who verified, how verification was performed, timing, and confidence.

Key Concept: 
Verification transforms assumed completion into confirmed truth. 
"""

* verificationId 1..1 Identifier "Unique identifier for the verification event"
* caseId 1..1 Identifier "Identifier of the related case"
* taskId 1..1 Identifier "Identifier of the related task"

* verifiedBy 1..1 BackboneElement "Entity that performed the verification"
* verifiedBy.entityType 1..1 code "Type of verifying entity"
* verifiedBy.entityId 1..1 Identifier "Identifier of the verifying entity"

* verificationMethod 1..1 code "Verification method: MANUAL_CONFIRMATION | SYSTEM_SYNC | MESSAGE_RESPONSE | AUTO_MATCH"

* timestamp 1..1 dateTime "When the verification occurred"
* confidenceScore 0..1 decimal "Confidence score associated with the verification"


Logical: EventTimeline
Id: EventTimeline
Title: "EventTimeline (Audit Layer) Logical Model"
Description: """
A conceptual model representing timeline events associated with a case. Captures event type, actor, timing, and additional context metadata.
"""

* eventId 1..1 Identifier "Unique identifier for the event"
* caseId 1..1 Identifier "Identifier of the related case"

* type 1..1 code "Event type: TASK_CREATED | TASK_COMPLETED | VENDOR_CONFIRMED | CASE_FLAGGED | DELAY_OCCURRED"

* actor 0..1 Identifier "Identifier of the actor responsible for or associated with the event"
* timestamp 1..1 dateTime "When the event occurred"
* metadata 0..1 string "Additional event context as serialized metadata"


Logical: Attribution
Id: Attribution
Title: "Attribution (Economic Layer) Logical Model"
Description: """
A conceptual model representing delay and cancellation attribution for a case, including cause classification and preventability.

Aligned with pilot metrics and operational tracking: 
- Delay minutes 
- Cancellation rates 
- Vendor-related workflow failures

This directly supports: 
- OR efficiency analysis 
- Revenue recovery modeling 
- ROI measurement during pilots
"""

* caseId 1..1 Identifier "Identifier of the related case"

* delayMinutes 0..1 integer "Total delay in minutes"
* delayCause 0..1 code "Delay cause: VENDOR | FACILITY | SURGEON | UNKNOWN"

* cancellation 0..1 BackboneElement "Cancellation details for the case"
* cancellation.occurred 1..1 boolean "Whether cancellation occurred"
* cancellation.cause 0..1 string "Cause of cancellation"

* preventable 0..1 boolean "Whether the delay or cancellation was preventable"

