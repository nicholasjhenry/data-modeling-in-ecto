# Implementing Business Rules

**79. Where rules come from**

Business rules come from clients; logic rules come from good programming practices.

## Implementing Property Business Rules

**80. Isolate property rules**

When a property has domain-specific limits on its values, define a separate method to enforce these limits, and call this test method from within the set property accessor.

**81. Isolate value assignment**

Define a separate method to assign a value into the property and bypass business rule when necessary. The set property accessor calls this method after checking the business rule.

**82. Descriptive and time property business rules**

Descriptive and time properties are governed by business rules that define when the values can change and what ranges of values are possible.

**83. Enumerated property business rules**

Properties with enumerated types are governed by business rules that define the set of legal values and the legal transitions from one value to another.

## Implementing Collaboration Rules

**84. Dual Rule Checking**

To achieve pluggability, extensibility, and scalability, each object must check its own collaboration rules.

**85. Commutative Rule Checking**

Implement collaboration rules so that either collaborator can request to be checked.

**87. Isolate Collaboration Assignment**

Define separate methods to assign and remove a reference to a collaborator and to bypass business rule checking when necessary. The collaboration add and remove accessors call the appropriate assignment method after checking business rules.

**88. Streamlining Collaboration Accessors**

To streamline the collaboration accessors, allow one collaborator to delegate the process of establishing and dissolving the collaboration to the other collaborator.

**89. Choosing your director**

To find the direct of a streamlined collaboration, chose the specific of a generic - specific, chose the part of a whole - part, and choose the transaction of a transaction - specific.

## Collaboration Pluggability

**90. Pluggable Means Interfaces**

To make a collaboration pluggable, factor the essential communication requirements out of the current conduct business interfaces and into separate collaboration interfaces.

**91. Essential Characteristics**

Extract from business requirements any properties, services, and collaboration methods that are essential across many variations of a pluggable collaborator; include these in the pluggable collaboration interfaces.

**92. Pluggability with Integrit**y

To allow pluggability without sacrificing model integrity, design pluggable collaborations by fixing one collaborator and creating a pluggable interface for the other collaborator.

**93. Selecting pluggable collaborators**

Make pluggable the collaborator that varies the most. Lacking guidelines from the client, plug specifics into a generic; plug specifics into a transaction; plug parts into containers and assemblies; and allow groups and members to go either way.