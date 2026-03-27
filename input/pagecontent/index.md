
This IG is a project of [1OR Health](https://1orhealth.com/), a company dedicated to improving the efficiency and safety of operating room (OR) coordination through the use of FHIR standards. 

The goal of this IG is to provide a framework for coordinating the various tasks and resources involved in surgical procedures, including scheduling, team coordination, equipment management, and patient care. By leveraging FHIR resources such as ServiceRequest, Task, Appointment, and CareTeam, this IG aims to streamline the OR coordination process, reduce errors, and enhance communication among healthcare providers.

The IG includes a logical model for OR coordination, sequence diagrams illustrating the workflow, and a flowchart depicting the coordination of actors involved in the surgical process. Additionally, the IG provides downloadable artifacts and examples in multiple formats, as well as a cross-version analysis and dependency tables to facilitate implementation.

### Executive Summary

TODO: This section will need to be updated.

1OR is designed as a **cross-system orchestration and verification layer** for surgical readiness.

While existing systems (EHRs, scheduling platforms) represent **scheduled intent**, 1OR is
responsible for establishing **verified operational readiness** across all stakeholders involved in a
surgical case.

**FHIR** represents scheduled intent.

**1OR** represents verified readiness.

This document outlines:

- How 1OR integrates with EHR systems using FHIR
- Where FHIR is leveraged vs. where 1OR extends beyond it
- The internal data model powering readiness verification
- A proposed architecture for alignment with the OR Coordination IG

#### High-Level Architecture

Leverage FHIR for Data Ingestion, and Output (status, signaling, reporting). However, when FHIR is not sufficient then other standards like HL7 v2, or custom APIs can be used. Note that FHIR is only proposed as an interface standard, not as the internal data model.

```mermaid
%%{init: {"flowchart": {"nodeSpacing": 16, "rankSpacing": 20, "padding": 4}, "themeVariables": {"fontSize": "10px"}} }%%
flowchart TD
        EHR["EHR Systems<br/>(Epic, Cerner, Meditech)"]
        INTEG["Integration Layer<br/>(FHIR Adapters / Normalizer)"]

        subgraph CORE["1OR Core Engine"]
            CR[Case Readiness Engine]
            TO[Task Orchestration]
            VE[Verification Engine]
            AE[Attribution Engine]
        end

        VEND["Vendors / Reps<br/>(non-FHIR)"]
        FAC["Facility Staff<br/>(partial FHIR)"]
        SURG["Surgeons / Teams<br/>(non-FHIR)"]

        COMM["Communication Layer<br/>(SMS, Email, App, Magic Links)"]
        OUT["Output / Feedback<br/>(FHIR + Analytics + Alerts)"]

        EHR -->|FHIR APIs| INTEG --> CORE
        CORE --> VEND
        CORE --> FAC
        CORE --> SURG

        VEND --> COMM
        FAC --> COMM
        SURG --> COMM
        COMM --> OUT
```

FHIR Resources that fit well
- Appointment - Case Schedule (time, location)
- Procedure or HealthcareService - Surgical Procedure details
- Patient - Patient identity
- Practitioner, PractitionerRole - Surgical team members
- Location, Organization - Facility and OR details
- Device - Equipment and implants

Potential FHIR Resources:
- Task - Workflow management for pre-op tasks (e.g., pre-op checklist, equipment prep)
- CareTeam - Coordination of the surgical team and their roles
- ServiceRequest - Initial surgical order and intent
- Observation - Tracking the status of various readiness tasks (e.g., pre-op labs, anesthesia clearance)
- Flag - Indicating critical alerts or readiness status (e.g., red/yellow/green status for case readiness)
- CommunicationRequest - Notifications and communication with stakeholders (e.g., patient, surgical team, vendors)
- AuditEvent, Provenance - Tracking actions and changes for accountability and attribution

The need:
- Vendor confirmation or participation
- Readiness verification across stakeholders
- Responsibility ownership
- Real-time coordination
- Delay attribution
- Preventable cancellation logic

FHIR Fit to purpose:

| Function | FHIR | 1OR |
|---|---|---|
| Case representation | Yes | Yes |
| Scheduling | Yes | No |
| Data standardization | Yes | Partial |
| Vendor coordination | Limited | Core |
| Task orchestration | Limited | Core |
| Readiness verification | No | Core |
| Attribution & ROI | No | Core |
{: .grid}

### Logical Model for OR coordination

The logical model for OR coordination includes the following key components:

- [Case](StructureDefinition-Case.html): Represents the overall surgical case, including patient information, procedure details, and scheduling information.
- [Task](StructureDefinition-Task.html): Represents individual tasks that need to be completed as part of the surgical preparation process, such as pre-operative assessments, equipment preparation, and team coordination.
- [Verification](StructureDefinition-Verification.html): Represents the verification of readiness for each task, including the responsible party, status, and any relevant notes or attachments.
- [EventTimeline](StructureDefinition-EventTimeline.html): Represents significant events in the surgical preparation process, such as task completion, delays, or cancellations, along with their timestamps and responsible parties.
- [Attribution](StructureDefinition-Attribution.html): Represents the attribution of responsibility for tasks and events, including the individuals or teams responsible and any relevant details.

### Sequence Diagram for OR coordination

```mermaid
%%{init: {"sequence": {"diagramMarginX": 20, "diagramMarginY": 10, "actorMargin": 20, "width": 110, "height": 45, "boxMargin": 8, "boxTextMargin": 4, "noteMargin": 6, "messageMargin": 10}, "themeVariables": {"fontSize": "10px"}} }%%
sequenceDiagram
    autonumber

    participant Clinician
    participant EHR as EHR / Ordering System
    participant FHIR as FHIR Server
    participant Scheduler as OR Scheduler

    %% --- Order Creation ---
    Clinician->>EHR: Create surgical order\n(Procedure intent)
    EHR->>FHIR: POST ServiceRequest\n(status=draft | active)
    FHIR-->>EHR: 201 Created (ServiceRequest)

    %% --- Optional Workflow Task ---
    EHR->>FHIR: POST Task\n(code=surgery-scheduling,\nfocus=ServiceRequest)
    FHIR-->>EHR: 201 Created (Task)

    %% --- Scheduling Interaction ---
    Scheduler->>EHR: Review surgical order
    Scheduler->>EHR: Select OR, team, date/time
    EHR->>FHIR: POST Appointment\n(participants: patient, surgeon,\nlocation=OR suite,\nbasedOn=ServiceRequest)
    FHIR-->>EHR: 201 Created (Appointment)

    %% --- Update Workflow Task ---
    EHR->>FHIR: PATCH Task\n(status=completed)
    FHIR-->>EHR: 200 OK

    %% --- Notification ---
    EHR-->>Clinician: Surgery scheduled\n(Appointment details)
    EHR-->>Scheduler: Confirmation sent
```

### Coordination of Actors

```mermaid
%%{init: {"flowchart": {"nodeSpacing": 14, "rankSpacing": 18, "padding": 4}, "themeVariables": {"fontSize": "10px"}} }%%
flowchart LR

    %% --- People / Roles ---
    Patient([Patient])
    Caregiver([Caregiver / Family])
    PCP([Primary Care Provider])
    Specialist([Specialist / Surgeon])
    Nurse([Nurse / Care Coordinator])
    SocialWorker([Social Worker])
    CaseManager([Case Manager])
    Scheduler([Scheduler / OR Scheduler])
    AdminStaff([Administrative Staff])
    BillingStaff([Billing / Financial Counselor])

    %% --- Systems ---
    EHR([EHR / Clinical System])
    FHIRServer([FHIR Server])
    TaskEngine([Workflow / Task Engine])
    SchedulingSystem([Scheduling / OR Management System])
    Messaging([Secure Messaging / Patient Portal])
    PayerSystem([Payer / Authorization System])
    Registry([Public Health / Specialty Registry])
    DocMgmt([Document Management / HIE])

    %% --- Relationships ---
    Patient <--> PCP
    Patient <--> Caregiver
    PCP --> Specialist
    PCP --> Nurse
    Nurse --> CaseManager
    CaseManager --> SocialWorker
    Scheduler --> Specialist

    PCP --> EHR
    Specialist --> EHR
    Nurse --> EHR
    Scheduler --> SchedulingSystem
    SchedulingSystem --> FHIRServer
    EHR --> FHIRServer
    TaskEngine --> FHIRServer
    Messaging --> Patient
    Messaging --> Caregiver
    EHR --> PayerSystem
    EHR --> Registry
    EHR --> DocMgmt

    %% --- Color Coding ---
    %% People = light yellow
    style Patient fill:#fff7c2,stroke:#b59b00
    style Caregiver fill:#fff7c2,stroke:#b59b00
    style PCP fill:#fff7c2,stroke:#b59b00
    style Specialist fill:#fff7c2,stroke:#b59b00
    style Nurse fill:#fff7c2,stroke:#b59b00
    style SocialWorker fill:#fff7c2,stroke:#b59b00
    style CaseManager fill:#fff7c2,stroke:#b59b00
    style Scheduler fill:#fff7c2,stroke:#b59b00
    style AdminStaff fill:#fff7c2,stroke:#b59b00
    style BillingStaff fill:#fff7c2,stroke:#b59b00

    %% Systems = light blue
    style EHR fill:#d9eaff,stroke:#005
```
