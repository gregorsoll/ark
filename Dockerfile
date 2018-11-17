# Volumes to map
#/home/steam/ARK                              for arkinstallation filed
#/home/steam/.config/arkmanager/instances     for arkmanager config file


from centos
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]


#ports for ark
EXPOSE 27016/udp
EXPOSE 27016/tcp
EXPOSE 7778/udp
EXPOSE 7778/tcp
EXPOSE 32330/tcp

#requirements
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && yum -y install glibc.i686 libstdc++.i686 sudo perl-Compress-Zlib lsof bzip2 nano ntpdate && yum -y update && yum clean all 

#steamcmd
RUN useradd -m steam && usermod -aG wheel steam &&  su - steam -c "mkdir steamcmd && cd steamcmd && curl -sqL 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar zxvf - && ./steamcmd.sh +quit"


#RUN iptables -I INPUT -p udp --dport 27016 -j ACCEPT && iptables -I INPUT -p tcp --dport 27016 -j ACCEPT && iptables -I INPUT -p udp --dport 7778 -j ACCEPT &&  iptables -I INPUT -p tcp --dport 7778 -j ACCEPT && iptables -I INPUT -p tcp --dport 32330 -j ACCEPT
#firewall-cmd --zone=public --add-port=27016/tcp --permanent
#firewall-cmd --zone=public --add-port=27015/udp --permanent
#firewall-cmd --zone=public --add-port=7778/tcp --permanent
#firewall-cmd --zone=public --add-port=7778/udp --permanent
#firewall-cmd --zone=public --add-port=32330/tcp --permanent
#firewall-cmd --reload

#arkmanager
run su - steam -c "curl -sL http://git.io/vtf5N | bash -s -- --me --perform-user-install"

#install ark
run su - steam -c "arkmanager install --verbose --me"

#install mods
run su - steam -c "arkmanager installmod 893904615,710450473,821530042,600015460,719928795,699984901,733089781,895711211,497432858,764755314,731604991"



#install ark manually not needed because of arkmanager
#run su - steam -c "mkdir ark && ./steamcmd.sh +login anonymous +force_install_dir ./ark +app_update 376030 +quit"


# minimum main.cfg for arkmanager / if installed as user then in /home/steam/.config/arkmanager/instances
#arkserverroot="/home/steam/ARK"                                     # path of your ARK server files (default ~/ARK)
#serverMap="TheIsland"                                               # server map (default TheIsland)
#ark_RCONEnabled="True"                                              # Enable RCON Protocol
#ark_RCONPort="32330"                                                # RCON Port
#ark_SessionName="ARK Server Tools"                                  # if your session name needs special characters please use the .ini instead
#ark_Port="7778"                                                     # ARK server port (default 7778)
#ark_QueryPort="27015"                                               # ARK query port (default 27015)
#ark_ServerPassword="secret"                                               # ARK server password, empty: no password required to login
#ark_ServerAdminPassword="keyboardcat"                               # ARK server admin password, KEEP IT SAFE!
#ark_MaxPlayers="70"

WORKDIR /mone/steam/ARK
USER steam



# startsequence
CMD arkmanager run 



STOPSIGNAL SIGINT



#to staRT THE CONTAINER 
#docker run -d -v /opt/ark/Saved:/home/steam/ARK/ShooterGame/Saved -v /opt/ark/instances:/home/steam/.config/arkmanager/instances -v /opt/ark/downloading:/home/steam/ARK/steamapps/downloading -p 7778:7778 -p 27015:27015/udp ark:latest
