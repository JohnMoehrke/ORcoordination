
The Surgical coordination

```mermaid
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

Coordination of Actors

```mermaid
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

### Source

The source code for this Implementation Guide can be found on [GitHub](https://github.com/JohnMoehrke/ORcoordination).

#### Cross Version Analysis

{% include cross-version-analysis.xhtml %}

#### Dependency Table

{% include dependency-table.xhtml %}

#### Globals Table

{% include globals-table.xhtml %}

#### IP Statements

{% include ip-statements.xhtml %}
