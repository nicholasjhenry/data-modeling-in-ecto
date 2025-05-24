# Association Patterns

Associations between two records form 12 patterns:

(Player 1 - Player 2)

Entity associations:

- have two records to model individual people (organizations), places, articles, and aggregations of these
- have two of the same record category; e.g. two people for the Actor - Role association

1. Actor - Role
2. OuterPlace - Place
3. Item - SpecificItem
4. Assembly - Part
5. Container - Content
6. Group - Member

Event associations:

7. Role - Transaction
8. Place - Transaction
9. SpecificItem - Transaction

Aggregate Event associations:

- associate multiple people, place, or article records
- record the interaction association separately for each

10. CompositeTransaction - LineItem
11. SpecificItem - LineItem
12. Transaction - FollowupTransaction
