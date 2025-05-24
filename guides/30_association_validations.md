# Association Validations

Association patterns enable us to implement Business Rules. Business rules from the problem domain
are translated to Association Validations in your record modules in the solution domain.

Five categories of validations:

- **Type**: validate right type
- **Multiplicity**: validate too many/too few associations
- **Field**: validate correct values
- **State**: validate correct state
- **Conflict**: validate compatibility

Validations are shared between players:

|                       | Type | Multiplicity | Fields   | State | Conflict |
| --------------------- | ---- | ------------ | -------- | ----- | -------- |
| Actor                 |      |              |          |       |          |
| Role                  | x    | x            | x        | x     | x        |
|                       |      |              |          |       |          |
| Outer Place           |      | x            | x        | x     |          |
| Place                 | x    | x            | x        | x     | x        |
|                       |      |              |          |       |          |
| Item                  |      | x            |          | x     |          |
| Item Specific         | x    | x            | x        | x     | x        |
|                       |      |              |          |       |          |
| Assembly              |      | x            | x        | x     |          |
| Part                  | x    | x            | x        | x     | x        |
|                       |      |              |          |       |          |
| Container             |      | x            | x        | x     |          |
| Content               | x    | x            | x        | x     | x        |
|                       |      |              |          |       |          |
| Group                 |      | x            | x        | x     | x        |
| Member                | x    | x            | x        | x     | x        |
|                       |      |              |          |       |          |
| Role                  | x    | x            | x        | x     | x        |
| Transaction           |      | x            |          |       |          |
|                       |      |              |          |       |          |
| Place                 | x    | x            | x        | x     | x        |
| Transaction           |      | x            |          |       |          |
|                       |      |              |          |       |          |
| Specific Item         | x    | x            | x        | x     | x        |
| Transaction           |      | x            |          |       |          |
|                       |      |              |          |       |          |
| Composite Transaction |      | x            |          |       |          |
| Specific Item         | x    | x            |          |       |          |
|                       |      |              |          |       |          |
| Transaction           | x    | x            | x        | x     | x        |
| Follow-up Transaction |      | x            |          |       |          |
