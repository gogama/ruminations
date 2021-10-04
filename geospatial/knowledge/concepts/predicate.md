Spatial predicates
==================

A spatial predicate is a true/false query about the spatial relationship
between geometries. This document lists some of the more common spatial
predicates and their practical applications:

1. [Nearest neighbour](#1-nearest-neighbour)
2. [Within distance](#2-within-distance)
3. [Thing in other thing](#3-thing-in-other-thing)
   1. Point in polygon
   2. Line in polygon
   3. Polygon in polygon

One point to keep in mind about the data structures you might use to
answer any particular data structure is that a lot depends on context:

- Is your geometry random, or does it represent real world data?
- Does your geometry change over time or is it static?
- Do you have the luxury of creating a purpose-built solution to answer
  only one specific predicate fairly optimally, or do you require a 
  generalized data structure that might need to solve a variety of
  predicates, but perhaps having less efficient performance on each
  predicate?

## 1. Nearest neighbour

Abstractly, nearest neighbour search is the optimization problem of
finding the entity closest to another given entity using a specific
optimization function. In most cases if you can obtain the 1 absolutely
nearest neighbour, you can obtain the `k` nearest neighbours (`k`-NN)
without much more effort.

In geospatial applications, the entity might be a geographic position
such as a WGS84 longitude/latitude pair.

- **Geospatial services**: *Reverse geocoding*. For example, suppose you
  have a collection of positions mapping to addresses, points of
  interest, *etc.* You are given a query position. Find the nearest
  neighbour (or `k` nearest neighbours). If you are a certain distance
  along a line between nearby addresses, there might be a reason to
  interpolate an address at that point.

Data structures: TODO.

## 2. Within-distance

## 3. Thing in other thing

### Point in polygon

### Line in polygon 

### Polygon in polygon

## 


