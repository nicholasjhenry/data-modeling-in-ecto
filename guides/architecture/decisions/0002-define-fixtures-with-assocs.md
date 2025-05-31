# 2. Define fixtures with assocs

Date: 2025-05-28

## Status

Accepted

## Context

A test case requiring a database fixture with a collaborating association needs the associated record
to be valid.

## Decision

As with the action functions of a context module, associated records are added to the fixture signature
as the first arguments. As with `attrs` argument, a default is provided for associated records.

## Consequences

This reduces the burden on the test to create the associated record everytime.
