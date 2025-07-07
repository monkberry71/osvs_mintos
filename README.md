Building the docker image
```
docker build -t osvs_mint_env . // build the image
```

Running
```
docker run -it --rm -v "$PWD:/workspace" osvs_mint_env
```
