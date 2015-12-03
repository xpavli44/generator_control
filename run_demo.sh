#!/bin/bash
#set variables
#initial user count for generator to be used
user_count=10
#how many times will users be inceased
num_iterations=11
#how many users will be added with an iteration
iteration_increment=10
#how long will generator run in one round
generator_time_to_run_mins=55
#where is the generator?
generator_ip="10.199.18.179"
#where is grafana?
grafana_ip="10.199.16.164"

for (( c=1; c<=$num_iterations; c++ ))
do
	echo -e " ### Starting test for $user_count users ### "
	#configrue generator and start it
	echo `date`
	echo -e "Starting generator @ $generator_ip"
	ssh Administrator@$generator_ip "cd c:\; .\generator_configure.ps1 -UserCount $user_count -TimeToRunMins $generator_time_to_run_mins; .\generator_start.ps1" > /dev/null &
	echo -e "DONE\n"

	#Wait one minute for the generator to start
	echo `date`
	echo -e "will go to sleep for 1 minute for generator to start"
	sleep 1m
	echo -e "DONE\n"

	#start grafana test
	echo `date`
	echo -e "Starting grafana test @ $grafana_ip"
	ssh root@$grafana_ip "bash /root/run_grafana_test.sh $user_count" > /dev/null &
	echo -e "DONE\n"

	#wait for time to run
	echo `date`
	echo -e "will go to sleep for $generator_time_to_run_mins minutes which will expire @ `date --date "+${generator_time_to_run_mins} min"`"
	sleep ${generator_time_to_run_mins}m
	echo -e "DONE\n"

	#kill the generator
	echo `date`
	echo -e "Stopping generator @ $generator_ip"
	ssh Administrator@$generator_ip "cd c:\; .\generator_kill.ps1"
	echo -e "DONE\n"

	#wait for 30s to be sure that generator is dead
	echo -e "will sleep for 30 secods to make sure generator is dead"
	sleep 30s
	echo -e "DONE\n"

	#copy logs
	echo `date`
	echo -e "Backing up logs for $user_count users on the generator"
	ssh Administrator@$generator_ip "cd c:\; .\generator_copy_log -UserCount $user_count"
	echo -e "DONE\n"

	#increment counter
	user_count=$((user_count+iteration_increment))
done
