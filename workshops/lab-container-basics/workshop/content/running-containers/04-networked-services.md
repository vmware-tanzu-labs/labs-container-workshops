All the containers you have run so far remained attached to the terminal from which they were run. The output from the container was displayed to the terminal and you only got the command prompt back when the container was stopped.

Long lived network services run in a container will need to be detached from the terminal and run as a background process.

To run a web server using the `busybox` image run:

```execute
docker run --rm -d --name httpd -p 8080:80 busybox httpd -f -vv
```

The `-d` option to `docker run` causes the container to be detached from the terminal and run in the background.

To allow us to more easily identify and interact with the container, we use the `--name` option to give it the name `httpd`.

As the web server is a network service, we need to specify the network ports it exposes. This is done using the `-p` option.

Finally, for the command run in the container, we use `httpd -f -vv`.

The `-f` option to `httpd` ensures that the web server runs as a foreground process within the context of the container. If this is not done, the container would exit immediately. The `-vv` enables verbose logging.

To verify that the container is running, run:

```execute
docker ps
```

To tail the output from the container, run:

```execute
docker logs -f httpd
```

Instead of the container ID, we use the `httpd` name we assigned to the container. The `-f` option says to tail the log files continually.

Initially there will be no log output, but make a web request against the web server by running:

```execute-2
curl localhost:8080
```

and you should see the details of the request logged.

In this case we get an error from the web server as we didn't provide it any files to serve up.

As the container has been detached from the terminal, to stop the container you need to run:

```execute-2
docker stop --time 2 httpd
```
