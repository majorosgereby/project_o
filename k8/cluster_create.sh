#!/bin/bash

eksctl create cluster \
--name projecto-cluster \
--version 1.32 \
--region eu-west-2 \
--nodegroup-name project-o-linux-nodes \
--node-type t2.medium \
--nodes 2