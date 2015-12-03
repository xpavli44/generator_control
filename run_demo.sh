#!/bin/bash
#set variables

#initial user count for generator to be used
user_count=10

#how many times will users be inceased
num_iterations=10

#how many users will be added with an iteration
iteration_increment=10

#how long will generator run in one round
generator_time_to_run_mins=60

#where is the generator?
generators=(10.199.18.179 10.199.16.148 10.199.16.151 10.199.16.167)

#where is grafana?
grafana_ip="10.199.16.164"

num_generators=user_count_split=${#generators[@]}
user_count_split=$((user_count/num_generators))

for (( c=1; c<=num_iterations; c++ ))
do
	echo -e " ### Starting test for $user_count users ### "
	#configrue generator and start it
	date
	for generator in "${generators[@]}"
	do
		echo -e "Starting generator @ $generator"
		if [ "$generator" == "10.199.18.179" ]; then
			ssh Administrator@"$generator" "cd c:\; .\generator_configure.ps1 -UserCount $((user_count_split*2)) -TimeToRunMins $generator_time_to_run_mins; .\generator_start.ps1" > /dev/null &
		else
			ssh Administrator@"$generator" "cd c:\; .\generator_configure.ps1 -UserCount $user_count_split -TimeToRunMins $generator_time_to_run_mins; .\generator_start.ps1" > /dev/null &
		fi
	done
	echo -e "DONE\n"

	#Wait one minute for the generator to start
	date
	echo -e "will go to sleep for 1 minute for generator to start"
	sleep 60s
	echo -e "DONE\n"

	#start grafana test
	date
	echo -e "Starting grafana test @ $grafana_ip"
	ssh root@$grafana_ip "bash /root/run_grafana_test.sh $user_count" > /dev/null &
	echo -e "DONE\n"

	#wait for time to run /2
	date
	echo -e "will go to sleep for $((generator_time_to_run_mins/2)) minutes which will expire @ $(date --date "+$((generator_time_to_run_mins/2)) min")"
	sleep $((generator_time_to_run_mins/2))m
	echo -e "DONE\n"

	#kill the generator
	date
	for generator in "${generators[@]}"
        do
		echo -e "Stopping generator @ $generator"
		ssh Administrator@"$generator" "cd c:\; .\generator_kill.ps1"
	done
	echo -e "DONE\n"

	#wait for 10s to be sure that generator is dead
	echo -e "will sleep for 10 secods to make sure generator is dead"
	sleep 10s
	echo -e "DONE\n"

	#copy logs
	date
	for generator in "${generators[@]}"
        do
		echo -e "Backing up logs for $user_count users on the generator"
		ssh Administrator@"$generator" "cd c:\; .\generator_copy_log -UserCount $user_count -Part 1"
	done
	echo -e "DONE\n"

	#configrue generator and start it
        date
        for generator in "${generators[@]}"
        do
                echo -e "Starting generator @ $generator"
                if [ "$generator" == "10.199.18.179" ]; then
                        ssh Administrator@"$generator" "cd c:\; .\generator_configure.ps1 -UserCount $((user_count_split*2)) -TimeToRunMins $generator_time_to_run_mins; .\generator_start.ps1" > /dev/null &
                else
                        ssh Administrator@"$generator" "cd c:\; .\generator_configure.ps1 -UserCount $user_count_split -TimeToRunMins $generator_time_to_run_mins; .\generator_start.ps1" > /dev/null &
                fi
        done
        echo -e "DONE\n"

	 #wait for time to run /2
        date
        echo -e "will go to sleep for $((generator_time_to_run_mins/2)) minutes which will expire @ $(date --date "+$((generator_time_to_run_mins/2)) min")"
        sleep $((generator_time_to_run_mins/2))m
        echo -e "DONE\n"

        #kill the generator
        date
        for generator in "${generators[@]}"
        do
                echo -e "Stopping generator @ $generator"
                ssh Administrator@"$generator" "cd c:\; .\generator_kill.ps1"
        done
        echo -e "DONE\n"

        #wait for 10s to be sure that generator is dead
        echo -e "will sleep for 10 secods to make sure generator is dead"
        sleep 10s
        echo -e "DONE\n"

        #copy logs
        date
        for generator in "${generators[@]}"
        do
                echo -e "Backing up logs for $user_count users on the generator"
                ssh Administrator@"$generator" "cd c:\; .\generator_copy_log -UserCount $user_count -Part 2"
        done
        echo -e "DONE\n"
	


	#increment counter
	user_count=$((user_count+iteration_increment))
done
