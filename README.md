# Instructions for ctf admin:
### Deploy:

* Use the chef script (will be supplied)
* To do so:

    1. Move the scripts over (scp -r rails-app-cookbook ubuntu@ip-address:mobile-ctf-scoreboard)
    2. Enter the server (ssh ubuntu@ip-address)
    3. Install chef if not already done (curl -L https://www.chef.io/chef/install.sh | sudo bash)
    4. Enter the script folder (cd mobile-ctf-scoreboard)
    5. Run the chef scripts (sudo chef-client -z -j node.json)

###To control the active game instance, use the rake tasks:

* Must be executed from the rails app folder (/opt/mobile-scoreboard/current)
* To view all available rake tasks, run `rake -T`
* Most fields are optional and can be excluded (usually the railing ones)
#### Basics
##### Round management
* Creation
  * `rake mobile_ctf_scoreboard:load:round[integrity_point_value,start,finish]`
    * integrity_point_value is the value to use for this rounds integrity checks
    * start is the time the period should start (enter full time with minutes, defaults to “Now")
    * finish is the time the period should finish (enter full time with minutes, defaults to nil)
      * ex: 
        * `rake mobile_ctf_scoreboard:load:round\[30\]`
        *  creates round that starts now, has no ending (yet), and has an integrity checks are worth 30 points
  * `rake mobile_ctf_scoreboard:load:round\[20,01:52:00,03:02:00\]`
  * Creates round that start at 1:52a.m., ends 3:02a.m., and has 20 point integrity checks
                * If no finish time is entered, it is expected that one will be applied at some point
* Update end
  * `rake mobile_ctf_scoreboard:update:end_round[finish]`
                * Where finish is empty (for “now”) or a time to finish the current running round
                * Will pick the first round if there are multiple (should not be)
                    * If there is, run twice
##### Attack Period create
* `rake mobile_ctf_scoreboard:load:attack_period[flag_points,submission_point_multiplier,duration_in_minutes,offset_in_minutes,start]`
    * flag_points are how much flags are worth this attack period (in terms of owning them)
        * Note: these are the full points to give a team with no flag steals. Each steal will depreciate these points by flag_points/#_of_teams
    * submission_point_multiplier is the amount to multiply the partial flag points worth for a team to, so (flag_points/#_of_teams)*multiplier
    * duration_in_minutes is the number of minutes to runt eh attack period for (ends at that point)
        * Defaults to 15
    * offset_in_minutes is the offset when to start the attack period from the given start period
        * Defaults to 0
    * start is the time to start the attack period and if nil, runs “now”
##### Defend period create
* `rake mobile_ctf_scoreboard:load:defend_period[duration_in_minutes,offset_in_minutes,start]`
    * duration_in_minutes is the duration of the defense period
        * Defaults to 15
    * offset_in_minutes is the offset in minutes to when the defense period should start from the given time
        * Defaults to 0
    * start is the time at which the event should start
        * Defaults to “now”
##### Flag generation for a round
* `rake mobile_ctf_scoreboard:load:flags_for_period[attack_start,flag]`
    * attack_start is the time that the attack period start
        * defaults to now
    * flag is what to use for the flag (if necessary for testing)
        * defaults to a SHA hash
##### Send Message to all participants
* `rake mobile_ctf_scoreboard:load:message:to_all[subject,message,sent_at]`
    * subject is the subject for the message
    * message is the actual message to send
    * sent_at is the time at which the message should state it’s been sent
        * defaults to now
##### Send Message to individual participant
* `rake mobile_ctf_scoreboard:load:message:to_user[user_id,subject,message,sent_at]`
    * user_id is the id of the team to send the message to
    * subject is the subject line of the message
    * message is the message body
    * sent_at is the time which the message should state it’s been sent
        * defaults to now
#### Moderate
##### Signing/build apps
        * TBD
#### Advanced
##### Testing
* TBD
* Will use Integrity 
* Submitting test flags
  * for a successful flag submission `rake mobile_ctf_scoreboard:test:successful_flag_submissions_for_period[user_id,owner_id,attack_start]`
  * for a failure `rake mobile_ctf_scoreboard:test:failing_flag_submissions_for_period[user_id,owner_id,attack_start]`
##### Integrity
* `rake mobile_ctf_scoreboard:load:integrity_check_result[user_id,success,submitted_at]`
  * user_id is the id of the team this check is submitted for
  * success is the boolean for whether or not the test was successful
  * submitted_at was the time that this tests submitted
    * defaults to now
##### Running Challenge servers
* TBD
* needs to include scripts to generate DBs (for May’s app)
### DB setup
#### Initialization commands (if necessary)
#### Loading test elements
* call `./resources/load_test_data.sh` to load the base test data