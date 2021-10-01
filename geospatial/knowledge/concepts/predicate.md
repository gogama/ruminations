Spatial predicates
==================

A spatial predicate is a true/false query about the spatial relationship
between geometries. This document lists some of the more common spatial
predicates and their practical applications:

1. [Nearest neighbour](#1-nearest-neighbour)
2. [Distance to](#2-distance-between)
3. [Thing in other thing](#3-thing-in-other-thing)
   1. Point in polygon
   2. Line in polygon
   3. Polygon in polygon

## 1. Nearest neighbour

Abstractly, nearest neighbour search is the optimization problem of
finding the entity closest to another given entity using a specific
optimization function. In most cases if you can obtain the 1 absolutely
nearest neighbour, you can obtain the `n` nearest neighbours without
much more effort.

In geospatial applications, the entity might be a geographic position
such as a WGS84 longitude/latitude pair.

- **Geospatial services**: *Reverse geocoding*. For example, suppose you
  have a collection of positions mapping to addresses, points of
  interest, *etc.* You are given a query position. Find the nearest
  neighbour (or `n` nearest neighbours). If you are a certain distance
  along a line between nearby addresses, there might be a reason to
  interpolate an address at that point.

Data structures: TODO.

## 2. Distance between

## 3. Thing in other thing

### Point in polygon

### Line in polygon 

### Polygon in polygon

## 
