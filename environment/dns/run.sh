# docker run --name bind -d --restart=always --publish 53:53/tcp --publish 53:53/udp --publish 10000:10000/tcp --volume C:\srv\bind:/data sameersbn/bind:9.11.3-20190706
docker run --name bind -d --restart=always --publish 53:53/tcp --publish 53:53/udp --publish 10000:10000/tcp --volume /srv/bind:/data sameersbn/bind:9.11.3-20190706

# Log into https://localhost:10000/ using root/password

# Follow this to set up DNS https://doxfer.webmin.com/Webmin/BIND_DNS_Server

# Set the master zone to be `evelyn.internal`

# Add an address record for your kubernetes nodes
# - master.kube.evelyn.internal
# - slave.kube.evelyn.internal
# - app.evelyn.internal (to host locally)

# Add alias records for a Kubernetes node which host applications.
# - keycloak.evelyn.internal
# - rabbitmq-console.evelyn.internal
# - service.evelyn.internal

# Nothing will be visible until apply changes has been clicked. This is a tiny refresh icon in the top right of the top
# level page. :)

# In order for other machines to be able to use this DNS server they will need to be configured to.
# On Windows, change adapter settings. On Linux, add a nameserver record.
