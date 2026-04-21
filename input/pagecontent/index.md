
This IG is a project of [1OR Health](https://1orhealth.com/), a company dedicated to improving the efficiency and safety of operating room (OR) coordination through the use of FHIR standards. 

The goal of this IG is to provide a framework for coordinating the various tasks and resources involved in surgical procedures, including scheduling, team coordination, equipment management, and patient care. By leveraging FHIR resources such as ServiceRequest, Task, Appointment, and CareTeam, this IG aims to streamline the OR coordination process, reduce errors, and enhance communication among healthcare providers.

The IG includes a logical model for OR coordination, sequence diagrams illustrating the workflow, and a flowchart depicting the coordination of actors involved in the surgical process. Additionally, the IG provides downloadable artifacts and examples in multiple formats, as well as a cross-version analysis and dependency tables to facilitate implementation.

### Executive Summary

TODO: This section will need to be updated.

1OR is designed as a **cross-system orchestration and verification layer** for surgical readiness.

<div>
<img src="1OR_Workflow.jpg" caption="1OR Workflow Diagram" width="100%"/>
</div>
<br/>

While existing systems (EHRs, scheduling platforms) represent **scheduled intent**, 1OR is
responsible for establishing **verified operational readiness** across all stakeholders involved in a
surgical case.

This document outlines:

- How 1OR integrates with EHR systems using FHIR
- Where FHIR is leveraged vs. where 1OR extends beyond it
- The internal data model powering readiness verification
- A proposed architecture for alignment with the OR Coordination IG

There are two parts:

- Part 1 is an [abstracted Logical Model](logical.html).
- Part 2 is a detailed [FHIR implementation approach](fhir.html).
