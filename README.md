# Instructions

```shell
pack build dertour --buildpack paketo-buildpacks/python --builder paketobuildpacks/builder-jammy-base
docker run -it --rm -p 8000:8000 dertour
```
