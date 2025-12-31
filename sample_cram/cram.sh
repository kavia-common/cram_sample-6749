#!/bin/bash

export TARGET_DUT_LAN_IP="192.168.1.1"
export CRAM_REMOTE_COMMAND="ssh root@$TARGET_DUT_LAN_IP"


echo "Start to run cram test..."

run_check() {
    "$@" || {
        local statuses=("${PIPESTATUS[@]}")
        for status in "${statuses[@]}"; do
            if [ "$status" -ne 0 ]; then
                echo "run_check: $* | FAILED! (status: $status)" >> .run_check_failed
            fi
        done
    }
}

# ssh rule
rm -f ~/.ssh/known_hosts
ssh -o StrictHostKeychecking=no root@192.168.1.1 ls

#run_check ssh root@$TARGET_DUT_LAN_IP 'logger -t CI -p local0.info "Testing starts, $(uptime -p)"'

#Run All files in the folder
#run_check python3 -m cram --verbose ./sample_case/ | tee --append ./output/report_sample.txt

#run_check python3 -m cram --verbose ./sample_case/iptables/ | tee --append ./output/report_sample.txt


#Run single script
run_check python3 -m cram --verbose ./sample_case/03-sample3.t | tee --append ./output/report_sample.txt
