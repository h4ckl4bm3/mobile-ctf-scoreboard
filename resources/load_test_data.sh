#!/bin/bash

# Load users
rake mobile_ctf_scoreboard:load_user\[test@example.com,test1234,tester0\]
rake mobile_ctf_scoreboard:load_user\[testing@example.com,test1234,tester1\]
rake mobile_ctf_scoreboard:load_user\[tester@example.com,test1234,tester2\]
rake mobile_ctf_scoreboard:load_user\[tests@example.com,test1234,tester3\]
rake mobile_ctf_scoreboard:load_user\[testing2@example.com,test1234,tester4\]

# Create Rounds (2 with one attack/defend, 1 with 2)
rake mobile_ctf_scoreboard:load_round\[00:12:00,00:47:00\]
rake mobile_ctf_scoreboard:load_round\[01:02:00,01:37:00\]
rake mobile_ctf_scoreboard:load_round\[01:52:00,03:02:00\]

# Create Defend Periods
rake mobile_ctf_scoreboard:load_defend_period\[15,1,00:12:00\]
rake mobile_ctf_scoreboard:load_defend_period\[15,1,01:02:00\]
rake mobile_ctf_scoreboard:load_defend_period\[15,1,01:52:00\]
rake mobile_ctf_scoreboard:load_defend_period\[15,1,02:27:00\]

# Create Attack Periods
rake mobile_ctf_scoreboard:load_attack_period\[15,4,00:28:00\]
rake mobile_ctf_scoreboard:load_attack_period\[15,4,01:20:00\]
rake mobile_ctf_scoreboard:load_attack_period\[15,4,02:08:00\]
rake mobile_ctf_scoreboard:load_attack_period\[15,4,02:43:00\]

# Create a new flag for each Attack Round
rake mobile_ctf_scoreboard:load_flags_for_period\[00:33:00\]
rake mobile_ctf_scoreboard:load_flags_for_period\[01:25:00\]
rake mobile_ctf_scoreboard:load_flags_for_period\[02:12:00\]
rake mobile_ctf_scoreboard:load_flags_for_period\[02:48:00\]
