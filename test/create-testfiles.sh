#!/bin/sh
rm -rfv ./in/*
rm -rfv ./out/*
echo "creating files in in dir"
echo "foobar" > ./in/test-1.txt
openssl rand -base64 80000000 > ./in/test-2.txt
openssl rand -base64 500000 > ./test-3.txt
mv "test-3.txt" ./in
openssl sha1  ./in/test-1.txt > ./out/test-1.in.txt
openssl sha1  ./in/test-2.txt  > ./out/test-2.in.txt
openssl sha1  ./in/test-3.txt  > ./out/test-3.in.txt

say "sleep"
sleep 45

openssl sha1  ./out/test-1.txt > ./out/test-1.out.txt
openssl sha1  ./out/test-2.txt > ./out/test-2.out.txt
openssl sha1  ./out/test-3.txt > ./out/test-3.out.txt
say "done"