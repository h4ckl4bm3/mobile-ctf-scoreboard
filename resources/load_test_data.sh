#!/bin/bash

# Load users
rake mobile_ctf_scoreboard:load_user\[test@example.com,test1234,tester0\]
rake mobile_ctf_scoreboard:load_user\[testing@example.com,test1234,tester1\]
rake mobile_ctf_scoreboard:load_user\[tester@example.com,test1234,tester2\]
rake mobile_ctf_scoreboard:load_user\[tests@example.com,test1234,tester3\]
rake mobile_ctf_scoreboard:load_user\[testing2@example.com,test1234,tester4\]
