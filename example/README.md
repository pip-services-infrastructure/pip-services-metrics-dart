This is the metrics microservice. It keeps list of metrics.

This microservice is designed to manage various metrics characterizing the operation of a process.
Each metric has the following characteristics:
- metric name
- up to 3 types of measurements (in string format)
- date and time
is a numerical value characterizing the metric

When adding or updating a metric, statistics on the metric are automatically calculated for different time horizons (you can specify the depth of the horizon) with the calculation of the average, maximum, minimum and accumulated values ​​within each of them.

Data access is provided through a set of API functions

The microservice currently supports the following deployment options:
* Deployment platforms: Standalone Process
* External APIs: HTTP/REST
* Persistence: Memory, Flat Files, MongoDB

For examples see Readme.md file on GitHub.