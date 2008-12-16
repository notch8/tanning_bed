tanning_bed
    by Rob Kaufman (notch8.com)
    with permission and support from the Assay Depot (assaydepot.com)

== DESCRIPTION:

Tanning Bed is Solr for models.
Tanning Bed provides a Ruby interface for the Solr (http://lucene.apache.org/solr/) search engine to use in you're models not matter whether they are Datamapper, Active Record, Couchrest or just general Ruby classes.

== FEATURES/PROBLEMS:

* Incredibly simple in design, no fancy hooks
* Very Ruby

== SYNOPSIS:

  Objects must implement:
  
  * id - unique identifier for the record
  * solr_keys - an array of method names, the method results will be added to the index
  
  FIXME (code sample of usage)

== REQUIREMENTS:

* Solr (bundled)
* Solr-Ruby library (bundled)

== INSTALL:

* sudo gem install notch8-tanning-bed --source http://gems.github.com

== LICENSE:

(The MIT License)

Copyright (c) 2008 Assay Depot Inc.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
