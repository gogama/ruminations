Space-filling curves
====================

1. [Definition](#1-definition)
2. [Examples](#2-examples)
    1. [Hilbert curve](#1-hilbert-curve)
3. [Applications](#3-applications)
   1. [Relational databases](#1-relational-databases)
   2. [Non-relational databases](#2-non-relational-databases)
   3. [Geospatial technologies based on space-filling curves](#3-geospatial-technologies-based-on-space-filling-curves)

## 1. Definition

Space-filling curves sound complicated and hard to understand, but
the idea behind them is actually pretty simple to grasp. The math is
fascinating, and might be a bit challenging, but you can understand what
a space-filling curve is and how it applies to geospatial applications
without needing to deeploy understand the mathematics. 

A space-filling curve gives you a one-parameter function that maps
points in an *n*-dimensional space (*e.g.* a square, a cube, *etc.*) to
points in a one-dimensional space (*i.e.* a line segment) and the
inverse of that function mapping a points in the one-dimensional space
back into that multi-dimensional space.

Essentially it gives you these functions:

```
f(x, y, ...) = d
g(d) = (x, y, ...)
```

Or to put it a bit more technically, here is what Wikipedia says a
space-filling curve is, but don't worry if it makes your eyes glaze
over...

> Intuitively, a curve in two or three (or higher) dimensions can be
> thought of as the path of a continuously moving point. To eliminate
> the inherent vagueness of this notion, Jordan in 1887 introduced the
> following rigorous definition, which has since been adopted as the
> precise description of the notion of a curve:
>
> A curve (with endpoints) is a continuous function whose domain is the
> unit interval [0, 1]. In the most general form, the range of such a
> function may lie in an arbitrary topological space, but in the most
> commonly studied cases, the range will lie in a Euclidean space such
> as the 2-dimensional plane (a planar curve) or the 3-dimensional space
> (space curve).
>
> Sometimes, the curve is identified with the image of the function
> (the set of all possible values of the function), instead of the function itself. It is also possible to define curves without endpoints to be a continuous function on the real line (or on the open unit interval (0, 1)).
>
> ... [A *space-filling*] curve is a curve whose range contains the entire
> 2-dimensional unit square (or more generally an n-dimensional unit
> hypercube).

## 2. Examples

### 1. Hilbert curve

A Hilbert curve is a type of space-filling curve first described by the
German mathematician David Hilbert in 1891.

Both the true Hilbert curve and its discrete approximations are useful
because they give a mapping between 1D and 2D space that preserves
locality fairly well. This means that two data points which are close to
each other in one-dimensional space are also close to each other after
folding. Note, however, that the converse is not always true, meaning
points which are far away from each other in two-dimensional space may
become close to each other after folding.

![Diagram of a Hilbert curve, lifted from Wikipedia's article
on Hilbert curves. See below for attribution.](hilbert-curve.svg)

*Image attribution: [by Braindrain0000, CC BY-SA 3.0](https://commons.wikimedia.org/w/index.php?curid=47570255)
and lifted by me from Wikipedia.*

See [`hilbert.go`](https://github.com/gogama/geospat/blob/main/hilbert/hilbert.go)
for an example implementation of a discrete curve mapping in Go.

## 3. Applications

Space-filling curves are powerful tools for spatial indexing, because
they allow you to convert a query in *n*-dimensional space into a range
extract over one-dimensional space. For example, by projecting points
in the two-dimensional WGS84 coordinate system into a linear space using
a space-filling curve, you can quickly generate a range extract over the
one-dimensional space to search for any particular point.

### 1. Relational databases

How might this apply in practice? Consider, for example, a relational
database system such as MySQL or Oracle. The mainstay of RDBMS indexing
is a data structure called a B-tree which indexes a one-dimensional
space. By mapping your two-dimensional coordinates into one-dimensional
space using a space-filling curve, you can index them in a plain vanilla
RBMS using their standard indexing technology.†

### 2. Non-relational databases

As another example, many existing NoSQL databases offer fairly basic
indexing features. For example at the time of this writing, in September
2021, Amazon's cloud NoSQL product, DynamoDB, offers only hash-based and
range-extract based indexing. For indexing geospatial data in this type
of database, a space-filling curve conveniently bridges the gap between
your spatial data and the indexing facilities actually available in the
database.

### 3. Geospatial technologies based on space-filling curves

- Google's [S2 data structure](../data-structures/s2.md) for shapes
  drawn on spheres.
- Amazon's Aurora RDBMS indexes space using a
  [B-tree with space-filling Z-order curve](../data-structures/btree-z-order-curve.md).

---

†: *Of course, many RDBMS and NoSQL databases have their own geospatial
indexing technology which would often make your explicit usage of a
Hilbert curve unnecessary. This is just an example.*
