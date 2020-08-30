# [jmeter image](https://hub.docker.com/r/justb4/jmeter)

# Spring Chart Sample

[Spring](http://spring.io/) is a modern Java framework for developing Cloud Native Applications.

## Chart Details

This chart is designed to be a general purpose chart for running Spring based applications, most simple Spring applications should run with little to no modification of this Chart. For the sake of example this chart is configured to deploy the Spring Petclinic example application, but simply changing the image and tag should be enough to run a different app.

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release snappyflow/sample-petclinic
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete --purge my-release
```

The command removes nearly all the Kubernetes components associated with the
chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the drone charts and their default values.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
helm install --name my-release -f values.yaml snappyflow/sample-petclinic
```
