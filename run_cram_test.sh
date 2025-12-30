echo "start test"

docker run --privileged=true \
           -e "TZ=Asia/Taipei" \
           --rm \
           -v "$PWD:/workspace" \
           --network host \
           -w /workspace \
           cram-testbed \
           ./sample_cram/cram.sh
