ProjectMetricPivotalTracker
===========================

For assessing Pivotal Tracker activity.


=======
Required Configuration Variable
-------------------------------

* project: ID of the project.
* token: API token. Any Pivotal Tracker user can generate an API token. The token can be used to access private projects of the user, and all public projects.

TODO 
----

* [x] vcr setup into a different file
* [ ] remove memoization
* [ ] should raw data be more raw (i.e. serialization of HTTP requests? project entity?)
* [ ] work out why we need sorting
