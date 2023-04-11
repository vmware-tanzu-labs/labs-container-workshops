FROM fedora:37

# This line is only here for compatability with workshop environment.
RUN echo "set enable-bracketed-paste off" >> /etc/inputrc

RUN dnf install -y --setopt=tsflags=nodocs findutils procps which && \
    dnf clean -y --enablerepo='*' all

COPY hello goodbye /

CMD [ "/hello" ]
