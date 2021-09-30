# pi-bootbuilder

pi-bootbuilder is a small docker based tool that generates the data for the boot
partition for raspberry pi 3+4 (aarch64) based on
[u-boot](https://github.com/u-boot/u-boot). 
This is designed to run on every platform that supports cross-compiling to aarch64
on ubuntu:latest.

## Building the docker image

```terminal
$> docker build . -t pi-bootbuilder:latest
```

## Running the build

```terminal
$> docker run -v $(pwd)/output:/data/output pi-bootbuilder:latest
```

The contents of `$(pwd)/output` should then be copied to the boot partition of
the sd-card.
