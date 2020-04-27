FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y wget gnupg2

RUN wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb

RUN dpkg -i erlang-solutions_2.0_all.deb
RUN apt-get update && apt-get install -y esl-erlang elixir=1.10.2-1
