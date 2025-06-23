FROM debian

ARG REGION=ap
ENV DEBIAN_FRONTEND=noninteractive

# Install SSH and dependencies
RUN apt update && apt upgrade -y && apt install -y \
    ssh wget unzip vim curl python3

# Setup SSH (allow root login and set the password)
RUN mkdir /run/sshd \
    && echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config \
    && echo root:dark | chpasswd

# Expose necessary ports (e.g., SSH on port 22)
EXPOSE 22

# Start SSH and tunnel via Serveo
CMD /usr/sbin/sshd -D & ssh -R 80:localhost:22 serveo.net
