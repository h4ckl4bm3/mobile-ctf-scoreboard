#!/bin/bash

# Load users
rake mobile_ctf_scoreboard:load_player\[test@example.com,test1234,tester0\] RAILS_ENV=development
rake mobile_ctf_scoreboard:load_player\[testing@example.com,test1234,tester1\] RAILS_ENV=development
rake mobile_ctf_scoreboard:load_player\[tester@example.com,test1234,tester2\] RAILS_ENV=development
rake mobile_ctf_scoreboard:load_player\[tests@example.com,test1234,tester3\] RAILS_ENV=development
rake mobile_ctf_scoreboard:load_player\[testing2@example.com,test1234,tester4\] RAILS_ENV=development

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
rake mobile_ctf_scoreboard:load_attack_period\[15,4,01:18:00\]
rake mobile_ctf_scoreboard:load_attack_period\[15,4,02:08:00\]
rake mobile_ctf_scoreboard:load_attack_period\[15,4,02:43:00\]

# Create a new flag for each Attack Round
rake mobile_ctf_scoreboard:load_flags_for_period\[00:33:00\]
rake mobile_ctf_scoreboard:load_flags_for_period\[01:25:00\]
rake mobile_ctf_scoreboard:load_flags_for_period\[02:13:00\]
rake mobile_ctf_scoreboard:load_flags_for_period\[02:48:00\]

# Create the integrity check results
rake mobile_ctf_scoreboard:load_integrity_check_result\[1,true,02:06:00\]
rake mobile_ctf_scoreboard:load_integrity_check_result\[2,true,02:06:00\]
rake mobile_ctf_scoreboard:load_integrity_check_result\[3,true,02:06:00\]
rake mobile_ctf_scoreboard:load_integrity_check_result\[4,true,02:06:00\]
rake mobile_ctf_scoreboard:load_integrity_check_result\[5,true,02:06:00\]
rake mobile_ctf_scoreboard:load_integrity_check_result\[1,false,00:26:00\]
rake mobile_ctf_scoreboard:load_integrity_check_result\[1,false,02:40:00\]
