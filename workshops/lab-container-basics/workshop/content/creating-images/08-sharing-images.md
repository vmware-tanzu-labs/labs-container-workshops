Once you have built your own custom container image you will need a way of distributing it if you need to run it on a different host system.

The normal way to distribute container images is to push them up to an image registry. Once they are pushed up to the image registry they can be pulled down to other hosts and run. For this you can use public image registries such as Docker Hub and Quay.io, or you could use your own private image registry.

To push an image to an image registry, you would first need to login to that image registry.

In this workshop environment you have your own private image registry to which you have already been logged in. If you had to do it yourself you would use the ``docker login`` command, giving it the location of the image registry. You would then be prompted for the login credentials.

The next step is that you need to tag your container image with a name that incorporates the name of the image registry.

The name of your image at this point is ``greeting``, so to tag it with a name including the name of the image registry, you need to run:

```execute
docker tag greeting:latest {{REGISTRY_HOST}}/greeting:latest
```

To push the image to the image registry, then run:

```execute
docker push {{REGISTRY_HOST}}/greeting:latest
```

The command works out which image registry to push it to from the tag you added which includes the registry name.

Anyone with the appropriate access to the image registry could now pull it down to a different host by running:

```execute
docker pull {{REGISTRY_HOST}}/greeting:latest
```
