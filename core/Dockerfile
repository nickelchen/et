from erlang:latest
maintainer Nickel Chen <nickelchen0101@gmail.com>

run ["/bin/bash", "-c", "echo '' > /etc/apt/sources.list"]

run ["/bin/bash", "-c", "echo 'deb http://mirrors.aliyun.com/debian jessie main contrib non-free\n' >> /etc/apt/sources.list"]
run ["/bin/bash", "-c", "echo 'deb-src http://mirrors.aliyun.com/debian jessie main contrib non-free\n' >> /etc/apt/sources.list"]
run ["/bin/bash", "-c", "echo 'deb http://mirrors.aliyun.com/debian jessie-updates main contrib non-free\n' >> /etc/apt/sources.list"]
run ["/bin/bash", "-c", "echo 'deb-src http://mirrors.aliyun.com/debian jessie-updates main contrib non-free\n' >> /etc/apt/sources.list"]
run ["/bin/bash", "-c", "echo 'deb http://mirrors.aliyun.com/debian-security jessie/updates main contrib non-free\n' >> /etc/apt/sources.list"]
run ["/bin/bash", "-c", "echo 'deb-src http://mirrors.aliyun.com/debian-security jessie/updates main contrib non-free\n' >> /etc/apt/sources.list"]

run ["/bin/bash", "-c", "echo '' >> /etc/apt/sources.list"]


run apt-get clean
run apt-get update
run export DEBIAN_FRONTEND=noninteractive
run \
    apt-get install -y mysql-client libmysqlclient-dev python-mysqldb \
    && apt-get install -y python python-dev python-pip ipython \
    && apt-get install -y git wget ctags vim curl axel \
    && apt-get install -y libssl-dev libffi-dev libev4 libev-dev \
    && apt-get install -y g++ gcc libc6-dev make \
    && apt-get install -y supervisor

add ./ /core
workdir /core

