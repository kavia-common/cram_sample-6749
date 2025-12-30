markdown
```shell
├── run_cram_test.sh	==> start case 
├── README.md
├── output/    			==> Test report
├── sample_case/		==> Test case
├── sample_cram/		==> Cram script(docker run import)
└── testbed/			==> Testbed (host pc first run need build image)
```

0.build dock image (First)
  "
  cd ./testbed/
  docker build -t cram-testbed .
  "

1. load test fw to DUT

2. enable ssh

3. Confirm host PC get ip from DUT

4. Crate test case
  "
  cd ../sample_case/
  ls
  "

5. Folder for specified test
  "
  cd ../sample_cram/
  vi cram.sh
  run_check python3 -m cram --verbose ./sample_case/ | tee --append ./output/report_sample.txt
  "

6. Execute docker_script.sh
  "
  cd ../
  sudo sh ./run_cram_test.sh
  "

7. Confirm test result
  "
  cat output/report_sample.txt
  "
