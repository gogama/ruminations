Bulk loading
============

## Definition

Bulk loading is the process of generating a spatial data structure in
a batch or offline mode, all at once, with full knowledge of all the
data which will be stored in the data structure.

In other words, it is the process of building a read-only data structure
intended to act as a static index. Such a data structure need only
satisfy searches and, in particular, is not expected to handle
insertions or deletions.

## Applicability

### Some data structures are vulnerable to degenerate cases 

Some data structures, like the venerable and vanilla binary tree, have
nice performance properties in the "average" case but are vulnerable to
horrendous performance in certain "degenerate" cases which can occur
if insertions and deletions of particular data are done in a particular
order.†

A concrete geospatial example of this degenerate case vulnerability
phenomenon is the [R-tree](../data-structures/rtree.md).

### Bulk loading may help eliminate degenerate cases  

At the time of bulk loading into a data structure, you have immediate
access to all the data you are going to index in that data structure.

Consequently, opportunities to optimize arise. Narrowly, this means the
degenerate cases can be eliminated or minimized. More broadly it means
if you are using a data structure for indexing a static dataset and can
perform bulk loading optimizations, you can mitigate or eliminate the
risks traditionally associated with using that data structure.

To return to the vanilla binary tree example, if you have access to all
the data you want to put in the tree, you can sort it and select the
midpoint of the sorted list as your root. Continue bulk loading the
remainder of the tree following this procedure and, presto zippo, you
now have a balanced binary tree, which is the optimal form of the data
structure.

### Geospatial services using static indices

Many open and commercial geospatial services are based on periodically
generating static indices. Most of these services are read-only systems
such as geocoders which might easily rely on static indices. In fact,
not only *might* they rely on static indices but they often *benefit*
from doing so *apart* from the potential benefits of bulk loading.

For example, if part of the service being offered is a quality control
process, it can be handy to version control the source dataset so that
quality issues can be traced to particular source data; and so that
any human quality control processes can be applied in an orderly
fashion.

Suppose for the sake of argument that an organization runs a weekly
approval and release cycle for its source dataset. Then for services
based on this dataset, all data structures that search well when
their construction is optimized during bulk load should be on the table.

## Conclusion

When considering a data structure for building a geospatial service,
be aware of whether your use case can (or even must) be satisfied by
periodically bulk loading the data into an index.

When this is the case, pay close attention to the claimed deficiencies
of the data structure. If these relate to degenerate cases that can
be eliminated or mitigated by optimizing during bulk load, these
deficiencies don't apply to you and you should not consider them when
evaluating whether the data structure satisfies your use case.

---

†: *Evidently the weaknesses of vanilla binary trees can be overcome
with self-balancing variants like red-black trees, I'm just using it
as an example.*
