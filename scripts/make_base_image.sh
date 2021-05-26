#!/usr/bin/env bash


echo "making base box"
rm -f package.box
vagrant package base
vagrant box add package.box --name mybase --force